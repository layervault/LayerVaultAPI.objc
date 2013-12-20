//
//  LVCLoginViewController.h
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 12/20/13.
//  Copyright (c) 2013 LayerVault. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface LVCLoginViewController : NSViewController

@property (weak) IBOutlet NSTextField *usernameField;
@property (nonatomic, copy) void (^loginHander)(NSString *userName, NSString *password);

@end
