//
//  LVCFile.m
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 11/18/13.
//  Copyright (c) 2013 LayerVault. All rights reserved.
//

#import "LVCFile.h"
#import "LVCFileRevision.h"
#import "NSValueTransformer+LVCPredefinedTransformerAdditions.h"

@implementation LVCFile

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSMutableDictionary *JSONKeyPathsByPropertyKey = [super JSONKeyPathsByPropertyKey].mutableCopy;
    [JSONKeyPathsByPropertyKey addEntriesFromDictionary:@{@"revisionNumber": @"revision_number",
                                                          @"revisions": @"revisions",
                                                          @"dateModified": @"modified_at",
                                                          @"downloadURL": @"download_url"}];
    return JSONKeyPathsByPropertyKey.copy;
}


+ (NSValueTransformer *)revisionsJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:LVCFileRevision.class];
}


+ (NSValueTransformer *)dateModifiedJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:LVCRFC3339DateTransformerName];
}


+ (NSValueTransformer *)downloadURLJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}


@end
