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

+ (LVCColorLabel)colorLabelForName:(NSString *)colorName
{
    NSParameterAssert(colorName);
    NSNumber *labelNumber = self.colorNamesToValue[colorName];
    if (!labelNumber) {
        labelNumber = self.colorNamesToValue[LVCDefaultColorDefaultColor];
    }
    return labelNumber.unsignedIntegerValue;
}

#if TARGET_OS_IPHONE
+ (UIColor *)colorForLabel:(LVCColorLabel)label
{
    switch (label) {
        case LVCColorGreen:
            return [UIColor greenColor];
        case LVCColorRed:
            return [UIColor redColor];
        case LVCColorOrange:
            return [UIColor orangeColor];
        default:
            return [UIColor whiteColor];
    }
}
#elif TARGET_OS_MAC
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
#endif

+ (NSString *)colorNameForLabel:(LVCColorLabel)label
{
    __block NSString *colorName = LVCDefaultColorDefaultColor;
    [self.colorNamesToValue enumerateKeysAndObjectsUsingBlock:^(id key,
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
