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
    return @{@"fileID": @"id",
             @"name": @"name",
             @"slug": @"slug",
             @"lastRevisionID": @"links.last_revision",
             @"canEditNode": @"can_edit_node",
             @"canCommentOnFile": @"can_comment_on_file",
             @"folderID": @"links.folder",
             @"revisionClusterIDs": @"links.revision_clusters",
             @"feedbackThreadIDs": @"links.feedback_threads",
             @"dateCreated": @"created_at",
             @"dateModified": @"updated_at",
             @"dateDeleted": @"deleted_at"};
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
@end