//
//  LVCProjectCollection.m
//  Pods
//
//  Created by Matt Thomas on 9/18/14.
//
//

#import "LVCProjectCollection.h"
#import "NSValueTransformer+LVCPredefinedTransformerAdditions.h"

@implementation LVCProjectCollection
+ (NSString *)collectionKey {
    return @"projects";
}

+ (Class)modelClass {
    return [LVCProjectValue class];
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"projects": [self collectionKey]};
}

+ (NSValueTransformer *)projectsJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[self modelClass]];
}

- (NSArray *)allModels{
    return [self projects];
}
@end


@implementation LVCProjectValue
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"uid": @"id",
             @"href": @"href",
             @"dateCreated": @"created_at",
             @"dateUpdated": @"updated_at",
             @"slug": @"slug",
             @"name": @"name",
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

+ (NSValueTransformer *)colorLabelJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^NSNumber *(NSString *colorName) {
        return [NSNumber numberWithUnsignedInteger:[LVCColorUtils colorLabelForName:colorName]];
    } reverseBlock:^NSString *(NSNumber *colorValue) {
        return [LVCColorUtils colorNameForLabel:colorValue.unsignedIntegerValue];
    }];
}
@end
