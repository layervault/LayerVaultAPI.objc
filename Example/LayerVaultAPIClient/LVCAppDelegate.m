//
//  LVCAppDelegate.m
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 10/13/13.
//  Copyright (c) 2013 LayerVault. All rights reserved.
//

#import "LVCAppDelegate.h"
#import <LayerVaultAPI/LayerVaultAPI.h>
#import <SSKeychain/SSKeychain.h>
#import "LVConstants.h"
#import "LVCMainWindowController.h"
#import "LVCTreeBuilder.h"


@interface LVCAppDelegate ()
@property (nonatomic) LVCHTTPClient *client;
@property (nonatomic) LVCMainWindowController *mainWindowController;
@property (nonatomic) LVCTreeBuilder *treeBuilder;
@end

@implementation LVCAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSString *keychainService = @"LayerVaultAPIDemoApp";
#warning beta!
    NSURL *url = [NSURL URLWithString:@"https://beta.layervault.com/api/v2/"];
    self.client = [[LVCAuthenticatedClient alloc] initWithBaseURL:url
                                                         clientID:LVClientID
                                                           secret:LVClientSecret];

    NSString *accountEmail = nil;
    NSString *accountPassword = nil;
    NSArray *accounts = [SSKeychain accountsForService:keychainService];
    if (accounts.count > 0) {
        accountEmail = accounts[0][kSSKeychainAccountKey];
        accountPassword = [SSKeychain passwordForService:keychainService
                                                 account:accountEmail];
        __weak typeof(self) weakSelf = self;
        [_client authenticateWithEmail:accountEmail password:accountPassword completion:^(AFOAuthCredential *credential, NSError *error) {
            if (credential) {
                weakSelf.treeBuilder = [[LVCTreeBuilder alloc] initWithAuthenticationCredential:credential];
                [weakSelf.treeBuilder buildUserTreeWithCompletion:^(LVCUser *user, NSError *buildTreeError) {
                    NSLog(@"userTree: %@", user);
                    NSLog(@"error: %@", buildTreeError);
                }];
            }
        }];
    }

//    self.mainWindowController = [[LVCMainWindowController alloc] initWithWindowNibName:@"LVCMainWindowController"];
//    [self.mainWindowController showWindow:nil];
//    [self.mainWindowController.window makeKeyAndOrderFront:self];
}

@end
