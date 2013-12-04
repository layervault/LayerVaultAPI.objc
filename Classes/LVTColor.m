//
//  LVTColor..
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 12/3/13.
//  Copyright (c) 2013 codecaffeine. All rights reserved.
//

#import "LVTColor.h"

NSString *LVTDefaultColor = @"white";

@implementation LVTColorUtils

+ (NSDictionary *)colorNamesToValue
{
    return @{LVTDefaultColor: @(LVTColorWhite),
             @"green": @(LVTColorGreen),
             @"red": @(LVTColorRed),
             @"orange": @(LVTColorOrange)};
}

+ (NSColor *)colorForLabel:(LVTColorLabel)label
{
    switch (label) {
        case LVTColorGreen:
            return [NSColor greenColor];
        case LVTColorRed:
            return [NSColor redColor];
        case LVTColorOrange:
            return [NSColor orangeColor];
        default:
            return [NSColor whiteColor];
    }
}

+ (NSString *)colorNameForLabel:(LVTColorLabel)label
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
