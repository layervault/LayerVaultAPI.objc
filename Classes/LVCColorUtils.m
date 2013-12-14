//
//  LVCColorUtils..
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 12/3/13.
//  Copyright (c) 2013 LayerVault. All rights reserved.
//

#import "LVCColorUtils.h"

NSString *LVCDefaultColorDefaultColor = @"white";

@implementation LVCColorUtils

+ (NSDictionary *)colorNamesToValue
{
    return @{LVCDefaultColorDefaultColor: @(LVCColorWhite),
             @"green": @(LVCColorGreen),
             @"red": @(LVCColorRed),
             @"orange": @(LVCColorOrange)};
}

+ (NSColor *)colorForLabel:(LVCColorLabel)label
{
    switch (label) {
        case LVCColorGreen:
            return [NSColor greenColor];
        case LVCColorRed:
            return [NSColor redColor];
        case LVCColorOrange:
            return [NSColor orangeColor];
        default:
            return [NSColor whiteColor];
    }
}

+ (NSString *)colorNameForLabel:(LVCColorLabel)label
{
    __block NSString *colorName = LVCDefaultColorDefaultColor;
    [[self colorNamesToValue] enumerateKeysAndObjectsUsingBlock:^(id key,
                                                                  id obj,
                                                                  BOOL *stop) {
        if ([@(label) isEqualToValue:obj]) {
            colorName = key;
            *stop = YES;
        }
    }];
    return colorName;
}

@end
