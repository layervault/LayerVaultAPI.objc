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
@property (nonatomic, readonly) BOOL persistentStoreExists;
@property (nonatomic, readonly) NSURL *persistentStoreURL;

- (instancetype)initWithBaseURL:(NSURL *)baseURL
       authenticationCredential:(AFOAuthCredential *)authenticationCredential
             persistentStoreURL:(NSURL *)persistentStoreURL;

- (void)buildUserTreeWithCompletion:(void (^)(LVCUser *user, NSError *error))completion;

@end
