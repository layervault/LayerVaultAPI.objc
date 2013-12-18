//
//  LVCFolder.m
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 12/4/13.
//  Copyright (c) 2013 LayerVault. All rights reserved.
//

#import "LVCFolder.h"
#import "LVCFile.h"


@implementation LVCFolder

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
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:LVCFolder.class];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue
                             error:(NSError *__autoreleasing *)error
{
    self = [super initWithDictionary:dictionaryValue error:error];
    if (self) {
        for (LVCNode *node in [self.files arrayByAddingObjectsFromArray:self.folders]) {
            node.parentFolder = self;
        }
    }
    return self;
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
