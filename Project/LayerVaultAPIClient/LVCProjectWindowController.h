//
//  LVCProjectWindowController.h
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 12/5/13.
//  Copyright (c) 2013 codecaffeine. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class LVCProject;
@class LVCHTTPClient;

@interface LVCProjectWindowController : NSWindowController
@property (nonatomic) LVCProject *project;

- (instancetype)initWithClient:(LVCHTTPClient *)client;

@end
