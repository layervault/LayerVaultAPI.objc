//
//  LVTAppDelegate.m
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 10/13/13.
//  Copyright (c) 2013 codecaffeine. All rights reserved.
//

#import "LVTAppDelegate.h"
#import "LVConstants.h"
#import "LVTJSONWindowController.h"
#import <layervault_objc_client/LVTHTTPClient.h>
#import <layervault_objc_client/LVTUser.h>
#import <layervault_objc_client/LVTOrganization.h>
#import <layervault_objc_client/LVTProject.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Mantle/EXTScope.h>
#import <Mantle/Mantle.h>


NSString *const emailRegEx =
@"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
@"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
@"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
@"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
@"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
@"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
@"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";


@interface LVTAppDelegate () <NSTableViewDataSource, NSTableViewDelegate>
@property (weak) IBOutlet NSTextField *emailField;
@property (weak) IBOutlet NSSecureTextField *passwordField;
@property (weak) IBOutlet NSButton *loginButton;
@property (weak) IBOutlet NSTableView *projectsTableView;
@property (weak) IBOutlet NSTableView *organizationsTableView;

@property (nonatomic) LVTHTTPClient *client;
@property (nonatomic) AFOAuthCredential *credential;
@property (nonatomic) LVTUser *user;

@property (nonatomic) LVTJSONWindowController *jsonWindowController;
@end

@implementation LVTAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.client = [[LVTHTTPClient alloc] initWithClientID:LVClientID
                                                   secret:LVClientSecret];
    self.credential = [AFOAuthCredential retrieveCredentialWithIdentifier:self.client.serviceProviderIdentifier];

    [self.projectsTableView setTarget:self];
    [self.projectsTableView setDoubleAction:@selector(doubleClickedTable:)];
    [self.organizationsTableView setTarget:self];
    [self.organizationsTableView setDoubleAction:@selector(doubleClickedTable:)];


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
                    if (!user) {
                        self.credential = nil;
                    }
                }];
            }
        }
        else {
            self.user = nil;
            [AFOAuthCredential deleteCredentialWithIdentifier:self.client.serviceProviderIdentifier];
        }
    } error:^(NSError *error) {
        NSLog(@"error: %@", error);
    } completed:^{
        NSLog(@"completed");
    }];

    RACSignal *loginEnabledSignal =
    [RACSignal
     combineLatest:@[RACObserve(self, credential),
                     self.emailField.rac_textSignal,
                     self.passwordField.rac_textSignal]
     reduce:^(AFOAuthCredential *credential,
              NSString *email,
              NSString *password){
         BOOL validEmail = [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx] evaluateWithObject:email];
         return @(credential || (!credential && validEmail && password.length > 0));
     }];

    [loginEnabledSignal subscribeNext:^(NSNumber *enabled) {
        @strongify(self);
        [self.loginButton setEnabled:[enabled boolValue]];
    }];

    RAC(self, loginButton.title) = [RACObserve(self, credential)
                                          map:^NSString *(AFOAuthCredential *credential) {
                                              return credential ? @"Logout" : @"Login";
                                          }];

    RAC(self, emailField.stringValue) = [RACObserve(self, user)
                                         map:^NSString *(LVTUser *user) {
                                             return user.email ?: @"";
                                         }];

    RAC(self, passwordField.stringValue) = [RACObserve(self, credential)
                                            map:^NSString *(AFOAuthCredential *credential) {
                                                return credential ? @"••••••••" : @"";
                                            }];

    [RACObserve(self, user) subscribeNext:^(LVTUser *user) {
        [self.organizationsTableView reloadData];
        [self.projectsTableView reloadData];
    }];
}

- (IBAction)loginPressed:(NSButton *)sender
{
    if (self.credential) { // Button was "logout"
        self.credential = nil;
    }
    else {
        [self.client authenticateWithEmail:self.emailField.stringValue
                                  password:self.passwordField.stringValue
                                completion:^(AFOAuthCredential *credential, NSError *error) {
                                    self.credential = credential;
                                    if (error) {
                                        NSLog(@"error: %@", error);
                                    }
                                }];
    }
}


- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return [self dataSourceForTableView:tableView].count;
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


- (NSArray *)dataSourceForTableView:(NSTableView *)tableView
{
    NSArray *dataSource = nil;
    if (tableView == self.organizationsTableView) {
        dataSource = self.user.organizations;
    }
    else if (tableView == self.projectsTableView) {
        dataSource = self.user.projects;
    }
    return dataSource;
}

- (void)doubleClickedTable:(NSTableView *)tableView
{
    NSArray *dataSource = [self dataSourceForTableView:tableView];
    id selectedObject = [dataSource objectAtIndex:tableView.selectedRow];
    if ([selectedObject conformsToProtocol:@protocol(MTLJSONSerializing)] && [selectedObject isKindOfClass:[MTLModel class]]) {
        MTLModel<MTLJSONSerializing> *jsonObject = (MTLModel<MTLJSONSerializing> *)selectedObject;

        if (!self.jsonWindowController) {
            self.jsonWindowController = [[LVTJSONWindowController alloc] initWithWindowNibName:@"LVTJSONWindowController"];
        }
        self.jsonWindowController.json = [MTLJSONAdapter JSONDictionaryFromModel:jsonObject];
        [self.jsonWindowController showWindow:nil];
    }
}

@end
