//
//  NSTabView+LVCReactiveAdditions.m
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 10/15/14.
//  Copyright (c) 2014 LayerVault. All rights reserved.
//

#import "NSTabView+LVCReactiveAdditions.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <objc/runtime.h>

@implementation NSTabView (LVCReactiveAdditions)

- (RACSignal *)lvc_tabSignal {
    self.delegate = self;
    RACSignal *signal = objc_getAssociatedObject(self, _cmd);
    if (signal != nil) return signal;

    /* Create signal from selector */
    signal = [[self rac_signalForSelector:@selector(tabView:didSelectTabViewItem:)
                             fromProtocol:@protocol(NSTabViewDelegate)] map:^id(RACTuple *tuple) {
        return tuple.second;
    }];

    objc_setAssociatedObject(self, _cmd, signal, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return signal;
}

@end
