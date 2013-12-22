//
//  LVCColorCircleView.h
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 12/22/13.
//  Copyright (c) 2013 LayerVault. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface LVCColorCircleView : NSView
@property (nonatomic, readonly) NSColor *color;
- (instancetype)initWithFrame:(NSRect)frame color:(NSColor *)color;
@end
