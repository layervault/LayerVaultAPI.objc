//
//  LVTFolder.m
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 12/4/13.
//  Copyright (c) 2013 codecaffeine. All rights reserved.
//

#import "LVTFolder.h"
#import "LVCFile.h"


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
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:[LVCColorUtils colorNamesToValue]];
}

+ (NSValueTransformer *)filesJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:LVCFile.class];
}


+ (NSValueTransformer *)foldersJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:LVTFolder.class];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue
                             error:(NSError *__autoreleasing *)error
{
    self = [super initWithDictionary:dictionaryValue error:error];
    if (self) {
        for (LVTNode *node in [self.files arrayByAddingObjectsFromArray:self.folders]) {
            node.parentFolder = self;
        }
    }
    return self;
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
        self.colorLabel = LVCColorWhite;
    } else {
        [super setNilValueForKey:key];
    }
}

@end
