//
//  LVCFile.m
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 11/18/13.
//  Copyright (c) 2013 LayerVault. All rights reserved.
//

#import "LVCFile.h"
#import "LVCFileRevision.h"
#import "NSDateFormatter+RFC3339.h"

@implementation LVCFile

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
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:LVCFileRevision.class];
}


+ (NSValueTransformer *)dateModifiedJSONTransformer
{
    return [MTLValueTransformer
            reversibleTransformerWithForwardBlock:^NSDate *(NSString *string) {
                return [[NSDateFormatter lvc_rfc3339DateFormatter] dateFromString:string];
            }
            reverseBlock:^NSString *(NSDate *date) {
                return [[NSDateFormatter lvc_rfc3339DateFormatter] stringFromDate:date];
            }];
}


+ (NSValueTransformer *)downloadURLJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}


@end
