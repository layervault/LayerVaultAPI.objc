//
//  LVCFileRevisionsWindowController.h
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 12/23/13.
//  Copyright (c) 2013 LayerVault. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class LVCFile;
@class LVCHTTPClient;

@interface LVCFileRevisionsWindowController : NSWindowController
@property (nonatomic) LVCFile *file;
@property (nonatomic) LVCHTTPClient *client;
@property (readonly, copy) NSArray *revisions;

@end
