//
//  LVCAuthenticatedClient.m
//  LayerVaultAPI
//
//  Created by Matt Thomas on 1/2/14.
//  Copyright (c) 2014 LayerVault. All rights reserved.
//

#import "LVCAuthenticatedClient.h"
#import "LVCUser.h"
#import <AFOAuth2Client/AFOAuth2Client.h>
#import <AFNetworking/AFNetworking.h>

static void *LVCAuthenticatedClientContext = &LVCAuthenticatedClientContext;

@interface LVCAuthenticatedClient ()
@property (nonatomic) NSOperationQueue *authenticationQueue;
@property (nonatomic) AFOAuthCredential *credential;
@property (nonatomic) LVCUser *user;
@end

@implementation LVCAuthenticatedClient

#pragma mark - Object Lifecycle
- (instancetype)initWithBaseURL:(NSURL *)url
                       clientID:(NSString *)clientID
                         secret:(NSString *)secret
         authenticationCallback:(LVCClientAuthenticationCallback)authenticationCallback
{
    self = [super initWithBaseURL:url clientID:clientID secret:secret];
    if (self) {
        _authenticationCallback = [authenticationCallback copy];
        _authenticationQueue = [[NSOperationQueue alloc] init];
        _authenticationQueue.maxConcurrentOperationCount = 1;
        _credential = [AFOAuthCredential retrieveCredentialWithIdentifier:self.serviceProviderIdentifier];
        [self addObserver:self
               forKeyPath:@"credential"
                  options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew
                  context:LVCAuthenticatedClientContext];
    }
    return self;
}


- (instancetype)initWithClientID:(NSString *)clientID
                          secret:(NSString *)secret
          authenticationCallback:(LVCClientAuthenticationCallback)authenticationCallback
{
    return [self initWithBaseURL:LVCHTTPClient.defaultBaseURL
                        clientID:clientID
                          secret:secret
          authenticationCallback:authenticationCallback];
}


- (instancetype)initWithBaseURL:(NSURL *)url clientID:(NSString *)clientID secret:(NSString *)secret
{
    return [self initWithBaseURL:url clientID:clientID secret:secret authenticationCallback:nil];
}


- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"credential" context:LVCAuthenticatedClientContext];
}


#pragma mark - AFHTTPClient
- (AFHTTPRequestOperation *)HTTPRequestOperationWithRequest:(NSURLRequest *)urlRequest
                                                    success:(void (^)(AFHTTPRequestOperation *, id))success
                                                    failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    void (^adjustedFailure)(AFHTTPRequestOperation *operation, NSError *error) = failure;

    if (![urlRequest.URL.path isEqualToString:@"/oauth/token"]) {
        adjustedFailure = ^(AFHTTPRequestOperation *operation, NSError *error) {
            if (operation.response.statusCode == 401) {
                [self.operationQueue setSuspended:YES];
                NSLog(@"Unauthorized Request. Attempting Refresh credential");
                [self clearAuthorizationHeader];
                [self authenticateUsingOAuthWithPath:@"/oauth/token"
                                        refreshToken:self.credential.refreshToken
                                             success:^(AFOAuthCredential *credential) {
                                                 self.credential = credential;
                                                 AFHTTPRequestOperation *attempt2 = [super HTTPRequestOperationWithRequest:urlRequest success:success failure:failure];
                                                 [self enqueueHTTPRequestOperation:attempt2];
                                             }
                                             failure:^(NSError *error) {
                                                 [self logout];
                                                 if (failure) {
                                                     failure(nil, error);
                                                 }
                                             }];
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
        [self.authenticationQueue addOperation:operation];
    }
    else {
        [self.operationQueue addOperation:operation];
    }
}


#pragma mark - Declared Properties
- (BOOL)isAuthenticated
{
    return !!self.user;
}


#pragma mark - Instance Methods
- (void)loginWithEmail:(NSString *)email
              password:(NSString *)password
authenticationCallback:(LVCClientAuthenticationCallback)authenticationCallback
{
    if (authenticationCallback) {
        self.authenticationCallback = authenticationCallback;
    }

    if (self.authenticated) {
        if (self.authenticationCallback) {
            self.authenticationCallback(self.user, nil);
        }
    }
    else {
        [self authenticateWithEmail:email
                           password:password
                         completion:^(AFOAuthCredential *credential,
                                      NSError *error) {
                             if (credential) {
                                 self.credential = credential;
                             }
                             else {
                                 if (self.authenticationCallback) {
                                     self.authenticationCallback(nil, error);
                                 }
                             }
                         }];
    }
}


- (void)loginWithEmail:(NSString *)email password:(NSString *)password
{
    [self loginWithEmail:email password:password authenticationCallback:nil];
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
                // Unsuspend queue if needed
                if (self.operationQueue.isSuspended) {
                    [self.operationQueue setSuspended:NO];
                }

                // Save Credential
                [AFOAuthCredential storeCredential:self.credential
                                    withIdentifier:self.serviceProviderIdentifier];

                // Set Authorization Header
                [self setAuthorizationHeaderWithCredential:self.credential];

                // Get user info
                [self getMeWithCompletion:^(LVCUser *user,
                                            NSError *error,
                                            AFHTTPRequestOperation *operation) {
                    // We don't want to emit a KVO change if it doesn't
                    // *actually* change. This will occur when 
                    if (user != self.user) {
                        self.user = user;
                    }
                    if (self.authenticationCallback) {
                        self.authenticationCallback(self.user, error);
                    }
                }];
            }
            else {
                // If the credential gets explicitly set to nil, it means there
                // was one previously which needs to be deleted and headers
                // cleared. This happens on logout or if an invalid credential
                // is returned as during a successful login (which is a security
                // issue).
                [self clearAuthorizationHeader];
                [AFOAuthCredential deleteCredentialWithIdentifier:self.serviceProviderIdentifier];
                if (self.user) {
                    self.user = nil;
                }
                if (self.authenticationCallback) {
                    self.authenticationCallback(self.user, nil);
                }
            }
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end
