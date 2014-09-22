//
//  MRTOrganizationsResponse.m
//  Pods
//
//  Created by Matt Thomas on 9/18/14.
//
//

#import "MRTOrganizationsResponse.h"
#import "NSValueTransformer+LVCPredefinedTransformerAdditions.h"

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
    return @{@"uid": @"id",
             @"href": @"href",
             @"dateCreated": @"created_at",
             @"dateUpdated": @"updated_at",
             @"name": @"name",
             @"slug": @"slug",
             @"url": @"url",
             @"isFree": @"is_free",
             @"dateDeleted": @"deleted_at",
             @"dateCancelled": @"cancelled_at",
             @"syncType": @"sync_type",
             @"isTrialingWithoutPayment": @"is_trialing_without_payment",
             @"dateTrialEnds": @"trial_end_at",
             @"projectIDs": @"links.projects",
             @"administratorIDs": @"links.administrators",
             @"editorIDs": @"links.editors",
             @"spectatorIDs": @"links.spectators"};
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

+ (NSValueTransformer *)dateCancelledJSONTransformer {
    return [NSValueTransformer valueTransformerForName:LVCRFC3339DateTransformerName];
}

+ (NSValueTransformer *)dateTrialEndsJSONTransformer {
    return [NSValueTransformer valueTransformerForName:LVCRFC3339DateTransformerName];
}

+ (NSValueTransformer *)syncTypeJSONTransformer {
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:
            @{@"layervault": @(LVCSyncTypeLayerVault),
              @"dropbox": @(LVCSyncTypeDropBox)}];
}
@end
