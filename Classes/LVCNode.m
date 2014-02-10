//
//  LVCNode.m
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 12/9/13.
//  Copyright (c) 2013 LayerVault. All rights reserved.
//

#import "LVCNode.h"
#import "LVCFolder.h"
#import "NSValueTransformer+LVCPredefinedTransformerAdditions.h"
#import "NSString+PercentEncoding.h"

@interface LVCNode ()
@property (nonatomic, copy) NSString *md5;
@end

@implementation LVCNode {
    __weak LVCFolder *_parentFolder;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"name": @"name",
             @"fileURL": @"local_path",
             @"dateUpdated": @"updated_at",
             @"dateDeleted": @"deleted_at",
             @"md5": @"md5",
             @"url": @"full_url",
             @"shortURL": @"shortened_url"};
}

+ (NSValueTransformer *)fileURLJSONTransformer
{
    return [MTLValueTransformer
            reversibleTransformerWithForwardBlock:^NSURL *(NSString *localPath) {
                return [NSURL fileURLWithPath:[localPath stringByStandardizingPath]];
            }
            reverseBlock:^NSString *(NSURL *fileURL) {
                return [fileURL.path stringByAbbreviatingWithTildeInPath];
            }];
}

+ (NSValueTransformer *)dateDeletedJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:LVCRFC3339DateTransformerName];
}


+ (NSValueTransformer *)dateUpdatedJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:LVCRFC3339DateTransformerName];
}


+ (NSValueTransformer *)urlJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}


+ (NSValueTransformer *)shortURLJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}


- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue
                             error:(NSError *__autoreleasing *)error
{
    if (![dictionaryValue.allKeys containsObject:@"name"]) {
        return nil;
    }
    self = [super initWithDictionary:dictionaryValue error:error];
    return self;
}


- (NSString *)description {
    NSMutableDictionary *dict = self.dictionaryValue.mutableCopy;
    if (self.parentFolder) {
        dict[@"parentFolder"] = [NSString stringWithFormat:@"<%@: %p>",
                                 self.parentFolder.class,
                                 self.parentFolder];
    }
	return [NSString stringWithFormat:@"<%@: %p> %@", self.class, self, dict];
}


- (NSUInteger)hash {
	NSUInteger value = 0;

	for (NSString *key in self.class.propertyKeys) {
        if ([key isEqualToString:@"parentFolder"]) {
            continue;
        }
		value ^= [[self valueForKey:key] hash];
	}

	return value;
}

- (BOOL)isEqual:(MTLModel *)model {
	if (self == model) return YES;
	if (![model isMemberOfClass:self.class]) return NO;

	for (NSString *key in self.class.propertyKeys) {
        if ([key isEqualToString:@"parentFolder"]) {
            continue;
        }
		id selfValue = [self valueForKey:key];
		id modelValue = [model valueForKey:key];

		BOOL valuesEqual = ((selfValue == nil && modelValue == nil) || [selfValue isEqual:modelValue]);
		if (!valuesEqual) return NO;
	}
    
	return YES;
}


- (NSString *)urlPath
{
    if (self.parentFolder) {
        return [self.parentFolder.urlPath stringByAppendingPathComponent:self.name];
    }
    return self.name;
}


- (NSString *)percentEncodedURLPath
{
    NSString *percentEncodedName = [self.name lv_stringWithFullPercentEncoding];
    if (self.parentFolder) {
        return [self.parentFolder.percentEncodedURLPath stringByAppendingPathComponent:percentEncodedName];
    }
    return percentEncodedName;
}


@end
