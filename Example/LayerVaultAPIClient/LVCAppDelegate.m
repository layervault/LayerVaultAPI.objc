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
#import <LayerVaultAPI/LVCTreeBuilder.h>


@interface LVCAppDelegate ()
@property (nonatomic) LVCHTTPClient *client;
@property (nonatomic) LVCMainWindowController *mainWindowController;
@property (nonatomic) LVCTreeBuilder *treeBuilder;
@end

@implementation LVCAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSURL *baseURL = [NSURL URLWithString:@"https://api.layervault.com/api/v1"];
    AFOAuthCredential *cred = [[AFOAuthCredential alloc] initWithOAuthToken:@"***REMOVED***" tokenType:@"Bearer"];
    self.treeBuilder = [[LVCTreeBuilder alloc] initWithBaseURL:baseURL authenticationCredential:cred persistentStoreURL:nil];

    NSDate *startDate = [NSDate date];
    [self.treeBuilder buildUserTreeWithCompletion:^(LVCUser *user, NSError *error) {
        NSLog(@"user: %@", user);
        NSLog(@"error: %@", error);
        NSLog(@"finished in: %f", [[NSDate date] timeIntervalSinceDate:startDate]);
    }];

//    NSURL *userFile = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"user.model"];
//
//    NSString *keychainService = @"LayerVaultAPIDemoApp";
//    NSURL *url = [NSURL URLWithString:@"https://api.layervault.com"];
//    self.client = [[LVCAuthenticatedClient alloc] initWithBaseURL:url
//                                                         clientID:LVClientID
//                                                           secret:LVClientSecret
//                                               persistentStoreURL:userFile];
//
//    NSString *accountEmail = nil;
//    NSString *accountPassword = nil;
//    NSArray *accounts = [SSKeychain accountsForService:keychainService];
//    if (accounts.count > 0) {
//        accountEmail = accounts[0][kSSKeychainAccountKey];
//        accountPassword = [SSKeychain passwordForService:keychainService
//                                                 account:accountEmail];
//        __weak typeof(self) weakSelf = self;
//        [_client authenticateWithEmail:accountEmail password:accountPassword completion:^(AFOAuthCredential *credential, NSError *error) {
//            if (credential) {
//                NSLog(@"credential: %@", credential);
//                weakSelf.treeBuilder = [[LVCTreeBuilder alloc] initWithBaseURL:url
//                                                      authenticationCredential:credential
//                                                            persistentStoreURL:userFile];
//                [weakSelf.treeBuilder buildUserTreeWithCompletion:^(LVCUser *user,
//                                                                    NSError *buildTreeError) {
//                    NSLog(@"user done: %@", user.email);
//                    NSLog(@"error: %@", buildTreeError);
//                }];
//            }
//        }];
//    }



//    self.mainWindowController = [[LVCMainWindowController alloc] initWithWindowNibName:@"LVCMainWindowController"];
//    [self.mainWindowController showWindow:nil];
//    [self.mainWindowController.window makeKeyAndOrderFront:self];
}

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.layervault.ORMLearning" in the user's Application Support directory.
    NSURL *appSupportURL = [[[NSFileManager defaultManager] URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject];
    return [appSupportURL URLByAppendingPathComponent:@"com.layervault.LayerVaultAPIClient"];
}

@end
