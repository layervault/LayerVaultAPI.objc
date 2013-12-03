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
#import <layervault_objc_client/LayerVaultAPI.h>
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


@interface LVTAppDelegate () <NSTableViewDataSource, NSTableViewDelegate, NSTextFieldDelegate>
@property (weak) IBOutlet NSTextField *emailField;
@property (weak) IBOutlet NSSecureTextField *passwordField;
@property (weak) IBOutlet NSButton *loginButton;
@property (weak) IBOutlet NSTableView *projectsTableView;
@property (nonatomic, copy) NSArray *dataSource;

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
        @strongify(self);
        [self setDataSourceForUser:user];
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

- (IBAction)addProjectPressed:(NSButton *)sender
{
    NSInteger row = [self.projectsTableView rowForView:sender];
    id selectedObject = [self.dataSource objectAtIndex:row];
    if ([selectedObject isKindOfClass:LVTOrganization.class]) {
        LVTOrganization *org = (LVTOrganization *)selectedObject;
        LVTProject *project = [[LVTProject alloc] initWithName:@""
                                         organizationPermalink:org.permalink];
        NSMutableArray *newDataSource = self.dataSource.mutableCopy;
        NSInteger orgProject = [newDataSource indexOfObject:org];
        NSInteger newPos = (orgProject + 1);
        [newDataSource insertObject:project atIndex:(orgProject + 1)];
        self.dataSource = newDataSource;
        [self.projectsTableView insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:newPos]
                                      withAnimation:NSTableViewAnimationEffectNone];
    }
}


- (IBAction)deleteProjectPressed:(NSButton *)sender
{
    NSInteger row = [self.projectsTableView rowForView:sender];
    id selectedObject = [self.dataSource objectAtIndex:row];
    if ([selectedObject isKindOfClass:LVTProject.class]) {
        LVTProject *project = (LVTProject *)selectedObject;
        [self.client deleteProject:project
                        completion:^(BOOL success,
                                     NSError *error,
                                     AFHTTPRequestOperation *operation) {
                            NSLog(@"DELETE Success: %@", success ? @"YES" : @"NO");
                            NSLog(@"error: %@", error);
                            NSLog(@"operation: %@", operation);
                        }];
    }
}

- (void)setDataSourceForUser:(LVTUser *)user
{
    NSMutableArray *dataSource = @[].mutableCopy;
    for (LVTOrganization *org in user.organizations) {
        [dataSource addObject:org];
        for (LVTProject *project in org.projects) {
            [dataSource addObject:project];
        }
    }
    self.dataSource = dataSource;
    [self.projectsTableView reloadData];
}


#pragma mark - NSTextFieldDelegate
- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor
{
    NSLog(@"control:%@ textShouldEndEditing:%@", control, fieldEditor);
    NSInteger row = [self.projectsTableView rowForView:control];
    id selectedObject = [self.dataSource objectAtIndex:row];
    if ([selectedObject isKindOfClass:LVTProject.class]) {
        LVTProject *project = (LVTProject *)selectedObject;
        if (!project.synced) {
            [self.client createProjectWithName:fieldEditor.string
                         organizationPermalink:project.organizationPermalink
                                    completion:^(LVTProject *project,
                                                 NSError *error,
                                                 AFHTTPRequestOperation *operation) {
                                        NSLog(@"project: %@", project);
                                        NSLog(@"error: %@", error);
                                        NSLog(@"operation: %@", operation);
                                    }];
        }
        else {
            if (![fieldEditor.string isEqualToString:project.name]) {
                NSLog(@"Needs Rename '%@' \u2192 '%@'",
                      project.name,
                      fieldEditor.string);
                [self.client moveProject:(LVTProject *)project
                           toDestination:fieldEditor.string
                              completion:^(LVTProject *project,
                                           NSError *error,
                                           AFHTTPRequestOperation *operation) {
                                  NSLog(@"project: %@", project);
                                  NSLog(@"error: %@", error);
                                  NSLog(@"operation: %@", operation);
                              }];
            }
        }
    }
    return YES;
}


#pragma mark - NSTableViewDataSource
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return self.dataSource.count;
}


#pragma mark - NSTableViewDelegate
- (void)tableView:(NSTableView *)tableView didAddRowView:(NSTableRowView *)rowView forRow:(NSInteger)row
{
    id selectedObject = [self.dataSource objectAtIndex:row];
    if ([selectedObject isKindOfClass:LVTProject.class]) {
        LVTProject *project = (LVTProject *)selectedObject;
        if (!project.synced) {
            [tableView editColumn:0 row:row withEvent:nil select:YES];
        }
    }
}


- (NSView *)tableView:(NSTableView *)tableView
   viewForTableColumn:(NSTableColumn *)tableColumn
                  row:(NSInteger)row
{
    id selectedObject = [self.dataSource objectAtIndex:row];

    if ([selectedObject isKindOfClass:LVTOrganization.class]) {
        LVTOrganization *org = (LVTOrganization *)selectedObject;
        NSTableCellView *orgCell = [tableView makeViewWithIdentifier:@"OrganizationCell"
                                                               owner:self];
        [orgCell.textField setStringValue:org.name];
        return orgCell;
    }
    else if ([selectedObject isKindOfClass:LVTProject.class]) {
        LVTProject *project = (LVTProject *)selectedObject;
        NSTableCellView *tableCell = [tableView makeViewWithIdentifier:@"ProjectCell"
                                                                 owner:self];
        if (project.synced) {
            [tableCell.textField setStringValue:project.name];
            NSButton *button = [tableCell viewWithTag:32];
            [button.cell setBackgroundColor:[LVTColorUtils colorForLabel:project.colorLabel]];
        }
        return tableCell;
    }
    return nil;
}


- (BOOL)tableView:(NSTableView *)tableView isGroupRow:(NSInteger)row
{
    id selectedObject = [self.dataSource objectAtIndex:row];
    if ([selectedObject isKindOfClass:LVTOrganization.class]) {
        return YES;
    }
    return NO;
}


- (void)doubleClickedTable:(NSTableView *)tableView
{
    if (!self.jsonWindowController) {
        self.jsonWindowController = [[LVTJSONWindowController alloc] initWithWindowNibName:@"LVTJSONWindowController"];
    }

    NSInteger row = tableView.selectedRow;
    id selectedObject = [self.dataSource objectAtIndex:row];
    if ([selectedObject isKindOfClass:LVTOrganization.class]) {
        LVTOrganization *organization = (LVTOrganization *)selectedObject;
        self.jsonWindowController.model = organization;
    }
    else if ([selectedObject isKindOfClass:LVTProject.class]) {
        LVTProject *project = (LVTProject *)selectedObject;
        if (project.partial) {
            @weakify(self);
            [self.client getProjectFromPartial:project
                                    completion:^(LVTProject *project,
                                                 NSError *error,
                                                 AFHTTPRequestOperation *operation) {
                                        @strongify(self);
                                        NSMutableArray *a = self.dataSource.mutableCopy;
                                        [a replaceObjectAtIndex:row withObject:project];
                                        self.dataSource = a;
                                        self.jsonWindowController.model = project;
                                    }];
        }
        else {
            self.jsonWindowController.model = project;
        }
    }

    [self.jsonWindowController showWindow:nil];
}

@end
