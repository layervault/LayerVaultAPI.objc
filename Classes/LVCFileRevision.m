//
//  LVCFileRevision.m
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 11/18/13.
//  Copyright (c) 2013 LayerVault. All rights reserved.
//

#import "LVCFileRevision.h"
#import "LVCFile.h"
#import "NSValueTransformer+LVCPredefinedTransformerAdditions.h"

@implementation LVCFileRevision

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"revision": @"revision_number",
             @"md5": @"md5",
             @"size": @"file_size",
             @"dateCreated": @"created_at",
             @"dateUpdated": @"updated_at",
             @"webURL": @"full_url",
             @"downloadURL": @"download_url",
             @"shortenedURL": @"shortened_url"};
}


+ (NSValueTransformer *)dateCreatedJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:LVCRFC3339DateTransformerName];
}


+ (NSValueTransformer *)dateUpdatedJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:LVCRFC3339DateTransformerName];
}


+ (NSValueTransformer *)shortURLJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}


+ (NSValueTransformer *)downloadURLJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}


+ (NSValueTransformer *)shortenedURLJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}


#pragma mark - NSObject
- (NSString *)description
{
    NSMutableDictionary *dict = self.dictionaryValue.mutableCopy;
    if (self.file) {
        dict[@"file"] = [NSString stringWithFormat:@"<%@: %p>",
                         self.file.class,
                         self.file];
    }
	return [NSString stringWithFormat:@"<%@: %p> %@", self.class, self, dict];
}


- (NSUInteger)hash {
	NSUInteger value = 0;

	for (NSString *key in self.class.propertyKeys) {
        if ([key isEqualToString:@"file"]) {
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
        if ([key isEqualToString:@"file"]) {
            continue;
        }
		id selfValue = [self valueForKey:key];
		id modelValue = [model valueForKey:key];

		BOOL valuesEqual = ((selfValue == nil && modelValue == nil) || [selfValue isEqual:modelValue]);
		if (!valuesEqual) return NO;
	}

	return YES;
}


#pragma mark - Declared Properties
- (NSString *)urlPath
{
    return [self.file.urlPath stringByAppendingPathComponent:[self.revision stringValue]];
}


- (NSString *)percentEncodedURLPath
{
    return [self.file.percentEncodedURLPath stringByAppendingPathComponent:[self.revision stringValue]];
}

@end
