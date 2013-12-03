//
//  LVTProject.m
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 10/25/13.
//  Copyright (c) 2013 codecaffeine. All rights reserved.
//

#import "LVTProject.h"
#import "LVTFile.h"

NSString *const LVTProjectJSONKeyName = @"name";
NSString *const LVTProjectJSONKeyOrganizationPermalink = @"organization_permalink";


@interface LVTProject ()
@property (nonatomic) LVTColorLabel colorLabel;
@end


@implementation LVTProject

- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue
                          isSynced:(BOOL)synced
                             error:(NSError *__autoreleasing *)error
{
    self = [super initWithDictionary:dictionaryValue error:error];
    if (self) {
        _synced = synced;
    }
    return self;
}


- (instancetype)initWithName:(NSString *)name
       organizationPermalink:(NSString *)organizationPermalink
{
    NSParameterAssert(name);
    NSParameterAssert(organizationPermalink);

    NSDictionary *dict = @{LVTProjectJSONKeyName: name,
                           LVTProjectJSONKeyOrganizationPermalink: organizationPermalink};

    return [self initWithDictionary:dict isSynced:NO error:nil];
}


- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError *__autoreleasing *)error
{
    return [self initWithDictionary:dictionaryValue isSynced:YES error:error];
}


+ (NSDateFormatter *)dateFormatter
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
    return dateFormatter;
}


+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"name": LVTProjectJSONKeyName,
             @"colorLabel": @"color",
             @"path": @"path",
             @"fileURL": @"local_path",
             @"dateUpdated": @"updated_at",
             @"dateDeleted": @"deleted_at",
             @"md5": @"md5",
             @"url": @"full_url",
             @"shortURL": @"shortened_url",
             @"organizationPermalink": LVTProjectJSONKeyOrganizationPermalink,
             @"files": @"files"};
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


- (BOOL)partial
{
    return !self.path;
}


@end
