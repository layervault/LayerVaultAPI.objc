//
//  MRTProjectsResponse.m
//  Pods
//
//  Created by Matt Thomas on 9/18/14.
//
//

#import "MRTProjectsResponse.h"
#import "NSValueTransformer+LVCPredefinedTransformerAdditions.h"

@implementation MRTProjectsResponse
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"projectResponses": @"projects"};
}

+ (NSValueTransformer *)projectResponsesJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:MRTProjectResponse.class];
}
@end


@implementation MRTProjectResponse
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"uid": @"id",
             @"href": @"href",
             @"dateCreated": @"created_at",
             @"dateUpdated": @"updated_at",
             @"name": @"name",
             @"slug": @"slug",
             @"url": @"url",
             @"isPublic": @"is_public",
             @"colorLabel": @"color",
             @"organizationID": @"links.organization",
             @"folderIDs": @"links.folders",
             @"fileIDs": @"links.files",
             @"presentationIDs": @"links.presentations",
             @"userIDs": @"links.users"};
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

+ (NSValueTransformer *)syncTypeJSONTransformer {
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:
            [LVCColorUtils colorNamesToValue]];
}
@end
