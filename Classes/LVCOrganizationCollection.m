//
//  LVCOrganizationCollection.m
//  Pods
//
//  Created by Matt Thomas on 9/18/14.
//
//

#import "LVCOrganizationCollection.h"
#import "NSValueTransformer+LVCPredefinedTransformerAdditions.h"

@implementation LVCOrganizationCollection
+ (NSString *)collectionKey {
    return @"organizations";
}

+ (Class)modelClass {
    return [LVCOrganizationValue class];
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"organizations": [self collectionKey]};
}

+ (NSValueTransformer *)organizationsJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[self modelClass]];
}
@end


@implementation LVCOrganizationValue
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"uid": @"id",
             @"href": @"href",
             @"dateCreated": @"created_at",
             @"dateUpdated": @"updated_at",
             @"slug": @"slug",
             @"name": @"name",
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
