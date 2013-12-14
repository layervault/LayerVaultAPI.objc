//
//  LVCAppDelegate.m
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 10/13/13.
//  Copyright (c) 2013 codecaffeine. All rights reserved.
//

#import "LVCAppDelegate.h"
#import "LVConstants.h"
#import "LVCProjectWindowController.h"
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


@interface LVCAppDelegate () <NSTableViewDataSource, NSTableViewDelegate>
@property (weak) IBOutlet NSTextField *emailField;
@property (weak) IBOutlet NSSecureTextField *passwordField;
@property (weak) IBOutlet NSButton *loginButton;
@property (weak) IBOutlet NSTableView *projectsTableView;
@property (nonatomic, copy) NSArray *dataSource;

@property (nonatomic) LVCHTTPClient *client;
@property (nonatomic) AFOAuthCredential *credential;
@property (nonatomic) LVCUser *user;

@property (nonatomic) LVCProjectWindowController *projectWindowController;
@end

@implementation LVCAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.client = [[LVCHTTPClient alloc] initWithClientID:LVClientID
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
                [self.client getMeWithBlock:^(LVCUser *user, NSError *error, AFHTTPRequestOperation *operation) {
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
                                         map:^NSString *(LVCUser *user) {
                                             return user.email ?: @"";
                                         }];

    RAC(self, passwordField.stringValue) = [RACObserve(self, credential)
                                            map:^NSString *(AFOAuthCredential *credential) {
                                                return credential ? @"••••••••" : @"";
                                            }];

    [RACObserve(self, user) subscribeNext:^(LVCUser *user) {
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
                                completion:^(AFOAuthCredential *credential,
                                             NSError *error) {
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
    if ([selectedObject isKindOfClass:LVCOrganization.class]) {
        LVCOrganization *org = (LVCOrganization *)selectedObject;
        LVCProject *project = [[LVCProject alloc] initWithName:@""
                                         organizationPermalink:org.permalink];
        [self insertDataSourceObject:project
                               inRow:([self.dataSource indexOfObject:org] + 1)];
    }
}


- (IBAction)deleteProjectPressed:(NSButton *)sender
{
    NSInteger row = [self.projectsTableView rowForView:sender];
    id selectedObject = [self.dataSource objectAtIndex:row];
    if ([selectedObject isKindOfClass:LVCProject.class]) {
        LVCProject *project = (LVCProject *)selectedObject;
        [self.client deleteProject:project
                        completion:^(BOOL success,
                                     NSError *error,
                                     AFHTTPRequestOperation *operation) {
                            if (success) {
                                [self deleteDataSourceObjectInRow:row];
                            }
                        }];
    }
}

- (IBAction)changeColorPressed:(NSButton *)sender
{
    NSInteger row = [self.projectsTableView rowForView:sender];
    id selectedObject = [self.dataSource objectAtIndex:row];
    if ([selectedObject isKindOfClass:LVCProject.class]) {
        LVCProject *project = (LVCProject *)selectedObject;
        LVCColorLabel newLabel = LVCColorWhite;
        switch (project.colorLabel) {
            case LVCColorWhite:
                newLabel = LVCColorGreen;
                break;
            case LVCColorGreen:
                newLabel = LVCColorRed;
                break;
            case LVCColorRed:
                newLabel = LVCColorOrange;
                break;
            case LVCColorOrange:
                newLabel = LVCColorWhite;
                break;
        }

        [self.client updateProject:project
                        colorLabel:newLabel
                        completion:^(BOOL success,
                                     NSError *error,
                                     AFHTTPRequestOperation *operation) {
                            if (success) {
                                [self.projectsTableView reloadDataForRowIndexes:[NSIndexSet indexSetWithIndex:row]
                                                                  columnIndexes:[NSIndexSet indexSetWithIndex:0]];
                            }
                        }];
    }
}


- (IBAction)textFieldTitleChanged:(NSTextField *)textField
{
    NSInteger row = [self.projectsTableView rowForView:textField];
    id selectedObject = [self.dataSource objectAtIndex:row];
    if ([selectedObject isKindOfClass:LVCProject.class]) {
        LVCProject *project = (LVCProject *)selectedObject;

        void (^completion)(LVCProject *, NSError *, AFHTTPRequestOperation *) =
        ^(LVCProject *project,
          NSError *error,
          AFHTTPRequestOperation *operation) {
            if (project) {
                [self updateDataSourceObject:project
                                       inRow:row];
            }
            else {
                NSLog(@"error: %@", error);
            }
        };

        if (!project.synced) {
            [self.client createProjectWithName:textField.stringValue
                         organizationPermalink:project.organizationPermalink
                                    completion:completion];
        }
        else {
            if (![textField.stringValue isEqualToString:project.name]) {
                [self.client moveProject:(LVCProject *)project
                           toDestination:textField.stringValue
                              completion:completion];
            }
        }
    }
}


- (void)reloadDataSource
{
    [self setDataSourceForUser:self.user];
}


- (void)setDataSourceForUser:(LVCUser *)user
{
    NSMutableArray *dataSource = @[].mutableCopy;
    for (LVCOrganization *org in user.organizations) {
        [dataSource addObject:org];
        NSArray *sortedProjects = [org.projects sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"dateUpdated" ascending:NO]]];
        for (LVCProject *currentProject in sortedProjects) {
            if (currentProject.member) {
                if (currentProject.partial) {
                    [self.client getProjectFromPartial:currentProject
                                            completion:^(LVCProject *project,
                                                         NSError *error,
                                                         AFHTTPRequestOperation *operation) {
                                                [currentProject mergeValuesForKeysFromModel:project];
                                                [self reloadDataSource];
                    }];
                }
                else {
                    [dataSource addObject:currentProject];
                }
            }
        }
    }
    self.dataSource = dataSource;
    [self.projectsTableView reloadData];
}


- (void)insertDataSourceObject:(id)object inRow:(NSUInteger)row
{
    NSMutableArray *newDataSource = self.dataSource.mutableCopy;
    [newDataSource insertObject:object atIndex:row];
    self.dataSource = newDataSource;
    [self.projectsTableView insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:row]
                                  withAnimation:NSTableViewAnimationEffectNone];
}


- (void)deleteDataSourceObjectInRow:(NSUInteger)row
{
    NSMutableArray *newDataSource = self.dataSource.mutableCopy;
    [newDataSource removeObjectAtIndex:row];
    self.dataSource = newDataSource;
    [self.projectsTableView removeRowsAtIndexes:[NSIndexSet indexSetWithIndex:row]
                                  withAnimation:NSTableViewAnimationSlideUp];
}


- (void)updateDataSourceObject:(id)object inRow:(NSUInteger)row
{
    NSMutableArray *newDataSource = self.dataSource.mutableCopy;
    [newDataSource replaceObjectAtIndex:row withObject:object];
    self.dataSource = newDataSource;
    [self.projectsTableView reloadDataForRowIndexes:[NSIndexSet indexSetWithIndex:row]
                                      columnIndexes:[NSIndexSet indexSetWithIndex:0]];

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
    if ([selectedObject isKindOfClass:LVCProject.class]) {
        LVCProject *project = (LVCProject *)selectedObject;
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

    if ([selectedObject isKindOfClass:LVCOrganization.class]) {
        LVCOrganization *org = (LVCOrganization *)selectedObject;
        NSTableCellView *orgCell = [tableView makeViewWithIdentifier:@"OrganizationCell"
                                                               owner:self];
        [orgCell.textField setStringValue:org.name];
        return orgCell;
    }
    else if ([selectedObject isKindOfClass:LVCProject.class]) {
        LVCProject *project = (LVCProject *)selectedObject;
        NSTableCellView *tableCell = [tableView makeViewWithIdentifier:@"ProjectCell"
                                                                 owner:self];
        if (project.synced) {
            [tableCell.textField setStringValue:project.name];
            NSButton *button = [tableCell viewWithTag:32];
            [button.cell setBackgroundColor:[LVCColorUtils colorForLabel:project.colorLabel]];
        }
        return tableCell;
    }
    return nil;
}


- (BOOL)tableView:(NSTableView *)tableView isGroupRow:(NSInteger)row
{
    id selectedObject = [self.dataSource objectAtIndex:row];
    if ([selectedObject isKindOfClass:LVCOrganization.class]) {
        return YES;
    }
    return NO;
}


- (void)doubleClickedTable:(NSTableView *)tableView
{
    NSInteger row = tableView.selectedRow;
    id selectedObject = [self.dataSource objectAtIndex:row];
    if ([selectedObject isKindOfClass:LVCProject.class]) {

        if (!self.projectWindowController) {
            self.projectWindowController = [[LVCProjectWindowController alloc] initWithClient:self.client];
        }

        [self.projectWindowController showWindow:nil];

        LVCProject *project = (LVCProject *)selectedObject;
        if (project.partial) {
            @weakify(self);
            [self.client getProjectFromPartial:project
                                    completion:^(LVCProject *project,
                                                 NSError *error,
                                                 AFHTTPRequestOperation *operation) {
                                        @strongify(self);
                                        self.projectWindowController.project = project;
                                    }];
        }
        else {
            self.projectWindowController.project = project;
        }
    }
}

@end
