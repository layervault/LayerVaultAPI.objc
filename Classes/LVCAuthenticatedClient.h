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

typedef NS_ENUM(NSInteger, LVCAuthenticationState) {
    LVCAuthenticationStateUnauthenticated = -1,
    LVCAuthenticationStateAuthenticating = 0,
    LVCAuthenticationStateAuthenticated = 1
};

typedef void (^LVCClientAuthenticationCallback)(LVCUser *user, NSError *error);

@interface LVCAuthenticatedClient : LVCHTTPClient

/**
 *  The authenticated user
 */
@property (readonly, nonatomic) LVCUser *user;

/**
 *  @note YES if we are saving the credentials to the keychain, otherwise NO
 */
@property (nonatomic, readonly) BOOL saveCredentialToKeychain;

/**
 *  Returns if the client is unauthenticated, authenticating, or authenticated
 */
@property (readonly, nonatomic, getter = isAuthenticated) LVCAuthenticationState authenticationState;

/**
 *  A handler called when the client is authenticated
 */
@property (nonatomic, copy) LVCClientAuthenticationCallback authenticationCallback;

/**
 *  A credential to use for authentication
 */
@property (nonatomic) AFOAuthCredential *credential;


/**
 *  Created an authenticated client with all the options
 *
 *  @param url                    URL endpoint we are making calls against (required)
 *  @param clientID               OAuth Client ID (required)
 *  @param secret                 OAuth Secret (required)
 *  @param saveToKeychain         YES to save Credential to keychain, otherwise NO (required)
 *
 *  @return AuthenticatedClient Instance
 *
 *  @note Designated Initializer
 */
- (instancetype)initWithBaseURL:(NSURL *)url
                       clientID:(NSString *)clientID
                         secret:(NSString *)secret
                 saveToKeychain:(BOOL)saveToKeychain;


/**
 *  Creates an authenticated client with default options:
 *    BaseURL                   LVCHTTPClient.defaultBaseURL
 *    saveToKeychain            YES
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
 *  Authenticates with a credential
 *
 *  @param credential             Credential to authenticate with
 */
- (void)loginWithCredential:(AFOAuthCredential *)credential;


/**
 *  Authenticates with username/password
 *
 *  @param email                  email for authentication (required)
 *  @param password               password for authentication (required)
 */
- (void)loginWithEmail:(NSString *)email
              password:(NSString *)password;


/**
 *  Logs the user out. Client will need to re-authenticate to call any further
 *  authenticated methods.
 *
 *  @note This does not remove the authentication from the keychain. Please call
 *        `clearCredentialFromKeychain` to do so.
 */
- (void)logout;

/**
 *  Removes the authentication credential from keychain
 */
- (void)clearCredentialFromKeychain;

@end
