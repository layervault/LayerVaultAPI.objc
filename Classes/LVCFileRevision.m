//
//  LVCFileRevision.m
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 11/18/13.
//  Copyright (c) 2013 LayerVault. All rights reserved.
//

#import "LVCFileRevision.h"
#import "NSDateFormatter+RFC3339.h"

@implementation LVCFileRevision

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"revision": @"revision_number",
             @"md5": @"md5",
             @"dateCreated": @"created_at",
             @"dateUpdated": @"updated_at",
             @"webURL": @"full_url",
             @"downloadURL": @"download_url",
             @"shortenedURL": @"shortened_url"};
}


+ (NSValueTransformer *)dateCreatedJSONTransformer
{
    return [MTLValueTransformer
            reversibleTransformerWithForwardBlock:^NSDate *(NSString *string) {
                return [[NSDateFormatter lvc_rfc3339DateFormatter] dateFromString:string];
            }
            reverseBlock:^NSString *(NSDate *date) {
                return [[NSDateFormatter lvc_rfc3339DateFormatter] stringFromDate:date];
            }];
}


+ (NSValueTransformer *)dateUpdatedJSONTransformer
{
    return [MTLValueTransformer
            reversibleTransformerWithForwardBlock:^NSDate *(NSString *string) {
                return [[NSDateFormatter lvc_rfc3339DateFormatter] dateFromString:string];
            }
            reverseBlock:^NSString *(NSDate *date) {
                return [[NSDateFormatter lvc_rfc3339DateFormatter] stringFromDate:date];
            }];
}


+ (NSValueTransformer *)shortURLJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}


+ (NSValueTransformer *)downloadURLJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}


+ (NSValueTransformer *)shortenedURLJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}


@end
