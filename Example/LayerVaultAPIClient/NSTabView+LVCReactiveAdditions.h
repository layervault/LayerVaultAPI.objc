//
//  NSTabView+LVCReactiveAdditions.h
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 10/15/14.
//  Copyright (c) 2014 LayerVault. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RACSignal;

@interface NSTabView (LVCReactiveAdditions) <NSTabViewDelegate>

- (RACSignal *)lvc_tabSignal;

@end
