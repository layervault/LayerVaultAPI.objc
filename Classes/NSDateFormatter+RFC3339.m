//
//  NSDateFormatter+RFC3339.m
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 12/17/13.
//  Copyright (c) 2013 LayerVault. All rights reserved.
//

#import "NSDateFormatter+RFC3339.h"

static NSCache *LVCDateFormatterCache = nil;

@implementation NSDateFormatter (RFC3339)

+ (NSDateFormatter *)lvc_rfc3339DateFormatter
{
    if (!LVCDateFormatterCache) {
        NSLog(@"No date formatter cache. Creating new.");
        LVCDateFormatterCache = [[NSCache alloc] init];
    }

    NSDateFormatter *dateFormatter = nil;

    NSString *queueName = [[NSOperationQueue currentQueue] name];
    if (queueName) {
        dateFormatter = [LVCDateFormatterCache objectForKey:queueName];
    }

    if (!dateFormatter) {
        NSLog(@"No date formatter for queue '%@'. Creating.", queueName);
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
        dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";

        if (queueName) {
            NSLog(@"Saving date formatter cache");
            [LVCDateFormatterCache setObject:dateFormatter forKey:queueName];
        }
    }

    return dateFormatter;
}

@end
