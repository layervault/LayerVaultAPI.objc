//
//  LVCMainWindowController.m
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 12/14/13.
//  Copyright (c) 2013 LayerVault. All rights reserved.
//

#import "LVCMainWindowController.h"
#import "LVCOrganizationsViewController.h"
#import "LVCProjectOutlineViewController.h"
#import <LayerVaultAPI/LayerVaultAPI.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

static void *LVCMainWindowControllerContext = &LVCMainWindowControllerContext;

@interface LVCMainWindowController () <NSOutlineViewDataSource, NSOutlineViewDelegate>
@property (strong) IBOutlet LVCOrganizationsViewController *organizationsViewController;
@property (strong) LVCProjectOutlineViewController *projectOutlineViewController;
@property (weak) IBOutlet NSView *sourceViewContainer;
@property (weak) IBOutlet NSView *detailViewContainer;
@end

@implementation LVCMainWindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
        _projectOutlineViewController = [[LVCProjectOutlineViewController alloc] initWithNibName:@"LVCProjectOutlineViewController" bundle:nil];

        [RACObserve(self, organizationsViewController.selectedProject) subscribeNext:^(LVCProject *project) {
            self.projectOutlineViewController.project = project;
        }];

    }
    return self;
}


- (void)dealloc
{
    [_projectOutlineViewController removeObserver:self
                                       forKeyPath:@"selectedProject"];
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    self.organizationsViewController.organizations = self.user.organizations;
    NSView *organizationsView = self.organizationsViewController.view;
    organizationsView.autoresizingMask = NSViewMinXMargin|NSViewWidthSizable|NSViewMaxXMargin|NSViewMinYMargin|NSViewHeightSizable|NSViewMaxYMargin;
    organizationsView.frame = self.sourceViewContainer.bounds;
    [self.sourceViewContainer addSubview:organizationsView];

    NSView *projectView = self.projectOutlineViewController.view;
    projectView.autoresizingMask = NSViewMinXMargin|NSViewWidthSizable|NSViewMaxXMargin|NSViewMinYMargin|NSViewHeightSizable|NSViewMaxYMargin;
    projectView.frame = self.detailViewContainer.bounds;
    [self.detailViewContainer addSubview:projectView];
}

@end
