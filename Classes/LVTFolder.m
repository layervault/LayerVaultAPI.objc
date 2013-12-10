//
//  LVTFolder.m
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 12/4/13.
//  Copyright (c) 2013 codecaffeine. All rights reserved.
//

#import "LVTFolder.h"
#import "LVTFile.h"


@implementation LVTFolder

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSMutableDictionary *JSONKeyPathsByPropertyKey = [super JSONKeyPathsByPropertyKey].mutableCopy;
    [JSONKeyPathsByPropertyKey addEntriesFromDictionary:@{@"colorLabel": @"color",
                                                          @"path": @"path",
                                                          @"organizationPermalink": @"organization_permalink",
                                                          @"files": @"files",
                                                          @"folders": @"folders"}];
    return JSONKeyPathsByPropertyKey.copy;
}


+ (NSValueTransformer *)colorLabelJSONTransformer
{
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:[LVTColorUtils colorNamesToValue]];
}

+ (NSValueTransformer *)filesJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:LVTFile.class];
}


+ (NSValueTransformer *)foldersJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:LVTFolder.class];
}


// Remove path if it’s nil
- (NSDictionary *)dictionaryValue
{
    NSMutableDictionary *dict = [super dictionaryValue].mutableCopy;

    if ([self valueForKey:@"path"] == nil) {
        [dict removeObjectForKey:@"path"];
    }

    return dict;
}


- (void)setNilValueForKey:(NSString *)key
{
    if ([key isEqualToString:@"colorLabel"]) {
        self.colorLabel = LVTColorWhite;
    } else {
        [super setNilValueForKey:key];
    }
}

@end
