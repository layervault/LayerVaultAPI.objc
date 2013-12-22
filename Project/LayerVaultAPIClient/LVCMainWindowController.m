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
#import "LVCAuthController.h"
#import <LayerVaultAPI/LayerVaultAPI.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Mantle/EXTScope.h>

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
@property (readonly) LVCAuthController *authController;
@property (nonatomic) LVCHTTPClient *client;
@property (nonatomic) LVCUser *user;
@end

@implementation LVCMainWindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        _authController = [[LVCAuthController alloc] init];
        _client = _authController.client;

        _projectOutlineViewController = [[LVCProjectOutlineViewController alloc] initWithNibName:@"LVCProjectOutlineViewController" bundle:nil];
        _organizationsViewController = [[LVCOrganizationsViewController alloc] initWithNibName:@"LVCOrganizationsViewController" bundle:nil];

        _loginViewController = [[LVCLoginViewController alloc]
                                initWithNibName:@"LVCLoginViewController" bundle:nil];

        @weakify(self);
        _loginViewController.loginHander = ^(NSString *userName, NSString *password) {
            @strongify(self);
            [self.authController loginWithEmail:userName
                                       password:password
                                     completion:^(LVCUser *user,
                                                  LVCHTTPClient *client,
                                                  NSError *error) {
                                         self.user = user;
                                     }];
        };

        [RACObserve(_authController, user) subscribeNext:^(LVCUser *user) {
            self.user = user;
        }];

        [RACObserve(self, organizationsViewController.selectedProject) subscribeNext:^(LVCProject *project) {
            self.projectOutlineViewController.project = project;
        }];

        [RACObserve(self, user) subscribeNext:^(LVCUser *user) {
            self.organizationsViewController.organizations = user.organizations;
            if (user) {
                self.loggedInField.stringValue = user.email;
                [self placeUserViewController];
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
    projectView.frame = self.projectContainer.bounds;
    [self.projectContainer addSubview:projectView];

    [self placeLoginViewController];
}


#pragma mark - Actions
- (IBAction)logoutPressed:(id)sender {
    [self.authController logout];
}


#pragma mark - Private Methods
- (void)placeLoginViewController {
    if (self.loginViewController.view && self.detailViewContainer) {
        for (NSView *subview in self.detailViewContainer.subviews) {
            [subview removeFromSuperview];
        }
        NSView *loginView = self.loginViewController.view;
        NSView *superView = self.detailViewContainer;
        NSDictionary *views = NSDictionaryOfVariableBindings(loginView, superView);

        [superView addSubview:loginView];
        [self.window makeFirstResponder:self.loginViewController.emailField];
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
