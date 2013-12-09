//
//  LVTNode.m
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 12/9/13.
//  Copyright (c) 2013 codecaffeine. All rights reserved.
//

#import "LVTNode.h"

@implementation LVTNode

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


@end
