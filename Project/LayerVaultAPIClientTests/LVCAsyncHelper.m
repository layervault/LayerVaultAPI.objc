//
//  LVCAsyncHelper.m
//  LayerVault
//
//  Created by Matt Thomas on 7/25/13.
//  Copyright (c) 2013 LayerVault. All rights reserved.
//

#import "LVCAsyncHelper.h"

@implementation LVCAsyncHelper

+ (void)wait:(NSTimeInterval)wait
{
    NSDate *future = [NSDate dateWithTimeIntervalSinceNow:wait];
    while (([(NSDate *)[NSDate date] compare:future] == NSOrderedAscending)) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:future];
        
    }
}

@end
