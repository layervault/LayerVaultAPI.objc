//
//  LVCTreeBuilder.h
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 9/17/14.
//  Copyright (c) 2014 LayerVault. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AFOAuthCredential;
@class LVCUser;

@interface LVCTreeBuilder : NSObject

- (instancetype)initWithAuthenticationCredential:(AFOAuthCredential *)authenticationCredential;

- (void)buildUserTreeWithPrevious:(LVCUser *)previousUser
                       completion:(void (^)(LVCUser *user, NSError *error))completion;

@end
