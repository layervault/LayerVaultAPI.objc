//
//  LVCFile.m
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 11/18/13.
//  Copyright (c) 2013 LayerVault. All rights reserved.
//

#import "LVCFile.h"
#import "LVCFileRevision.h"
#import "NSValueTransformer+LVCPredefinedTransformerAdditions.h"
#import <CommonCrypto/CommonDigest.h>


NSString *md5ForFileURL(NSURL *fileURL)
{
    NSError *error;
    NSData *data = [NSData dataWithContentsOfURL:fileURL
                                         options:NSDataReadingMappedIfSafe
                                           error:&error];
    if (!data) {
        NSLog(@"%@", error);
        return nil;
    }

    unsigned char md[CC_MD5_DIGEST_LENGTH];
    CC_MD5([data bytes], (unsigned int)[data length], md);
    NSMutableString *md5 = [NSMutableString string];
    for (NSUInteger i = 0; i < CC_MD5_DIGEST_LENGTH; ++i) {
        [md5 appendFormat:@"%02x", md[i]];
    }

    return md5;
}

@interface LVCFile ()
@property (nonatomic, copy) NSString *md5;
@end


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
    return [NSValueTransformer valueTransformerForName:LVCRFC3339DateTransformerName];
}


+ (NSValueTransformer *)downloadURLJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}


- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue
                             error:(NSError *__autoreleasing *)error
{
    self = [super initWithDictionary:dictionaryValue error:error];
    if (self) {
        for (LVCFileRevision *fileRevision in _revisions) {
            fileRevision.file = self;
        }
    }
    return self;
}


#pragma mark - Instance Methods
- (void)updateMD5FromLocalFile
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.fileURL.path]) {
        self.md5 = md5ForFileURL(self.fileURL);
    }
    else {
        NSLog(@"File not found locally: %@", self.fileURL);
    }
}


- (LVCFileRevision *)revisionWithNumber:(NSNumber *)number
{
    LVCFileRevision *revision = nil;

    // Check by array position
    if (number.unsignedIntegerValue <= self.revisions.count) {
        LVCFileRevision *candidate = self.revisions[(number.unsignedIntegerValue - 1)];
        if ([candidate.revision isEqual:number]) {
            revision = candidate;
        }
    }

    // If not found, iterate array
    if (!revision) {
        for (LVCFileRevision *candidate in self.revisions) {
            if ([candidate.revision isEqual:number]) {
                revision = candidate;
                break;
            }
        }
    }

    return revision;
}

@end
