//
//  LVCColorCircleView.m
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 12/22/13.
//  Copyright (c) 2013 LayerVault. All rights reserved.
//

#import "LVCColorCircleView.h"

@implementation LVCColorCircleView

- (instancetype)initWithFrame:(NSRect)frame color:(NSColor *)color
{
    self = [super initWithFrame:frame];
    if (self) {
        _color = [color colorUsingColorSpace:[NSColorSpace deviceRGBColorSpace]];
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
	
    // Drawing code here.
    NSGraphicsContext *context = [NSGraphicsContext currentContext];
    [context saveGraphicsState];

    NSColor *strokeColor = [NSColor colorWithHue:self.color.hueComponent
                                      saturation:self.color.saturationComponent
                                      brightness:self.color.brightnessComponent / 2.0
                                           alpha:self.color.alphaComponent];
    [strokeColor setStroke];
    [self.color setFill];

    NSBezierPath *path = [NSBezierPath bezierPath];
    CGRect rect = CGRectInset(self.bounds, 1.0, 1.0);
    [path appendBezierPathWithOvalInRect:rect];
    [path fill];
    [path stroke];

    [context restoreGraphicsState];
}

@end
