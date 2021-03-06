//
//  LVCAuthenticatedClient.h
//  LayerVaultAPI
//
//  Created by Matt Thomas on 1/2/14.
//  Copyright (c) 2014 LayerVault. All rights reserved.
//

#import "LVCHTTPClient.h"
@class LVCUser;
@class AFOAuthCredential;
@class AFHTTPRequestOperation;

/**
 *  Various authentication states the authenticated client can be in
 */
typedef NS_ENUM(NSUInteger, LVCAuthenticationState) {
    /**
     *  Unauthenticated. User & Credential should be nil.
     */
    LVCAuthenticationStateUnauthenticated = 0,
    /**
     *  Authenticating. User & Credential should be nil.
     */
    LVCAuthenticationStateAuthenticating,
    /**
     *  Authenticated. User & Credential are set.
     */
    LVCAuthenticationStateAuthenticated,
    /**
     *  Token Expired. User & Credential are set, but the access token is 
     *  expired and request will return HTTP 401.
     */
    LVCAuthenticationStateTokenExpired
};

OBJC_EXPORT NSString * const LVCAuthenticationStateDescription[];

@interface LVCAuthenticatedClient : LVCHTTPClient

/**
 *  The authenticated user
 */
@property (readonly, nonatomic) LVCUser *user;

/**
 *  Returns if the client is unauthenticated, authenticating, authenticated, or 
 *  if the token has expired
 */
@property (readonly, nonatomic) LVCAuthenticationState authenticationState;

/**
 *  A credential to use for authentication
 */
@property (atomic, readonly) AFOAuthCredential *credential;


/**
 *  Created an authenticated client with all the options
 *
 *  @param url          URL endpoint we are making calls against (required)
 *  @param clientID     OAuth Client ID (required)
 *  @param secret       OAuth Secret (required)
 *
 *  @return AuthenticatedClient Instance
 *
 *  @note Designated Initializer
 */
- (instancetype)initWithBaseURL:(NSURL *)url
                       clientID:(NSString *)clientID
                         secret:(NSString *)secret;

/**
 *  Creates an authenticated client with default options:
 *    BaseURL                   LVCHTTPClient.defaultBaseURL
 *    authenticationCallback    nil
 *
 *  @param clientID   OAuth 2 Secret Client ID (required)
 *  @param secret     OAuth 2 Secret (required)
 *
 *  @return AuthenticatedClient Instance
 */
- (instancetype)initWithClientID:(NSString *)clientID
                          secret:(NSString *)secret;

/**
 *  Authenticates with email/password and a completion
 *
 *  @param email      email for authentication (required)
 *  @param password   password for authentication (required)
 *  @param completion callback on completion (optional)
 */
- (void)loginWithEmail:(NSString *)email
              password:(NSString *)password
            completion:(void (^)(BOOL success,
                                 NSError *error))completion;

/**
 *  Authenticates with email/password
 *
 *  @param email                  email for authentication (required)
 *  @param password               password for authentication (required)
 */
- (void)loginWithEmail:(NSString *)email
              password:(NSString *)password;


/**
 *  Logs the user out. Client will need to re-authenticate to call any further
 *  authenticated methods.
 */
- (void)logout;


@end
