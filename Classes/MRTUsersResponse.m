//
//  MRTUsersResponse.m
//  Pods
//
//  Created by Matt Thomas on 9/18/14.
//
//

#import "MRTUsersResponse.h"
#import "NSValueTransformer+LVCPredefinedTransformerAdditions.h"

@implementation MRTUsersResponse
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"userResponses": @"users"};
}

+ (NSValueTransformer *)userResponsesJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:MRTUserResponse.class];
}
@end

@implementation MRTUserResponse
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"uid": @"id",
             @"href": @"href",
             @"dateCreated": @"created_at",
             @"dateUpdated": @"updated_at",
             @"email": @"email",
             @"firstName": @"first_name",
             @"lastName": @"last_name",
             @"organizationIDs": @"links.organizations",
             @"hasSeenTour": @"has_seen_tour",
             @"hasConfiguredAccount": @"has_configured_account"};
}

+ (NSValueTransformer *)hrefJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)dateCreatedJSONTransformer {
    return [NSValueTransformer valueTransformerForName:LVCRFC3339DateTransformerName];
}

+ (NSValueTransformer *)dateModifiedJSONTransformer {
    return [NSValueTransformer valueTransformerForName:LVCRFC3339DateTransformerName];
}
@end
