//
//  MRTFoldersResponse.m
//  Pods
//
//  Created by Matt Thomas on 9/18/14.
//
//

#import "MRTFoldersResponse.h"

@implementation MRTFoldersResponse
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"folderResponses": @"folders"};
}

+ (NSValueTransformer *)folderResponsesJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:MRTFolderResponse.class];
}
@end


@implementation MRTFolderResponse
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"folderID": @"id",
             @"name": @"name",
             @"slug": @"slug",
             @"url": @"url",
             @"projectID": @"links.project",
             @"folderIDs": @"links.folders",
             @"fileIDs": @"links.files"};
}

+ (NSValueTransformer *)urlJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}
@end
