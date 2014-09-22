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
    return @{@"revisionResponses": @"revisions"};
}

+ (NSValueTransformer *)revisionResponsesJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:MRTRevisionResponse.class];
}
@end


@implementation MRTRevisionResponse
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"uid": @"id",
             @"href": @"href",
             @"dateCreated": @"created_at",
             @"dateUpdated": @"updated_at",
             @"slug": @"slug",
             @"revisionNumber": @"revision_number",
             @"shortURL": @"shortened_url",
             @"dateDeleted": @"deleted_at",
             @"parentMD5": @"parent_md5",
             @"md5": @"md5",
             @"assembledFileDataFingerprint": @"assembled_file_data_fingerprint",
             @"fileDataFingerprint": @"file_data_fingerprint",
             @"remoteURL": @"remote_url",
             @"downloadURL": @"download_url",
             @"dropboxSyncRevision": @"dropbox_sync_revision",
             @"previewIDs": @"links.previews",
             @"userID": @"links.user",
             @"metadataID": @"links.metadatum"};
}

+ (NSValueTransformer *)hrefJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)dateCreatedJSONTransformer {
    return [NSValueTransformer valueTransformerForName:LVCRFC3339DateTransformerName];
}

+ (NSValueTransformer *)dateUpdatedJSONTransformer {
    return [NSValueTransformer valueTransformerForName:LVCRFC3339DateTransformerName];
}

+ (NSValueTransformer *)shortURLJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
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