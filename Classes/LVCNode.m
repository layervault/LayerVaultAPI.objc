//
//  LVCNode.m
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 12/9/13.
//  Copyright (c) 2013 LayerVault. All rights reserved.
//

#import "LVCNode.h"
#import "LVCFolder.h"

@implementation LVCNode {
    __weak LVCFolder *_parentFolder;
}

+ (NSDateFormatter *)dateFormatter
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
    return dateFormatter;
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


@end
