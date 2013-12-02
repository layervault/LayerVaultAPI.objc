//
//  LVTJSONWindowController.h
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 11/1/13.
//  Copyright (c) 2013 codecaffeine. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Mantle/Mantle.h>

@interface LVTJSONWindowController : NSWindowController <NSTableViewDelegate, NSTableViewDataSource, NSOutlineViewDataSource>

@property (nonatomic, copy) NSDictionary *json;
@property (nonatomic) MTLModel<MTLJSONSerializing> *model;

@end
