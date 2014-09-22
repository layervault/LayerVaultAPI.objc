//
//  MRTFilesResponse.m
//  Pods
//
//  Created by Matt Thomas on 9/18/14.
//
//

#import "MRTFilesResponse.h"
#import "NSValueTransformer+LVCPredefinedTransformerAdditions.h"

@implementation MRTFilesResponse
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"fileResponses": @"files"};
}

+ (NSValueTransformer *)fileResponsesJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:MRTFileResponse.class];
}
@end


@implementation MRTFileResponse
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"uid": @"id",
             @"href": @"href",
             @"dateCreated": @"created_at",
             @"dateUpdated": @"updated_at",
             @"name": @"name",
             @"slug": @"slug",
             @"url": @"url",
             @"canEditNode": @"can_edit_node",
             @"canCommentOnFile": @"can_comment_on_file",
             @"dateDeleted": @"deleted_at",
             @"revisionCount": @"num_revisions",
             @"lastRevisionID": @"links.last_revision",
             @"lastPreviewID": @"links.last_preview",
             @"projectID": @"links.project",
             @"folderID": @"links.folder",
             @"revisionClusterIDs": @"links.revision_clusters",
             @"feedbackThreadIDs": @"links.feedback_threads"};
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

+ (NSValueTransformer *)urlJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)dateDeletedJSONTransformer {
    return [NSValueTransformer valueTransformerForName:LVCRFC3339DateTransformerName];
}
@end