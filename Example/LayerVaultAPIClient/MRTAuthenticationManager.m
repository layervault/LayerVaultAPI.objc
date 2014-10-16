//
//  MRTAuthenticationManager.m
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 10/15/14.
//  Copyright (c) 2014 LayerVault. All rights reserved.
//

#import "MRTAuthenticationManager.h"
#import <PromiseKit/PromiseKit.h>
#import <LayerVaultAPI/LayerVaultAPI.h>
#import "NSError+LVCNetworkErrors.h"

@interface MRTAuthenticationManager ()
@property (nonatomic, readonly) NSURL *baseURL;
@property (nonatomic) AFOAuthCredential *credential;
@property (nonatomic) LVCUserValue *userValue;
@property (nonatomic) LVCAuthenticationState authenticationState;
@property (nonatomic, readonly) LVCHTTPClient *authClient;
@end

@implementation MRTAuthenticationManager

- (instancetype)initWithBaseURL:(NSURL *)baseURL
                       clientID:(NSString *)clientID
                         secret:(NSString *)secret {
    self = [super init];
    if (self) {
        _baseURL = [baseURL copy];
        _authClient = [[LVCHTTPClient alloc] initWithBaseURL:_baseURL
                                                    clientID:clientID
                                                      secret:secret];
        _authenticationState = LVCAuthenticationStateUnauthenticated;
    }
    return self;
}

/// Promise returns a userValue or an error
- (PMKPromise *)authenticateWithEmail:(NSString *)email
                             password:(NSString *)password {

    if (self.authenticationState != LVCAuthenticationStateAuthenticating) {
        self.authenticationState = LVCAuthenticationStateAuthenticating;
    }

    __weak typeof(self) weakSelf = self;
    return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
        [weakSelf.authClient authenticateWithEmail:email password:password completion:^(AFOAuthCredential *credential, NSError *error) {
            if (credential) {
                self.credential = credential;
                fulfill(self.credential);
            } else {
                reject(error);
            }
        }];
    }].then(^(AFOAuthCredential *credential) {
        return [weakSelf authenticateWithCredential:credential];
    }).catch(^(NSError *error) {
        self.authenticationState = LVCAuthenticationStateUnauthenticated;
        if ([error lvc_failedWithHTTPStatusCode:401]) {
            self.credential = nil;
        }
        return error;
    });
}

/// Promise returns a userValue or an error
- (PMKPromise *)authenticateWithCredential:(AFOAuthCredential *)credential {

    if (self.authenticationState != LVCAuthenticationStateAuthenticating) {
        self.authenticationState = LVCAuthenticationStateAuthenticating;
    }

    NSURL *url = [NSURL URLWithString:@"/api/v2/" relativeToURL:self.baseURL];
    LVCV2AuthenticatedClient *v2Client = [[LVCV2AuthenticatedClient alloc] initWithBaseURL:url oAuthCredential:credential];

    // Will this be set to nil when the scope completes?
    return v2Client.me.then(^(LVCUserValue *userValue) {
        self.userValue = userValue;
        self.authenticationState = LVCAuthenticationStateAuthenticated;
        return self.userValue;
    }).catch(^(NSError *error) {
        self.authenticationState = LVCAuthenticationStateUnauthenticated;
        if ([error lvc_failedWithHTTPStatusCode:401]) {
            self.credential = nil;
        }
        return error;
    });
}

- (void)expireCredential {
    self.credential = nil;
    self.userValue = nil;
    self.authenticationState = LVCAuthenticationStateTokenExpired;
}

@end

