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

#warning - Is this really needed?
+ (NSSet *)requiredProperties
{
    return [NSSet setWithArray:@[@"email"]];
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"userID": @"id",
             @"email": @"email",
             @"firstName": @"first_name",
             @"lastName": @"last_name",
             @"organizationIDs": @"links.organizations"};
}


//+ (NSValueTransformer *)adminJSONTransformer
//{
//    return [NSValueTransformer valueTransformerForName:MTLBooleanValueTransformerName];
//}


//+ (NSValueTransformer *)organizationsJSONTransformer
//{
//    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:LVCOrganization.class];
//}


//+ (NSValueTransformer *)projectsJSONTransformer
//{
//    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:LVCProject.class];
//}


- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue
                             error:(NSError *__autoreleasing *)error
{
    for (NSString *key in [LVCUser requiredProperties]) {
        if (!dictionaryValue[key]) {
            NSLog(@"%@ cannot have nil %@", NSStringFromClass(self.class), key);
            return nil;
        }
    }
    return [super initWithDictionary:dictionaryValue error:error];
}

@end
