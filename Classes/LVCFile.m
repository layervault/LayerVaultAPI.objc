//
//  LVCFile.m
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 11/18/13.
//  Copyright (c) 2013 LayerVault. All rights reserved.
//

#import "LVCFile.h"
#import "NSValueTransformer+LVCPredefinedTransformerAdditions.h"

@implementation LVCFile

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"fileID": @"id",
             @"name": @"name",
             @"slug": @"slug",
             @"canEditNode": @"can_edit_node",
             @"canCommentOnFile": @"can_comment_on_file",
             @"folderID": @"links.folder",
             @"revisionClusterIDs": @"links.revision_clusters",
             @"feedbackThreadIDs": @"links.feedback_threads",
             @"dateCreated": @"created_at",
             @"dateModified": @"updated_at",
             @"dateDeleted": @"deleted_at"};
}

+ (NSValueTransformer *)dateCreatedJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:LVCRFC3339DateTransformerName];
}

+ (NSValueTransformer *)dateModifiedJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:LVCRFC3339DateTransformerName];
}

+ (NSValueTransformer *)dateDeletedJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:LVCRFC3339DateTransformerName];
}

//+ (NSValueTransformer *)downloadURLJSONTransformer
//{
//    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
//}

@end
