//
//  LVCAuthenticatedClient.h
//  LayerVaultAPI
//
//  Created by Matt Thomas on 1/2/14.
//  Copyright (c) 2014 LayerVault. All rights reserved.
//

#import "LVCHTTPClient.h"
@class LVCUser;

typedef void (^LVCClientAuthenticationCallback)(LVCUser *user, NSError *error);

@interface LVCAuthenticatedClient : LVCHTTPClient
@property (nonatomic, copy) LVCClientAuthenticationCallback authenticationCallback;
@property (readonly, nonatomic, getter = isAuthenticated) BOOL authenticated;
@property (readonly, nonatomic) LVCUser *user;

- (instancetype)initWithBaseURL:(NSURL *)url
                       clientID:(NSString *)clientID
                         secret:(NSString *)secret
         authenticationCallback:(LVCClientAuthenticationCallback)authenticationCallback;

- (instancetype)initWithClientID:(NSString *)clientID
                          secret:(NSString *)secret
          authenticationCallback:(LVCClientAuthenticationCallback)authenticationCallback;

- (void)loginWithEmail:(NSString *)email
              password:(NSString *)password
authenticationCallback:(LVCClientAuthenticationCallback)authenticationCallback;

- (void)loginWithEmail:(NSString *)email
              password:(NSString *)password;

- (void)logout;

@end
