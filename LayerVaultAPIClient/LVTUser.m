//
//  LVTUser.m
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 10/13/13.
//  Copyright (c) 2013 codecaffeine. All rights reserved.
//

#import "LVTUser.h"
#import "LVTOrganization.h"
#import "LVTProject.h"

@implementation LVTUser

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"email": @"email",
             @"firstName": @"first_name",
             @"lastName": @"last_name",
             @"admin": @"is_admin",
             @"organizations": @"organizations",
             @"projects": @"projects"};
}


+ (NSValueTransformer *)adminJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLBooleanValueTransformerName];
}


+ (NSValueTransformer *)organizationsJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:LVTOrganization.class];
}


+ (NSValueTransformer *)projectsJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:LVTProject.class];
}

@end
