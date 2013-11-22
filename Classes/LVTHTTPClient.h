//
//  LVTHTTPClient.h
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 10/13/13.
//  Copyright (c) 2013 codecaffeine. All rights reserved.
//

#import <AFOAuth2Client/AFOAuth2Client.h>

@class LVTUser;
@class LVTOrganization;
@class LVTProject;
@class RACSignal;

@interface LVTHTTPClient : AFOAuth2Client

@property (readonly, nonatomic, copy) LVTUser *user;

- (instancetype)initWithClientID:(NSString *)clientID secret:(NSString *)secret;

- (void)getMeWithBlock:(void (^)(LVTUser *user, NSError *error, AFHTTPRequestOperation *operation))block;

- (void)getOrganizationWithParmalink:(NSString *)permalink
                               block:(void (^)(LVTOrganization *organization,
                                               NSError *error,
                                               AFHTTPRequestOperation *operation))block;

- (void)getProjectWithName:(NSString *)projectName
            inOrganization:(LVTOrganization *)organization
                     block:(void (^)(LVTProject *project,
                                     NSError *error,
                                     AFHTTPRequestOperation *operation))block;

- (void)getProjectWithName:(NSString *)projectName
     organizationPermalink:(NSString *)organizationPermalink
                     block:(void (^)(LVTProject *project,
                                     NSError *error,
                                     AFHTTPRequestOperation *operation))block;


- (void)authenticateWithEmail:(NSString *)email
                     password:(NSString *)password
                   completion:(void (^)(AFOAuthCredential *credential, NSError *error))completion;

- (RACSignal *)requestAuthorizationWithEmail:(NSString *)email password:(NSString *)password;

- (RACSignal *)fetchUserInfo;

@end
