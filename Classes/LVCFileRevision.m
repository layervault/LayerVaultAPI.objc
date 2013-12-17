//
//  LVCFileRevision.m
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 11/18/13.
//  Copyright (c) 2013 LayerVault. All rights reserved.
//

#import "LVCFileRevision.h"
#import "NSValueTransformer+LVCPredefinedTransformerAdditions.h"

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
    return [NSValueTransformer valueTransformerForName:LVCRFC3339DateTransformerName];
}


+ (NSValueTransformer *)dateUpdatedJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:LVCRFC3339DateTransformerName];
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
