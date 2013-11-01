//
//  LVTAppDelegate.m
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 10/13/13.
//  Copyright (c) 2013 codecaffeine. All rights reserved.
//

#import "LVTAppDelegate.h"
#import "LVTHTTPClient.h"
#import "LVTUser.h"
#import "LVTOrganization.h"
#import "LVTProject.h"
#import "LVConstants.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Mantle/EXTScope.h>

@interface LVTAppDelegate () <NSTableViewDataSource, NSTableViewDelegate>
@property (nonatomic) LVTHTTPClient *client;
@property (weak) IBOutlet NSTextField *loggedInLabel;
@property (weak) IBOutlet NSTextField *emailField;
@property (weak) IBOutlet NSSecureTextField *passwordField;
@property (weak) IBOutlet NSButton *loginButton;
@property (weak) IBOutlet NSTableView *projectsTableView;
@property (weak) IBOutlet NSTableView *organizationsTableView;
@property (nonatomic) AFOAuthCredential *credential;
@property (nonatomic) LVTUser *user;
@end

@implementation LVTAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.client = [[LVTHTTPClient alloc] initWithClientID:LVClientID
                                                   secret:LVClientSecret];
    self.credential = [AFOAuthCredential retrieveCredentialWithIdentifier:self.client.serviceProviderIdentifier];

    @weakify(self);
    [RACObserve(self, credential) subscribeNext:^(AFOAuthCredential *credential) {
        @strongify(self);
        BOOL invalidCredential = !credential;
        self.emailField.enabled = invalidCredential;
        [self.emailField becomeFirstResponder];
        self.passwordField.enabled = invalidCredential;

        if (credential) {
            if (credential.expired) {
                [self.client authenticateUsingOAuthWithPath:@"/oauth/token"
                                               refreshToken:credential.refreshToken
                                                    success:^(AFOAuthCredential *refreshedCredential) {
                                                        @strongify(self);
                                                        self.credential = refreshedCredential;
                                                    }
                                                    failure:^(NSError *error) {
                                                        @strongify(self);
                                                        self.credential = nil;
                                                    }];

            }
            else {
                @weakify(self);
                [AFOAuthCredential storeCredential:credential
                                    withIdentifier:self.client.serviceProviderIdentifier];
                [self.client setAuthorizationHeaderWithCredential:credential];
                [self.client getMeWithBlock:^(LVTUser *user, NSError *error, AFHTTPRequestOperation *operation) {
                    @strongify(self);
                    self.user = user;
                    [self.organizationsTableView reloadData];
                    [self.projectsTableView reloadData];
                }];
            }
        }
        else {
            [AFOAuthCredential deleteCredentialWithIdentifier:self.client.serviceProviderIdentifier];
        }
    }];

    RACSignal *loginEnabledSignal =
    [RACSignal combineLatest:@[self.emailField.rac_textSignal, self.passwordField.rac_textSignal]
                      reduce:^(NSString *email, NSString *password){
                          return @(email.length > 0 && password.length > 0);
                      }];

    [loginEnabledSignal subscribeNext:^(NSNumber *enabled) {
        @strongify(self);
        [self.loginButton setEnabled:[enabled boolValue]];
    }];

    RAC(self, loggedInLabel.stringValue) = [RACObserve(self, user) map:^id(LVTUser *user) {
        return user.email ?: [NSNull null];
    }];
}

- (IBAction)loginPressed:(NSButton *)sender
{
    RAC(self, credential) = [self.client requestAuthorizationWithEmail:self.emailField.stringValue
                                                              password:self.passwordField.stringValue];
}


- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    NSInteger numberOfRows = 0;
    if (tableView == self.organizationsTableView) {
        numberOfRows = self.user.organizations.count;
    }
    else if (tableView == self.projectsTableView) {
        numberOfRows = self.user.projects.count;
    }
    return numberOfRows;
}


- (NSView *)tableView:(NSTableView *)tableView
   viewForTableColumn:(NSTableColumn *)tableColumn
                  row:(NSInteger)row
{
    NSTableCellView *cellView = nil;
    if ([tableColumn.identifier isEqualToString:@"Organizations"]) {
        LVTOrganization *org = self.user.organizations[row];
        cellView = [tableView makeViewWithIdentifier:@"OrganizationCell"
                                               owner:self];
        [cellView.textField setStringValue:org.name];
    }
    else if ([tableColumn.identifier isEqualToString:@"Projects"]) {
        cellView = [tableView makeViewWithIdentifier:@"ProjectCell"
                                               owner:self];
        LVTProject *project = self.user.projects[row];
        [cellView.textField setStringValue:project.name];
    }
    return cellView;
}


@end
