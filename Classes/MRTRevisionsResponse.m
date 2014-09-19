//
//  MRTRevisionsResponse.m
//  Pods
//
//  Created by Matt Thomas on 9/18/14.
//
//

#import "MRTRevisionsResponse.h"
#import "NSValueTransformer+LVCPredefinedTransformerAdditions.h"

@implementation MRTRevisionsResponse
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"requestResponses": @"requests"};
}

+ (NSValueTransformer *)projectResponsesJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:MRTRevisionResponse.class];
}
@end


@implementation MRTRevisionResponse
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"revisionID": @"id",
             @"previewIDs": @"links.previews",
             @"userID": @"links.user",
             @"metadataID": @"links.metadatum",
             @"slug": @"slug",
             @"revisionNumber": @"revision_number",
             @"shortURL": @"shortened_url",
             @"dateCreated": @"created_at",
             @"dateDeleted": @"deleted_at",
             @"dateUpdated": @"updated_at",
             @"parentMD5": @"parent_md5",
             @"md5": @"md5",
             @"assembledFileDataFingerprint": @"assembled_file_data_fingerprint",
             @"fileDataFingerprint": @"file_data_fingerprint",
             @"remoteURL": @"remote_url",
             @"downloadURL": @"download_url",
             @"dropboxSyncRevision": @"dropbox_sync_revision"};
}

+ (NSValueTransformer *)shortURLJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)dateCreatedJSONTransformer {
    return [NSValueTransformer valueTransformerForName:LVCRFC3339DateTransformerName];
}

+ (NSValueTransformer *)dateModifiedJSONTransformer {
    return [NSValueTransformer valueTransformerForName:LVCRFC3339DateTransformerName];
}

+ (NSValueTransformer *)dateDeletedJSONTransformer {
    return [NSValueTransformer valueTransformerForName:LVCRFC3339DateTransformerName];
}

+ (NSValueTransformer *)remoteURLJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)downloadURLJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}
@end