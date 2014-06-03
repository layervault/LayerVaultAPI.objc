//
//  LVCAmazonS3Bucket.h
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 2/13/14.
//  Copyright (c) 2014 LayerVault. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LVCAmazonS3Bucket : NSObject

/**
 *  @return NSURL for local S3 bucket based on computer timezone
 */
+ (NSURL *)baseURLForLocalTimezone;

/**
 *  @param timeZone A timezone used to lookup S3 bucket
 *
 *  @return NSURL for local S3 bucket based on timeZone parameter
 */
+ (NSURL *)baseURLForTimezone:(NSTimeZone *)timeZone;

/**
 *  @return S3 bucket name based on computer timezone
 */
+ (NSString *)bucketForLocalTimezone;

/**
 *  @param timeZone A timezone used to lookup S3 bucket
 *
 *  @return S3 bucket name based on timeZone parameter
 */
+ (NSString *)bucketForTimezone:(NSTimeZone *)timeZone;

@end
