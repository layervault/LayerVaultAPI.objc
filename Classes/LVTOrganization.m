//
//  LVTOrganization.m
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 10/25/13.
//  Copyright (c) 2013 codecaffeine. All rights reserved.
//

#import "LVTOrganization.h"
#import "LVTProject.h"

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
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:LVTProject.class];
}

@end
