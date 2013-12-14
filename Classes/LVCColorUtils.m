//
//  LVCColorUtils..
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 12/3/13.
//  Copyright (c) 2013 codecaffeine. All rights reserved.
//

#import "LVCColorUtils.h"

NSString *LVTDefaultColor = @"white";

@implementation LVCColorUtils

+ (NSDictionary *)colorNamesToValue
{
    return @{LVTDefaultColor: @(LVCColorWhite),
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
    __block NSString *colorName = LVTDefaultColor;
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
