//
//  LVCFileRevisionFeedback.m
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 12/16/13.
//  Copyright (c) 2013 LayerVault. All rights reserved.
//

#import "LVCFileRevisionFeedback.h"
#import "NSValueTransformer+LVCPredefinedTransformerAdditions.h"

@implementation LVCFileRevisionFeedback

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"feedbackID": @"id",
             @"previewID": @"left_on_preview_id",
             @"signpostID": @"left_on_signpost_id",
             @"userID": @"user_id",
             @"top": @"top",
             @"right": @"right",
             @"left": @"left",
             @"bottom": @"bottom",
             @"message": @"message",
             @"associatedSignpostID": @"signpost_id",
             @"dateCreated": @"created_at"};
}

+ (NSValueTransformer *)dateCreatedJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:LVCRFC3339DateTransformerName];
}


#pragma mark - Declared Properties
- (CGRect)feedbackFrame
{
    return CGRectMake(self.top.doubleValue,
                      self.left.doubleValue,
                      self.right.doubleValue - self.left.doubleValue,
                      self.bottom.doubleValue - self.top.doubleValue);
}

@end
