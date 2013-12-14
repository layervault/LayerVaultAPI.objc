//
//  LVCColorUtils.h
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 12/3/13.
//  Copyright (c) 2013 codecaffeine. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    LVCColorWhite = 0,
    LVCColorGreen = 2,
    LVCColorRed = 6,
    LVCColorOrange = 7
} LVCColorLabel;

@interface LVCColorUtils : NSObject

+ (NSDictionary *)colorNamesToValue;
+ (NSColor *)colorForLabel:(LVCColorLabel)label;
+ (NSString *)colorNameForLabel:(LVCColorLabel)label;

@end
