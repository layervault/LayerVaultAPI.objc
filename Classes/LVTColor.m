//
//  LVTColor..
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 12/3/13.
//  Copyright (c) 2013 codecaffeine. All rights reserved.
//

#import "LVTColor.h"

@implementation LVTColorUtils

+ (NSDictionary *)colorNamesToValue
{
    return @{@"white": @(LVTColorWhite),
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

@end
