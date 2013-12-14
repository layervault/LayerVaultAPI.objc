//
//  LVCMainWindowController.h
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 12/14/13.
//  Copyright (c) 2013 LayerVault. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class LVCUser;

@interface LVCMainWindowController : NSWindowController
@property (nonatomic) LVCUser *user;
@end
