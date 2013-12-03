//
//  LVTColor.h
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 12/3/13.
//  Copyright (c) 2013 codecaffeine. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    LVTColorWhite = 0,
    LVTColorGreen = 2,
    LVTColorRed = 6,
    LVTColorOrange = 7
} LVTColorValues;

@interface LVTColor : NSObject

+ (NSDictionary *)colorNamesToValue;
+ (NSColor *)colorForLabel:(NSNumber *)label;

@end