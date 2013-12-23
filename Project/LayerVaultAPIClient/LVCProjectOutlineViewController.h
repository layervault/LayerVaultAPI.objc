//
//  LVCProjectOutlineViewController.h
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 12/15/13.
//  Copyright (c) 2013 LayerVault. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class LVCProject;
@class LVCFile;

@interface LVCProjectOutlineViewController : NSViewController
@property (nonatomic) LVCProject *project;
@property (nonatomic, copy) void(^fileSelectedHandler)(LVCFile *file);
@end
