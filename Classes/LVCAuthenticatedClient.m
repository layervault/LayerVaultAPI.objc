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
@property (nonatomic, getter = isAuthenticated) LVCAuthenticationState authenticationState;
@property (nonatomic) NSOperationQueue *authenticationQueue;
@property (nonatomic) LVCUser *user;
@end

@implementation LVCAuthenticatedClient

#pragma mark - Object Lifecycle
- (instancetype)initWithBaseURL:(NSURL *)url clientID:(NSString *)clientID secret:(NSString *)secret
{
    self = [super initWithBaseURL:url clientID:clientID secret:secret];
    if (self) {
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


- (instancetype)initWithClientID:(NSString *)clientID
                          secret:(NSString *)secret
{
    return [self initWithBaseURL:LVCHTTPClient.defaultBaseURL
                        clientID:clientID
                          secret:secret];
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
                self.authenticationState = LVCAuthenticationStateAuthenticating;
                [self.operationQueue setSuspended:YES];
                NSLog(@"Unauthorized Request. Attempting Refresh credential");
                [self authenticateUsingOAuthWithPath:@"/oauth/token"
                                        refreshToken:self.credential.refreshToken
                                             success:^(AFOAuthCredential *credential) {
                                                 self.credential = credential;

                                                 // Setting the credential will automatically call /me
                                                 if (![urlRequest.URL.path isEqualToString:@"/api/v1/me"]) {
                                                     NSMutableURLRequest *newRequest = urlRequest.mutableCopy;
                                                     [newRequest setValue:[NSString stringWithFormat:@"Bearer %@", self.credential.accessToken]
                                                       forHTTPHeaderField:@"Authorization"];
                                                     AFHTTPRequestOperation *attempt2 = [super HTTPRequestOperationWithRequest:newRequest success:success failure:failure];
                                                     [self enqueueHTTPRequestOperation:attempt2];

                                                 }
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


#pragma mark - Instance Methods
- (void)loginWithCredential:(AFOAuthCredential *)credential
{
    NSParameterAssert(credential);
    self.authenticationState = LVCAuthenticationStateAuthenticating;
    self.credential = credential;
}

- (void)loginWithEmail:(NSString *)email
              password:(NSString *)password
{
    NSParameterAssert(email);
    NSParameterAssert(password);

    self.authenticationState = LVCAuthenticationStateAuthenticating;
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

                // Set Authorization Header
                [self setAuthorizationHeaderWithCredential:self.credential];
                self.authenticationState = LVCAuthenticationStateAuthenticated;

                // Get user info
                [self getMeWithCompletion:^(LVCUser *user,
                                            NSError *error,
                                            AFHTTPRequestOperation *operation) {
                    // We don't want to trigger a KVO change if it doesn't
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
                self.authenticationState = LVCAuthenticationStateUnauthenticated;

                // Remove user
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
