//
//  LVCAuthenticatedClient.m
//  LayerVaultAPI
//
//  Created by Matt Thomas on 1/2/14.
//  Copyright (c) 2014 LayerVault. All rights reserved.
//

#import "LVCAuthenticatedClient.h"
#import "LVCUser.h"
#import "LVCRetryOperationShell.h"
#import "LVCTreeBuilder.h"
#import "NSURLRequest+OAuth2.h"
#import "NSMutableURLRequest+OAuth2.h"
#import <AFOAuth2Client/AFOAuth2Client.h>
#import <AFNetworking/AFNetworking.h>

static void *LVCAuthenticatedClientContext = &LVCAuthenticatedClientContext;

NSString * const LVCAuthenticationStateDescription[] = {
    [LVCAuthenticationStateUnauthenticated] = @"LVCAuthenticationStateUnauthenticated",
    [LVCAuthenticationStateAuthenticating] = @"LVCAuthenticationStateAuthenticating",
    [LVCAuthenticationStateAuthenticated] = @"LVCAuthenticationStateAuthenticated",
    [LVCAuthenticationStateTokenExpired] = @"LVCAuthenticationStateTokenExpired"
};

@interface LVCAuthenticatedClient ()
@property (atomic) AFOAuthCredential *credential;
@property (nonatomic, getter = isAuthenticated) LVCAuthenticationState authenticationState;
@property (nonatomic) NSOperationQueue *authenticationQueue;
@property (nonatomic) NSMutableArray *requestsWhileTokenExpired;
@property (nonatomic) LVCTreeBuilder *treeBuilder;
@property (nonatomic, copy) NSURL *persistentStoreURL;
@end

@implementation LVCAuthenticatedClient

#pragma mark - Object Lifecycle
- (instancetype)initWithBaseURL:(NSURL *)url
                       clientID:(NSString *)clientID
                         secret:(NSString *)secret
             persistentStoreURL:(NSURL *)persistentStoreURL
{
    self = [super initWithBaseURL:url clientID:clientID secret:secret];
    if (self) {
        _persistentStoreURL = persistentStoreURL;
        _authenticationState = LVCAuthenticationStateUnauthenticated;
        _authenticationQueue = [[NSOperationQueue alloc] init];
        _authenticationQueue.maxConcurrentOperationCount = 1;
        [self addObserver:self
               forKeyPath:@"credential"
                  options:NSKeyValueObservingOptionNew
                  context:LVCAuthenticatedClientContext];
    }
    return self;
}

- (instancetype)initWithBaseURL:(NSURL *)url
                       clientID:(NSString *)clientID
                         secret:(NSString *)secret
{
    return [self initWithBaseURL:url
                        clientID:clientID
                          secret:secret
              persistentStoreURL:nil];
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"credential" context:LVCAuthenticatedClientContext];
}

#pragma mark - AFHTTPClient
- (AFHTTPRequestOperation *)HTTPRequestOperationWithRequest:(NSURLRequest *)urlRequest
                                                    success:(void (^)(AFHTTPRequestOperation *operation,
                                                                      id responseObject))success
                                                    failure:(void (^)(AFHTTPRequestOperation *operation,
                                                                      NSError *error))failure
{
    void (^adjustedFailure)(AFHTTPRequestOperation *operation, NSError *error) = failure;

    if (![urlRequest.URL.path isEqualToString:@"/oauth/token"]) {
        __weak typeof(self) weakSelf = self;
        // If this is not a token request and the credential fails, suspend the
        // queue and save the failed requests.
        adjustedFailure = ^(AFHTTPRequestOperation *operation, NSError *error) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (operation.response.statusCode == 401) {
                [strongSelf.operationQueue setSuspended:YES];
                strongSelf.authenticationState = LVCAuthenticationStateTokenExpired;
                LVCRetryOperationShell *retry = [LVCRetryOperationShell retryOperationShellWithURLRequest:operation.request success:success failure:failure];
                [strongSelf.requestsWhileTokenExpired addObject:retry];
            }
            else {
                if (failure) {
                    failure(operation, error);
                }
            }
        };
    }

    return [super HTTPRequestOperationWithRequest:urlRequest
                                          success:success
                                          failure:adjustedFailure];
}

- (void)enqueueHTTPRequestOperation:(AFHTTPRequestOperation *)operation
{
    if ([operation.request.URL.path isEqualToString:@"/oauth/token"]) {
        self.authenticationState = LVCAuthenticationStateAuthenticating;
        [self.authenticationQueue addOperation:operation];
    }
    else {
        [self.operationQueue addOperation:operation];
    }
}

#pragma mark - LVCHTTPClient
- (void)getMeWithCompletion:(void (^)(LVCUser *user,
                                      NSError *error,
                                      AFHTTPRequestOperation *operation))completion
{
    self.treeBuilder = [[LVCTreeBuilder alloc] initWithBaseURL:self.baseURL
                                      authenticationCredential:self.credential
                                            persistentStoreURL:self.persistentStoreURL];

    __weak typeof(self) weakSelf = self;
    [self.treeBuilder buildUserTreeWithCompletion:^(LVCUser *user, NSError *error) {
        if (weakSelf.credential
            && user
            && ![user isEqual:weakSelf.user]) {
            weakSelf.user = user;
        }
        if (completion) {
            completion(user, error, nil);
        }
    }];
}

#pragma mark - Instance Methods
- (void)loginWithEmail:(NSString *)email
              password:(NSString *)password
            completion:(void (^)(BOOL success,
                                 NSError *error))completion
{
    NSParameterAssert(email);
    NSParameterAssert(password);

    __weak typeof(self) weakSelf = self;
    [self authenticateWithEmail:email password:password completion:^(AFOAuthCredential *credential,
                                                                     NSError *error) {

        __strong typeof(self) strongSelf = weakSelf;

        if (credential) {
            strongSelf.credential = credential;
            for (LVCRetryOperationShell *retryShell in strongSelf.requestsWhileTokenExpired) {
                NSURLRequest *request = [retryShell requestWithBearerToken:strongSelf.credential.accessToken];
                AFHTTPRequestOperation *retryOperation = [self HTTPRequestOperationWithRequest:request
                                                                                       success:retryShell.success
                                                                                       failure:retryShell.failure];
                [strongSelf enqueueHTTPRequestOperation:retryOperation];
            }
            strongSelf.requestsWhileTokenExpired = [NSMutableArray array];
            [strongSelf.operationQueue setSuspended:NO];
        }
        if (completion) {
            completion(!!credential, error);
        }
    }];
}

- (void)loginWithEmail:(NSString *)email password:(NSString *)password
{
    [self loginWithEmail:email password:password completion:nil];
}

- (void)logout
{
    self.credential = nil;
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == LVCAuthenticatedClientContext) {
        if ([keyPath isEqualToString:@"credential"]) {
            if (self.credential) {
                // Set Authorization Header
                [self setAuthorizationHeaderWithCredential:self.credential];

                // Get user info
                [self getMeWithCompletion:nil];
            }
            else {
                // If the credential gets explicitly set to nil, it means there
                // was one previously which needs to be deleted and headers
                // cleared. This happens on logout or if an invalid credential
                // is returned as during a successful login (which is a security
                // issue).
                [self clearAuthorizationHeader];

                // Remove user. We don’t want to trigger a KVO if it’s nil and
                // we are setting it to nil.
                if (self.user) {
                    self.user = nil;
                }
            }
            self.authenticationState = self.credential? LVCAuthenticationStateAuthenticated : LVCAuthenticationStateUnauthenticated;
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end
