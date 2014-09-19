//
//  LVCOrganization.m
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 10/25/13.
//  Copyright (c) 2013 LayerVault. All rights reserved.
//

#import "LVCOrganization.h"
#import "LVCProject.h"
#import "NSValueTransformer+LVCPredefinedTransformerAdditions.h"

@implementation LVCOrganization

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"name": @"name",
             @"userRole": @"user_role",
             @"permalink": @"permalink",
             @"dateDeleted": @"deleted_at",
             @"dateUpdated": @"updated_at",
             @"url": @"full_url",
             @"syncType": @"sync_type",
             @"projects": @"projects"};
}


+ (NSValueTransformer *)dateDeletedJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:LVCRFC3339DateTransformerName];
}


+ (NSValueTransformer *)dateUpdatedJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:LVCRFC3339DateTransformerName];
}


+ (NSValueTransformer *)urlJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}


+ (NSValueTransformer *)projectsJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:LVCProject.class];
}

@end
