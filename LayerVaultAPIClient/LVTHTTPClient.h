//
//  LVTHTTPClient.h
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 10/13/13.
//  Copyright (c) 2013 codecaffeine. All rights reserved.
//

#import <AFOAuth2Client/AFOAuth2Client.h>

@class LVTUser;
@class RACSignal;

@interface LVTHTTPClient : AFOAuth2Client

@property (readonly, nonatomic, copy) LVTUser *user;

- (instancetype)initWithClientID:(NSString *)clientID secret:(NSString *)secret;

- (void)authenticateWithBlock:(void (^)(LVTUser *user, NSError *error, AFHTTPRequestOperation *operation))myInfoBlock;

- (RACSignal *)fetchUserInfo;

@end
