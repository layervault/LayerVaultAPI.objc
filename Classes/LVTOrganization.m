//
//  LVTOrganization.m
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 10/25/13.
//  Copyright (c) 2013 codecaffeine. All rights reserved.
//

#import "LVTOrganization.h"
#import "LVTProject.h"
#import "LVTProjectProxy.h"

@implementation LVTOrganization

+ (NSDateFormatter *)dateFormatter
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
    return dateFormatter;
}


+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"name": @"name",
//             @"permalink": @"permalink", [TODO] uncomment when server sends this
             @"dateDeleted": @"deleted_at",
             @"dateUpdated": @"updated_at",
             @"url": @"full_url",
             @"projects": @"projects"};
}


+ (NSValueTransformer *)dateDeletedJSONTransformer
{
    return [MTLValueTransformer
            reversibleTransformerWithForwardBlock:^NSDate *(NSString *string) {
                return [[self dateFormatter] dateFromString:string];
            }
            reverseBlock:^NSString *(NSDate *date) {
                return [[self dateFormatter] stringFromDate:date];
            }];
}


+ (NSValueTransformer *)dateUpdatedJSONTransformer
{
    return [MTLValueTransformer
            reversibleTransformerWithForwardBlock:^NSDate *(NSString *string) {
                return [[self dateFormatter] dateFromString:string];
            }
            reverseBlock:^NSString *(NSDate *date) {
                return [[self dateFormatter] stringFromDate:date];
            }];
}


+ (NSValueTransformer *)urlJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
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


// [TODO] Get rid of this when server sends permalink
- (NSString *)permalink
{
    return self.url.lastPathComponent;
}

@end
