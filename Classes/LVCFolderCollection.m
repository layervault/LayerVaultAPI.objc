//
//  LVCFolderCollection.m
//  Pods
//
//  Created by Matt Thomas on 9/18/14.
//
//

#import "LVCFolderCollection.h"
#import "NSValueTransformer+LVCPredefinedTransformerAdditions.h"

@implementation LVCFolderCollection
+ (NSString *)collectionKey {
    return @"folders";
}

+ (Class)modelClass {
    return [LVCFolderValue class];
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"folders": [self collectionKey]};
}

+ (NSValueTransformer *)foldersJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[self modelClass]];
}
@end


@implementation LVCFolderValue
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"uid": @"id",
             @"href": @"href",
             @"dateCreated": @"created_at",
             @"dateUpdated": @"updated_at",
             @"slug": @"slug",
             @"name": @"name",
             @"url": @"url",
             @"projectID": @"links.project",
             @"parentFolderID": @"links.parent_folder",
             @"folderIDs": @"links.folders",
             @"fileIDs": @"links.files"};
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
@end
