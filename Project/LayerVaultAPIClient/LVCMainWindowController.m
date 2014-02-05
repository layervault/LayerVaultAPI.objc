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
#import "LVConstants.h"
#import "LVCFileRevisionsWindowController.h"
#import <LayerVaultAPI/LayerVaultAPI.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Mantle/EXTScope.h>
#import <QuartzCore/QuartzCore.h>
#import <AFOAuth2Client/AFOAuth2Client.h>

static void *LVCMainWindowControllerContext = &LVCMainWindowControllerContext;

@interface LVCMainWindowController () <NSOutlineViewDataSource, NSOutlineViewDelegate>
@property (strong) LVCOrganizationsViewController *organizationsViewController;
@property (strong) LVCProjectOutlineViewController *projectOutlineViewController;
@property (strong) LVCLoginViewController *loginViewController;
@property (strong) IBOutlet NSSplitView *userSplitView;
@property (weak) IBOutlet NSView *contentView;
@property (weak) IBOutlet NSView *sourceViewContainer;
@property (weak) IBOutlet NSView *projectContainer;
@property (weak) IBOutlet NSTextField *loggedInField;
@property (nonatomic) LVCAuthenticatedClient *client;
@property (nonatomic) LVCFileRevisionsWindowController *fileRevisionWindow;
@end

@implementation LVCMainWindowController

- (instancetype)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        _client = [[LVCAuthenticatedClient alloc] initWithClientID:LVClientID
                                                            secret:LVClientSecret];
        AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:_client.serviceProviderIdentifier];
        if (credential) {
            [_client loginWithCredential:credential];
        }

        NSString *identifier = _client.serviceProviderIdentifier;
        [RACObserve(_client, credential) subscribeNext:^(AFOAuthCredential *newCredential) {
            if (newCredential) {
                [AFOAuthCredential storeCredential:newCredential
                                    withIdentifier:identifier];
            }
            else {
                [AFOAuthCredential deleteCredentialWithIdentifier:identifier];
            }
        }];

        _fileRevisionWindow = [[LVCFileRevisionsWindowController alloc] initWithWindowNibName:@"LVCFileRevisionsWindowController"];
        _fileRevisionWindow.client = _client;

        _projectOutlineViewController = [[LVCProjectOutlineViewController alloc] initWithNibName:@"LVCProjectOutlineViewController" bundle:nil];
        @weakify(self);
        _projectOutlineViewController.fileSelectedHandler = ^(LVCFile *file) {
            @strongify(self);
            [self.fileRevisionWindow showWindow:nil];
            self.fileRevisionWindow.file = file;
        };

        _organizationsViewController = [[LVCOrganizationsViewController alloc] initWithNibName:@"LVCOrganizationsViewController" bundle:nil];

        _loginViewController = [[LVCLoginViewController alloc]
                                initWithNibName:@"LVCLoginViewController" bundle:nil];

        _loginViewController.loginHander = ^(NSString *userName, NSString *password) {
            @strongify(self);
            [self.client loginWithEmail:userName password:password];
        };
    }
    return self;
}


- (void)windowDidLoad
{
    [super windowDidLoad];

    self.contentView.wantsLayer = YES;

    // Place the organizations view controller in the source view container
    self.organizationsViewController.organizations = self.client.user.organizations;
    NSView *organizationsView = self.organizationsViewController.view;
    organizationsView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.sourceViewContainer addSubview:organizationsView];
    [self.sourceViewContainer addConstraints:[NSLayoutConstraint
                                              constraintsWithVisualFormat:@"H:|-0-[organizationsView]-0-|"
                                              options:NSLayoutFormatDirectionLeadingToTrailing
                                              metrics:nil
                                              views:NSDictionaryOfVariableBindings(organizationsView)]];
    [self.sourceViewContainer addConstraints:[NSLayoutConstraint
                                              constraintsWithVisualFormat:@"V:|-0-[organizationsView]-0-|"
                                              options:NSLayoutFormatDirectionLeadingToTrailing
                                              metrics:nil
                                              views:NSDictionaryOfVariableBindings(organizationsView)]];


    // Place the project view controller in the project container
    NSView *projectView = self.projectOutlineViewController.view;
    projectView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.projectContainer addSubview:projectView];
    [self.projectContainer addConstraints:[NSLayoutConstraint
                                           constraintsWithVisualFormat:@"H:|-0-[projectView]-0-|"
                                           options:NSLayoutFormatDirectionLeadingToTrailing
                                           metrics:nil
                                           views:NSDictionaryOfVariableBindings(projectView)]];
    [self.projectContainer addConstraints:[NSLayoutConstraint
                                           constraintsWithVisualFormat:@"V:|-0-[projectView]-0-|"
                                           options:NSLayoutFormatDirectionLeadingToTrailing
                                           metrics:nil
                                           views:NSDictionaryOfVariableBindings(projectView)]];


    // Setup Transition
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionFade;
    self.contentView.animations = @{@"subviews": transition};

    [RACObserve(self, organizationsViewController.selectedProject) subscribeNext:^(LVCProject *project) {
        if (project) {
            [self.client getProjectFromPartial:project
                                    completion:^(LVCProject *fullProject,
                                                 NSError *error,
                                                 AFHTTPRequestOperation *operation) {
                                        self.projectOutlineViewController.project = fullProject;
                                    }];
        }
    }];

    [RACObserve(self.client, user) subscribeNext:^(LVCUser *user) {
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


#pragma mark - Actions
- (IBAction)logoutPressed:(id)sender {
    [self.client logout];
}


#pragma mark - Private Methods
- (void)placeLoginViewController {
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        [self.contentView.animator replaceSubview:self.userSplitView
                                             with:self.loginViewController.view];
    } completionHandler:^{
        [self.window makeFirstResponder:self.loginViewController.emailField];
    }];

    for (NSView *subview in self.contentView.subviews) {
        [subview removeFromSuperview];
    }
    NSView *loginView = self.loginViewController.view;
    loginView.translatesAutoresizingMaskIntoConstraints = NO;
    NSView *superView = self.contentView;
    NSDictionary *views = NSDictionaryOfVariableBindings(loginView, superView);

    [superView addSubview:loginView];
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


- (void)placeUserViewController {
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        [self.contentView.animator replaceSubview:self.loginViewController.view
                                             with:self.userSplitView];
    } completionHandler:^{
        [self.window makeFirstResponder:self.organizationsViewController.outlineView];
        NSUInteger row = 1;
        id itemAtRow = [self.organizationsViewController.outlineView itemAtRow:(NSInteger)row];
        if ([itemAtRow isKindOfClass:LVCProject.class]) {
            [self.organizationsViewController.outlineView selectRowIndexes:[NSIndexSet indexSetWithIndex:row]
                                                      byExtendingSelection:NO];
        }
    }];


    for (NSView *subview in self.contentView.subviews) {
        [subview removeFromSuperview];
    }
    self.userSplitView.autoresizingMask = NSViewMinXMargin|NSViewWidthSizable|NSViewMaxXMargin|NSViewMinYMargin|NSViewHeightSizable|NSViewMaxYMargin;
    self.userSplitView.frame = self.contentView.bounds;
    [self.contentView addSubview:self.userSplitView];
}

@end
