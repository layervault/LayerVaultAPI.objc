//
//  LVTJSONWindowController.h
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 11/1/13.
//  Copyright (c) 2013 codecaffeine. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface LVTJSONWindowController : NSWindowController <NSTableViewDelegate, NSTableViewDataSource>

@property (nonatomic, copy) NSDictionary *json;

@end
