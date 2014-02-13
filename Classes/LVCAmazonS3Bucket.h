//
//  LVCAmazonS3Bucket.h
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 2/13/14.
//  Copyright (c) 2014 LayerVault. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LVCAmazonS3Bucket : NSObject

+ (NSURL *)baseURLForLocalTimezone;
+ (NSURL *)baseURLForTimezone:(NSTimeZone *)timeZone;
+ (NSString *)bucketForLocalTimezone;
+ (NSString *)bucketForTimezone:(NSTimeZone *)timeZone;

@end
