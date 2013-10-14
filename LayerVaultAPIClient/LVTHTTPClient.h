//
//  LVTHTTPClient.h
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 10/13/13.
//  Copyright (c) 2013 codecaffeine. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@class LVTUser;

@interface LVTHTTPClient : AFHTTPClient

- (instancetype)initWithBaseURL:(NSURL *)url token:(NSString *)token;

- (instancetype)initWithToken:(NSString *)token;

- (void)getMyInfo:(void (^)(LVTUser *user, NSError *error, AFHTTPRequestOperation *operation))myInfoBlock;

@end
