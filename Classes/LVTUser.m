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
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^NSArray *(NSArray *array) {
        NSValueTransformer *transformer = [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:LVTProject.class];

        // NOTE: organizations don't return fully-realized projects, only enough
        // information to load the project later.
        NSArray *partialProjects = [transformer transformedValue:array];
        NSMutableArray *proxyProjects = @[].mutableCopy;
        for (LVTProject *partialProject in partialProjects) {
            LVTProjectProxy *proxyProject = [[LVTProjectProxy alloc] initWithPartialProject:partialProject];
            [proxyProjects addObject:proxyProject];
        }
        return proxyProjects;
    } reverseBlock:^NSArray *(NSArray *array) {
        NSMutableArray *fullProjects = @[].mutableCopy;
        for (LVTProjectProxy *proxy in array) {
            NSAssert([proxy isKindOfClass:LVTProjectProxy.class],
                     @"Proxy should be LVTProjectProxy but is %@", NSStringFromClass(proxy.class));
            if (proxy.futureProject) {
                [fullProjects addObject:[MTLJSONAdapter JSONDictionaryFromModel:proxy.futureProject]];
            }
        }
        return fullProjects;
    }];
}

@end
