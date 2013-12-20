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
@property (strong) LVCOrganizationsViewController *organizationsViewController;
@property (strong) LVCProjectOutlineViewController *projectOutlineViewController;
@property (strong) LVCLoginViewController *loginViewController;
@property (strong) IBOutlet NSView *userView;
@property (weak) IBOutlet NSView *sourceViewContainer;
@property (weak) IBOutlet NSView *detailViewContainer;
@property (weak) IBOutlet NSView *projectContainer;
@property (weak) IBOutlet NSTextField *loggedInField;
@end

@implementation LVCMainWindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
        _projectOutlineViewController = [[LVCProjectOutlineViewController alloc] initWithNibName:@"LVCProjectOutlineViewController" bundle:nil];
        _organizationsViewController = [[LVCOrganizationsViewController alloc] initWithNibName:@"LVCOrganizationsViewController" bundle:nil];

        _loginViewController = [[LVCLoginViewController alloc]
                                initWithNibName:@"LVCLoginViewController" bundle:nil];

        [RACObserve(self, organizationsViewController.selectedProject) subscribeNext:^(LVCProject *project) {
            self.projectOutlineViewController.project = project;
            [self.projectContainer setHidden:!!project];
        }];

        [RACObserve(self, user) subscribeNext:^(LVCUser *user) {
            if (user) {
                self.loggedInField.stringValue = user.email;
                [self placeUserViewController];
                self.organizationsViewController.organizations = user.organizations;
            }
            else {
                [self placeLoginViewController];
            }
        }];
    }
    return self;
}


- (void)windowDidLoad
{
    [super windowDidLoad];

    // Place the organizations view controller in the source view container
    self.organizationsViewController.organizations = self.user.organizations;
    NSView *organizationsView = self.organizationsViewController.view;
    organizationsView.autoresizingMask = NSViewMinXMargin|NSViewWidthSizable|NSViewMaxXMargin|NSViewMinYMargin|NSViewHeightSizable|NSViewMaxYMargin;
    organizationsView.frame = self.sourceViewContainer.bounds;
    [self.sourceViewContainer addSubview:organizationsView];

    // Place the project view controller in the project container
    NSView *projectView = self.projectOutlineViewController.view;
    projectView.autoresizingMask = NSViewMinXMargin|NSViewWidthSizable|NSViewMaxXMargin|NSViewMinYMargin|NSViewHeightSizable|NSViewMaxYMargin;
    projectView.frame = self.detailViewContainer.bounds;
    [self.projectContainer addSubview:projectView];

    [self placeLoginViewController];
}


- (void)placeLoginViewController {
    if (self.loginViewController.view && self.detailViewContainer) {
        for (NSView *subview in self.detailViewContainer.subviews) {
            [subview removeFromSuperview];
        }
        NSView *loginView = self.loginViewController.view;
        NSView *superView = self.detailViewContainer;
        NSDictionary *views = NSDictionaryOfVariableBindings(loginView, superView);

        [superView addSubview:loginView];
        [self.window makeFirstResponder:self.loginViewController.usernameField];
        superView.translatesAutoresizingMaskIntoConstraints = NO;
        loginView.translatesAutoresizingMaskIntoConstraints = NO;
        [superView addConstraints:
         [NSLayoutConstraint constraintsWithVisualFormat:@"V:[superView]-(<=1)-[loginView(>=120.0)]"
                                                 options:NSLayoutFormatAlignAllCenterX
                                                 metrics:nil
                                                   views:views]];
        [superView addConstraints:
         [NSLayoutConstraint constraintsWithVisualFormat:@"H:[superView]-(<=1)-[loginView(>=240.0)]"
                                                 options:NSLayoutFormatAlignAllCenterY
                                                 metrics:nil
                                                   views:views]];
    }
}


- (void)placeUserViewController {
    if (self.userView && self.detailViewContainer) {
        for (NSView *subview in self.detailViewContainer.subviews) {
            [subview removeFromSuperview];
        }
        self.userView.autoresizingMask = NSViewMinXMargin|NSViewWidthSizable|NSViewMaxXMargin|NSViewMinYMargin|NSViewHeightSizable|NSViewMaxYMargin;
        self.userView.frame = self.detailViewContainer.bounds;
        [self.detailViewContainer addSubview:self.userView];
    }
}

@end
