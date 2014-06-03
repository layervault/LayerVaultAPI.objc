//  Created by Matt Thomas on 5/30/14.
//  Copyright (c) 2014 LayerVault. All rights reserved.

#import <Foundation/Foundation.h>
@class AFHTTPRequestOperation;
@class AFOAuthCredential;

/**
 *  Used to save URL Request information after a request fails and need to be
 *  re-run.
 */
@interface LVCRetryOperationShell : NSObject

/**
 *  The original URL request that failed
 */
@property (readonly, nonatomic) NSURLRequest *originalRequest;

/**
 *  The original success block to run when the request succeeds.
 */
@property (readonly, nonatomic, copy) void (^success)(AFHTTPRequestOperation *operation, id responseObject);

/**
 *  The original failure block to run when the request fails.
 */
@property (readonly, nonatomic, copy) void (^failure)(AFHTTPRequestOperation *operation, NSError *error);

/**
 *  Save a NSURLRequest for running later
 *
 *  @param urlRequest request to run later
 *  @param success    block to call if request is successful
 *  @param failure    block to call if request fails
 *
 *  @return NSURLRequest for running later
 */
+ (instancetype)retryOperationShellWithURLRequest:(NSURLRequest *)urlRequest
                                          success:(void (^)(AFHTTPRequestOperation *operation,
                                                            id responseObject))success
                                          failure:(void (^)(AFHTTPRequestOperation *operation,
                                                            NSError *error))failure;

/**
 *  Save a NSURLRequest for running later
 *
 *  @param urlRequest request to run later
 *  @param success    block to call if request is successful
 *  @param failure    block to call if request fails
 *
 *  @return NSURLRequest for running later
 */
- (instancetype)initWithURLRequest:(NSURLRequest *)urlRequest
                           success:(void (^)(AFHTTPRequestOperation *operation,
                                             id responseObject))success
                           failure:(void (^)(AFHTTPRequestOperation *operation,
                                             NSError *error))failure;

/**
 *  @param bearerToken New, unexpired OAuth bearer token
 *
 *  @return New URL request authenicated with bearerToken param
 */
- (NSURLRequest *)requestWithBearerToken:(NSString *)bearerToken;

@end
