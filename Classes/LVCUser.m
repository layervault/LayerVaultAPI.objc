//
//  LVCUser.m
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 10/13/13.
//  Copyright (c) 2013 LayerVault. All rights reserved.
//

#import "LVCUser.h"
#import "LVCOrganization.h"
#import "LVCProject.h"

@implementation LVCUser

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"userID": @"id",
             @"email": @"email",
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
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:LVCOrganization.class];
}

+ (NSValueTransformer *)projectsJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:LVCProject.class];
}

+ (instancetype)userFromValue:(LVCUserValue *)userValue
{
    LVCUser *user = [[LVCUser alloc] init];
    user.uid = userValue.uid;
    user.userID = (NSUInteger)[userValue.uid integerValue];
    user.email = userValue.email;
    user.firstName = userValue.firstName;
    user.lastName = userValue.lastName;
    return user;
}

@end
