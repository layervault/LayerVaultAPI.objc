//
//  LVTProjectWindowController.h
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 12/5/13.
//  Copyright (c) 2013 codecaffeine. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class LVTProject;

@interface LVTProjectWindowController : NSWindowController
@property (nonatomic) LVTProject *project;
@end
