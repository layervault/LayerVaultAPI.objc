//
//  LVTHTTPClient.m
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 10/13/13.
//  Copyright (c) 2013 codecaffeine. All rights reserved.
//

#import "LVTHTTPClient.h"

@implementation LVTHTTPClient

- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (self) {
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [self setDefaultHeader:@"Accept" value:@"application/json"];
        [self setDefaultHeader:@"Authorization" value:@"Bearer e4d1af3fff20e0cd257a2a09b0ca9f001f058f4b66fe6d269f31bbdef615b9d1"];
    }
    return self;
}


- (instancetype)init
{
    return [self initWithBaseURL:[NSURL URLWithString:@"https://layervault.com/api/v1/"]];
}


- (void)getMyInfoWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    [self getPath:@"me"
       parameters:nil
          success:success
          failure:failure];
}

@end
