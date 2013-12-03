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

+ (NSSet *)requiredProperties
{
    return [NSSet setWithArray:@[@"email"]];
}

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


- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue
                             error:(NSError *__autoreleasing *)error
{
    for (NSString *key in [LVTUser requiredProperties]) {
        if (!dictionaryValue[key]) {
            NSLog(@"%@ cannot have nil %@", NSStringFromClass(self.class), key);
            return nil;
        }
    }
    return [super initWithDictionary:dictionaryValue error:error];
}

@end
