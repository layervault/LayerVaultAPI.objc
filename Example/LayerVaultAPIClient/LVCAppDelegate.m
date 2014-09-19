//
//  LVCAppDelegate.m
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 10/13/13.
//  Copyright (c) 2013 LayerVault. All rights reserved.
//

#import "LVCAppDelegate.h"
#import "LVCMainWindowController.h"
#import "LVCTreeBuilder.h"


@interface LVCAppDelegate ()
@property (nonatomic) LVCMainWindowController *mainWindowController;
@property (nonatomic) LVCTreeBuilder *treeBuilder;
@end

@implementation LVCAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.treeBuilder = [[LVCTreeBuilder alloc] init];
//    self.mainWindowController = [[LVCMainWindowController alloc] initWithWindowNibName:@"LVCMainWindowController"];
//    [self.mainWindowController showWindow:nil];
//    [self.mainWindowController.window makeKeyAndOrderFront:self];
}

@end
