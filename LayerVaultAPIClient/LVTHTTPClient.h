//
//  LVTHTTPClient.h
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 10/13/13.
//  Copyright (c) 2013 codecaffeine. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface LVTHTTPClient : AFHTTPClient

- (void)getMyInfoWithSuccess:(void (^)(AFHTTPRequestOperation *, id))success
                     failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure;

@end
