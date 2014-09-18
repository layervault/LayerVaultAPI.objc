//
//  MRTProjectsResponse.m
//  Pods
//
//  Created by Matt Thomas on 9/18/14.
//
//

#import "MRTProjectsResponse.h"

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
    return @{@"projectID": @"id",
             @"name": @"name",
             @"slug": @"slug",
             @"url": @"url",
             @"organizationID": @"links.organization",
             @"folderIDs": @"links.folders",
             @"fileIDs": @"links.files",
             @"presentationIDs": @"links.presentations",
             @"userIDs": @"links.users"};
}

+ (NSValueTransformer *)urlJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}
@end
