//
//  LVCFileRevisionPreview.m
//  Pods
//
//  Created by Matt Thomas on 12/30/14.
//
//

#import "LVCRevisionPreviewValue.h"
#import "NSValueTransformer+LVCPredefinedTransformerAdditions.h"


@implementation LVCRevisionPreviewCollection
+ (NSString *)collectionKey {
    return @"previews";
}

+ (Class)modelClass {
    return [LVCRevisionPreviewValue class];
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"previews": [self collectionKey]};
}

+ (NSValueTransformer *)previewsJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[self modelClass]];
}

- (NSArray *)allModels {
    return [self previews];
}
@end


@implementation LVCRevisionPreviewValue
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{@"uid": @"id",
             @"href": @"href",
             @"dateCreated": @"created_at",
             @"dateUpdated": @"updated_at",
             @"state": @"type",
             @"revisionID": @"links.revision"};
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

+ (NSValueTransformer *)stateJSONTransformer {
    NSDictionary *dict = @{@"PendingPreview": @(LVCRevisionPreviewStatePending),
                           @"FailedPreview": @(LVCRevisionPreviewStateFailed),
                           @"BlankPreview": @(LVCRevisionPreviewStateBlank),
                           @"DeletedPreview": @(LVCRevisionPreviewStateDeleted),
                           @"DisplayableCode": @(LVCRevisionPreviewStateDisplayableCode),
                           @"Renderable": @(LVCRevisionPreviewStateRenderable)};
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:dict];
}

@end
