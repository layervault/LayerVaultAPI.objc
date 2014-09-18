//
//  MRTOrganizationsResponse.m
//  Pods
//
//  Created by Matt Thomas on 9/18/14.
//
//

#import "MRTOrganizationsResponse.h"
#import <LayerVaultAPI/LayerVaultAPI.h>

@implementation MRTOrganizationsResponse
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"organizationResponses": @"organizations"};
}

+ (NSValueTransformer *)organizationResponsesJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:MRTOrganizationResponse.class];
}
@end


@implementation MRTOrganizationResponse
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"organizationID": @"id",
             @"name": @"name",
             @"slug": @"slug",
             @"isFree": @"is_free",
             @"dateDeleted": @"deleted_at",
             @"dateUpdated": @"updated_at",
             @"dateCreated": @"created_at",
             @"dateCancelled": @"cancelled_at",
             @"url": @"url",
             @"syncType": @"sync_type",
             @"projectIDs": @"links.projects",
             @"administratorIDs": @"links.administrators",
             @"editorIDs": @"links.editors",
             @"spectatorIDs": @"links.spectators"};
}

+ (NSValueTransformer *)dateDeletedJSONTransformer {
    return [NSValueTransformer valueTransformerForName:LVCRFC3339DateTransformerName];
}

+ (NSValueTransformer *)dateUpdatedJSONTransformer {
    return [NSValueTransformer valueTransformerForName:LVCRFC3339DateTransformerName];
}

+ (NSValueTransformer *)dateCreatedJSONTransformer {
    return [NSValueTransformer valueTransformerForName:LVCRFC3339DateTransformerName];
}


+ (NSValueTransformer *)dateCancelledJSONTransformer {
    return [NSValueTransformer valueTransformerForName:LVCRFC3339DateTransformerName];
}

+ (NSValueTransformer *)urlJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)syncTypeJSONTransformer {
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:
            @{@"layervault": @(LVCSyncTypeLayerVault),
              @"dropbox": @(LVCSyncTypeDropBox)}];
}
@end
