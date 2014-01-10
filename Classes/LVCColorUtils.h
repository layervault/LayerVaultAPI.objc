//
//  LVCColorUtils.h
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 12/3/13.
//  Copyright (c) 2013 LayerVault. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Supported Color Labels
 */
typedef enum : NSUInteger {
    LVCColorWhite = 0,
    LVCColorGreen = 2,
    LVCColorRed = 6,
    LVCColorOrange = 7
} LVCColorLabel;

/**
 *  Class methods to translate between OS X labels and LayerVault color names
 */
@interface LVCColorUtils : NSObject

/**
 *  @return Dictionary containing color name keys and their OS X label values.
 */
+ (NSDictionary *)colorNamesToValue;

/**
 *  @param colorName of the color we are looking up
 *
 *  @return LVCColorLabel for a given color name, or LVCColorWhite
 */
+ (LVCColorLabel)colorLabelForName:(NSString *)colorName;

#if TARGET_OS_IPHONE
/**
 *  @param label used to get UIColor for
 *
 *  @return UIColor based on label value
 */
+ (UIColor *)colorForLabel:(LVCColorLabel)label;
#elif TARGET_OS_MAC
/**
 *  @param label used to get NSColor for
 *
 *  @return NSColor based on label value
 */
+ (NSColor *)colorForLabel:(LVCColorLabel)label;
#endif

/**
 *  @param label used to lookup color name
 *
 *  @return NSString of the colorname based on label.
 */
+ (NSString *)colorNameForLabel:(LVCColorLabel)label;

@end
