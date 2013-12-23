//
//  LVCColorCircleView.m
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 12/22/13.
//  Copyright (c) 2013 LayerVault. All rights reserved.
//

#import "LVCColorCircleView.h"

static NSCache *LVCColorCircleViewCache = nil;
static NSRect LVCColorCircleViewRect = {.size = { .width = 15.0, .height = 15.0}};

@implementation LVCColorCircleView

+ (void)initialize {
    if (self == [LVCColorCircleView class]) {
        LVCColorCircleViewCache = [[NSCache alloc] init];
        [LVCColorCircleViewCache setCountLimit:10];
    }
}

+ (NSImage *)circleImageWithColorLabel:(LVCColorLabel)colorLabel {
    NSNumber *colorID = @(colorLabel);
    NSImage *image = [LVCColorCircleViewCache objectForKey:colorID];
    if (!image) {
        NSColor *color = [LVCColorUtils colorForLabel:colorLabel];
        LVCColorCircleView *circle = [[LVCColorCircleView alloc] initWithFrame:LVCColorCircleViewRect
                                                                         color:color];
        image = [[NSImage alloc] initWithData:[circle dataWithPDFInsideRect:LVCColorCircleViewRect]];
        [LVCColorCircleViewCache setObject:image forKey:colorID];
    }
    return image;
}

+ (NSImage *)squareImage {
    NSNumber *colorID = @(-1);
    NSImage *image = [LVCColorCircleViewCache objectForKey:colorID];
    if (!image) {
        LVCColorCircleView *circle = [[LVCColorCircleView alloc] initWithFrame:LVCColorCircleViewRect];
        image = [[NSImage alloc] initWithData:[circle dataWithPDFInsideRect:LVCColorCircleViewRect]];
        [LVCColorCircleViewCache setObject:image forKey:colorID];
    }
    return image;
}

#pragma mark - Instance Methods
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

    NSBezierPath *path = [NSBezierPath bezierPath];
    CGRect rect = CGRectInset(self.bounds, 1.0, 1.0);
    NSColor *strokeColor = [NSColor darkGrayColor];
    [strokeColor setStroke];

    if (self.color) {
        [self.color setFill];
        [path appendBezierPathWithOvalInRect:rect];
    }
    else {
        [[NSColor whiteColor] setFill];
        [path appendBezierPathWithRect:rect];
    }
    [path fill];
    [path addClip];
    path.lineWidth = 2.0;
    [path stroke];

    [context restoreGraphicsState];
}

@end
