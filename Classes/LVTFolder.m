//
//  LVTFolder.m
//  Pods
//
//  Created by Matt Thomas on 12/4/13.
//
//

#import "LVTFolder.h"
#import "LVTFile.h"

NSString *const LVTFolderOrganizationPermalinkJSONKey = @"organization_permalink";


@implementation LVTFolder
+ (NSDateFormatter *)dateFormatter
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
    return dateFormatter;
}


+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"colorLabel": @"color",
             @"path": @"path",
             @"fileURL": @"local_path",
             @"dateUpdated": @"updated_at",
             @"dateDeleted": @"deleted_at",
             @"md5": @"md5",
             @"url": @"full_url",
             @"shortURL": @"shortened_url",
             @"organizationPermalink": @"organization_permalink",
             @"files": @"files",
             @"folders": @"folders"};
}


+ (NSValueTransformer *)colorLabelJSONTransformer
{
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:[LVTColorUtils colorNamesToValue]];
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


+ (NSValueTransformer *)filesJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:LVTFile.class];
}


+ (NSValueTransformer *)foldersJSONTransformer
{
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:LVTFolder.class];
}


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
