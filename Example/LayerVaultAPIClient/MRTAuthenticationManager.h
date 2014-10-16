//
//  MRTAuthenticationManager.h
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 10/15/14.
//  Copyright (c) 2014 LayerVault. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LayerVaultAPI/LVCAuthenticatedClient.h>

@class AFOAuthCredential;
@class LVCUserValue;
@class PMKPromise;

@interface MRTAuthenticationManager : NSObject
@property (nonatomic, readonly) AFOAuthCredential *credential;
@property (nonatomic, readonly) LVCUserValue *userValue;
@property (nonatomic, readonly) LVCAuthenticationState authenticationState;

- (instancetype)initWithBaseURL:(NSURL *)baseURL
                       clientID:(NSString *)clientID
                         secret:(NSString *)secret;

/// Promise returns a userValue or an error
- (PMKPromise *)authenticateWithEmail:(NSString *)email
                             password:(NSString *)password;

/// Promise returns a userValue or an error
- (PMKPromise *)authenticateWithCredential:(AFOAuthCredential *)credential;

- (void)expireCredential;

@end
