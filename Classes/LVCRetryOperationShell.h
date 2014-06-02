//  Created by Matt Thomas on 5/30/14.
//  Copyright (c) 2014 LayerVault. All rights reserved.

#import <Foundation/Foundation.h>
@class AFHTTPRequestOperation;
@class AFOAuthCredential;

@interface LVCRetryOperationShell : NSObject

@property (readonly, nonatomic) NSURLRequest *originalRequest;
@property (readonly, nonatomic, copy) void (^success)(AFHTTPRequestOperation *operation, id responseObject);
@property (readonly, nonatomic, copy) void (^failure)(AFHTTPRequestOperation *operation, NSError *error);

+ (instancetype)retryOperationShellWithURLRequest:urlRequest
                                          success:(void (^)(AFHTTPRequestOperation *operation,
                                                            id responseObject))success
                                          failure:(void (^)(AFHTTPRequestOperation *operation,
                                                            NSError *error))failure;

- (instancetype)initWithURLRequest:(NSURLRequest *)urlRequest
                           success:(void (^)(AFHTTPRequestOperation *operation,
                                             id responseObject))success
                           failure:(void (^)(AFHTTPRequestOperation *operation,
                                             NSError *error))failure;

- (NSURLRequest *)requestWithBearerToken:(NSString *)bearerToken;

@end
