//
//  LVCOrganization.m
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 10/25/13.
//  Copyright (c) 2013 LayerVault. All rights reserved.
//

#import "LVCOrganization.h"
#import "LVCProject.h"
#import "NSDateFormatter+RFC3339.h"

@implementation LVCOrganization

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"name": @"name",
             @"permalink": @"permalink",
             @"dateDeleted": @"deleted_at",
             @"dateUpdated": @"updated_at",
             @"url": @"full_url",
             @"projects": @"projects"};
}


+ (NSValueTransformer *)dateDeletedJSONTransformer
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


+ (NSValueTransformer *)urlJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}


+ (NSValueTransformer *)projectsJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:LVCProject.class];
}

@end
