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
#import "LVCLoginViewController.h"
#import <LayerVaultAPI/LayerVaultAPI.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

static void *LVCMainWindowControllerContext = &LVCMainWindowControllerContext;

@interface LVCMainWindowController () <NSOutlineViewDataSource, NSOutlineViewDelegate>
@property (strong) IBOutlet LVCOrganizationsViewController *organizationsViewController;
@property (strong) LVCProjectOutlineViewController *projectOutlineViewController;
@property (strong) LVCLoginViewController *loginViewController;
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

        _loginViewController = [[LVCLoginViewController alloc]
                                initWithNibName:@"LVCLoginViewController" bundle:nil];

        [RACObserve(self, organizationsViewController.selectedProject) subscribeNext:^(LVCProject *project) {
            self.projectOutlineViewController.project = project;
        }];

    }
    return self;
}


- (void)windowDidLoad
{
    [super windowDidLoad];
    
    self.organizationsViewController.organizations = self.user.organizations;
    NSView *organizationsView = self.organizationsViewController.view;
    organizationsView.autoresizingMask = NSViewMinXMargin|NSViewWidthSizable|NSViewMaxXMargin|NSViewMinYMargin|NSViewHeightSizable|NSViewMaxYMargin;
    organizationsView.frame = self.sourceViewContainer.bounds;
    [self.sourceViewContainer addSubview:organizationsView];

    [self placeLoginViewController];
}


- (void)placeLoginViewController {
    for (NSView *subview in self.detailViewContainer.subviews) {
        [subview removeFromSuperview];
    }
    NSView *loginView = self.loginViewController.view;
    NSView *superView = self.detailViewContainer;
    loginView.autoresizingMask = NSViewMinXMargin|NSViewMaxXMargin|NSViewMinYMargin|NSViewMaxYMargin;

    [self.detailViewContainer addSubview:loginView];
//    [superView addConstraints:
//     [NSLayoutConstraint constraintsWithVisualFormat:@"V:[superView]-(<=1)-[loginView]"
//                                             options:NSLayoutFormatAlignAllCenterX
//                                             metrics:nil
//                                               views:views]];
//    [superView addConstraints:
//     [NSLayoutConstraint constraintsWithVisualFormat:@"H:[superView]-(<=1)-[loginView]"
//                                             options:NSLayoutFormatAlignAllCenterY
//                                             metrics:nil
//                                               views:views]];
}


- (void)placeProjectViewController {
    for (NSView *subview in self.detailViewContainer.subviews) {
        [subview removeFromSuperview];
    }
    NSView *projectView = self.projectOutlineViewController.view;
    projectView.autoresizingMask = NSViewMinXMargin|NSViewWidthSizable|NSViewMaxXMargin|NSViewMinYMargin|NSViewHeightSizable|NSViewMaxYMargin;
    projectView.frame = self.detailViewContainer.bounds;
    [self.detailViewContainer addSubview:projectView];
}

@end
