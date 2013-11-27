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
#import "LVTProjectProxy.h"

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
    return [LVTProjectProxy valueTransformerForProxyProjects];
}


- (BOOL)validateValue:(inout __autoreleasing id *)ioValue
               forKey:(NSString *)inKey
                error:(out NSError *__autoreleasing *)outError
{
    if ([LVTUser.requiredProperties containsObject:inKey]) {
        NSLog(@"%@ cannot have nil %@", NSStringFromClass(self.class), inKey);
        if (!ioValue) {
            return NO;
        }
    }
    return [super validateValue:ioValue forKey:inKey error:outError];
}

@end
