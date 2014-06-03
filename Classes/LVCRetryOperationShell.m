//  Created by Matt Thomas on 5/30/14.
//  Copyright (c) 2014 LayerVault. All rights reserved.

#import "LVCRetryOperationShell.h"
#import <AFNetworking/AFNetworking.h>
#import <AFOAuth2Client/AFOAuth2Client.h>
#import "NSMutableURLRequest+OAuth2.h"

@implementation LVCRetryOperationShell

+ (instancetype)retryOperationShellWithURLRequest:(NSURLRequest *)urlRequest
                                          success:(void (^)(AFHTTPRequestOperation *operation,
                                                            id responseObject))success
                                          failure:(void (^)(AFHTTPRequestOperation *operation,
                                                            NSError *error))failure
{
    return [[self alloc] initWithURLRequest:urlRequest
                                    success:success
                                    failure:failure];
}

- (instancetype)initWithURLRequest:(NSURLRequest *)urlRequest
                           success:(void (^)(AFHTTPRequestOperation *operation,
                                             id responseObject))success
                           failure:(void (^)(AFHTTPRequestOperation *operation,
                                             NSError *error))failure
{
    self = [super init];
    if (self) {
        _originalRequest = urlRequest;
        _success = [success copy];
        _failure = [failure copy];
    }
    return self;
}

- (NSURLRequest *)requestWithBearerToken:(NSString *)bearerToken
{
    NSMutableURLRequest *request = self.originalRequest.mutableCopy;
    [request lvc_setBearerToken:bearerToken];
    return request;
}


@end
