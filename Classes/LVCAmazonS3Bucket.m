//
//  LVCAmazonS3Bucket.m
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 2/13/14.
//  Copyright (c) 2014 LayerVault. All rights reserved.
//

#import "LVCAmazonS3Bucket.h"

static NSDictionary *timeZoneIDToHost(void)
{
    return @{@"Australia/Sydney": @"omnivore-scratch-aus"};
}

@implementation LVCAmazonS3Bucket

+ (NSURL *)baseURLForLocalTimezone
{
    return [self baseURLForTimezone:[NSTimeZone localTimeZone]];
}


+ (NSURL *)baseURLForTimezone:(NSTimeZone *)timeZone
{
    NSString *bucket = nil;
    if (timeZone.name.length > 0) {
        bucket = timeZoneIDToHost()[timeZone.name];
    }
    bucket = bucket ?: @"omnivore-scratch";
    return [NSURL URLWithString:[NSString stringWithFormat:@"https://%@.s3.amazonaws.com", bucket]];
}

@end
