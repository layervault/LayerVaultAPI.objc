//
//  MRTUsersResponse.m
//  Pods
//
//  Created by Matt Thomas on 9/18/14.
//
//

#import "MRTUsersResponse.h"

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
    return @{@"userID": @"id",
             @"email": @"email",
             @"firstName": @"first_name",
             @"lastName": @"last_name",
             @"organizationIDs": @"links.organizations",
             @"hasSeenTour": @"has_seen_tour",
             @"hasConfiguredAccount": @"has_configured_account"};
}
@end
