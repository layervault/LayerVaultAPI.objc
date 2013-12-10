//
//  LVTFile.m
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 11/18/13.
//  Copyright (c) 2013 codecaffeine. All rights reserved.
//

#import "LVTFile.h"
#import "LVTFileRevision.h"

@implementation LVTFile

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSMutableDictionary *JSONKeyPathsByPropertyKey = [super JSONKeyPathsByPropertyKey].mutableCopy;
    [JSONKeyPathsByPropertyKey addEntriesFromDictionary:@{@"revisionNumber": @"revision_number",
                                                          @"revisions": @"revisions",
                                                          @"dateModified": @"modified_at",
                                                          @"downloadURL": @"download_url"}];
    return JSONKeyPathsByPropertyKey.copy;
}


+ (NSValueTransformer *)revisionsJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:LVTFileRevision.class];
}


+ (NSValueTransformer *)dateModifiedJSONTransformer
{
    return [MTLValueTransformer
            reversibleTransformerWithForwardBlock:^NSDate *(NSString *string) {
                return [[self dateFormatter] dateFromString:string];
            }
            reverseBlock:^NSString *(NSDate *date) {
                return [[self dateFormatter] stringFromDate:date];
            }];
}


+ (NSValueTransformer *)downloadURLJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}


@end
