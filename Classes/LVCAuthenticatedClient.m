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
                                                    success:(void (^)(AFHTTPRequestOperation *operation,
                                                                      id responseObject))success
                                                    failure:(void (^)(AFHTTPRequestOperation *operation,
                                                                      NSError *error))failure
{
    void (^adjustedSuccess)(AFHTTPRequestOperation *operation, id responseObject) = success;
    void (^adjustedFailure)(AFHTTPRequestOperation *operation, NSError *error) = failure;

    if (![urlRequest.URL.path isEqualToString:@"/oauth/token"]) {
        // If this is not a token request, inject refreshing the oauth
        // credential if an HTTP 401 response is returned and the credential is
        // expired.
        adjustedFailure = ^(AFHTTPRequestOperation *operation, NSError *error) {
            if (operation.response.statusCode == 401 || self.credential.isExpired) {
                [self.operationQueue setSuspended:YES];

                [self authenticateUsingOAuthWithPath:@"/oauth/token"
                                        refreshToken:self.credential.refreshToken
                                             success:^(AFOAuthCredential *credential) {
                    self.credential = credential;

                    NSMutableURLRequest *newRequest = urlRequest.mutableCopy;
                    [newRequest setValue:[NSString stringWithFormat:@"Bearer %@", self.credential.accessToken]
                      forHTTPHeaderField:@"Authorization"];
                    AFHTTPRequestOperation *attempt2 = [super HTTPRequestOperationWithRequest:newRequest
                                                                                      success:success
                                                                                      failure:failure];
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
    else if (self.authenticationCallback) {
        // If this *is* an /oauth/token request and we have an authentication
        // callback, inject the authenticationCallback in the success and
        // failure blocks
        adjustedSuccess = ^(AFHTTPRequestOperation *operation, id responseObject) {
            if (self.authenticationCallback) {
                self.authenticationCallback(YES, operation, nil);
            }
            if (success) {
                success(operation, responseObject);
            }
        };
        adjustedFailure = ^(AFHTTPRequestOperation *operation, NSError *error) {
            if (self.authenticationCallback) {
                self.authenticationCallback(NO, operation, error);
            }
            if (failure) {
                failure(operation, error);
            }
        };
    }

    return [super HTTPRequestOperationWithRequest:urlRequest
                                          success:adjustedSuccess
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
    __weak typeof(self) weakself = self;
    [super getMeWithCompletion:^(LVCUser *user,
                                 NSError *error,
                                 AFHTTPRequestOperation *operation) {
        __strong typeof(weakself) strongself = weakself;
        // 1. We only want to set the user if the credential is valid,
        //    otherwise we will be in an unknown state.
        // 2. If the user was previously set and we are given a nil user, this
        //    means that the /me failed for some reason. This does not mean our
        //    current user is invalid.
        // 3. We do not want a KVO to be called if the actual object did not
        //    change.
        if (strongself.credential
            && user
            && ![user isEqual:strongself.user]) {
            strongself.user = user;
        }
        if (completion) {
            completion(user, error, operation);
        }
    }];
}


#pragma mark - Instance Methods
- (void)loginWithCredential:(AFOAuthCredential *)credential
{
    NSParameterAssert(credential);
    self.credential = credential;
}

- (void)loginWithEmail:(NSString *)email
              password:(NSString *)password
{
    NSParameterAssert(email);
    NSParameterAssert(password);

    [self authenticateWithEmail:email
                       password:password
                     completion:^(AFOAuthCredential *credential,
                                  NSError *error) {
                         if (credential) {
                             self.credential = credential;
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
