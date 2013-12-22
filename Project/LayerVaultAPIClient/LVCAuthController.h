//
//  LVCAuthController.h
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 12/21/13.
//  Copyright (c) 2013 LayerVault. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LVCHTTPClient;
@class LVCUser;

@interface LVCAuthController : NSObject

@property (readonly, nonatomic) LVCUser *user;
@property (readonly, nonatomic) LVCHTTPClient *client;

- (void)loginWithEmail:(NSString *)email
              password:(NSString *)password
            completion:(void (^)(LVCUser *user,
                                 LVCHTTPClient *client,
                                 NSError *error))completion;

- (void)logout;

@end
