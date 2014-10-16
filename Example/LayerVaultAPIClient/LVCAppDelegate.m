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
#import "MRTAuthenticationManager.h"
#import <PromiseKit/PromiseKit.h>
#import "LVCLoginViewController.h"
#import "LVCOrganizationsViewController.h"
#import <LayerVaultAPI/LVCV2AuthenticatedClient.h>
#import "NSError+LVCNetworkErrors.h"

static void *LVCAppDelegateContext = &LVCAppDelegateContext;

@interface LVCAppDelegate ()
@property (nonatomic) LVCHTTPClient *client;
@property (nonatomic) LVCMainWindowController *mainWindowController;
@property (nonatomic) LVCTreeBuilder *treeBuilder;
@property (nonatomic) MRTAuthenticationManager *authenticationManager;
@property (nonatomic) LVCLoginViewController *loginVC;
@property (nonatomic) LVCOrganizationsViewController *orgViewController;
@end

@implementation LVCAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {

    NSURL *baseURL = [NSURL URLWithString:@"https://api.layervault.com/"];
    self.authenticationManager = [[MRTAuthenticationManager alloc] initWithBaseURL:baseURL
                                                                          clientID:LVClientID
                                                                            secret:LVClientSecret];

    [self.authenticationManager addObserver:self forKeyPath:NSStringFromSelector(@selector(authenticationState)) options:NSKeyValueObservingOptionNew context:LVCAppDelegateContext];

    self.mainWindowController = [[LVCMainWindowController alloc] initWithWindowNibName:@"LVCMainWindowController"];

    self.loginVC = [[LVCLoginViewController alloc] initWithNibName:@"LVCLoginViewController" bundle:nil];
    __weak typeof(self) weakSelf = self;
    self.loginVC.loginHander = ^(NSString *email, NSString *password, NSString *token){
        PMKPromise *promise = nil;
        if (token.length > 0) {
            AFOAuthCredential *credential = [AFOAuthCredential credentialWithOAuthToken:token tokenType:@"Bearer"];
            promise = [weakSelf.authenticationManager authenticateWithCredential:credential];
        } else if (email.length > 0 && password.length > 0) {
            promise = [weakSelf.authenticationManager authenticateWithEmail:email password:password];
        }

        if (promise) {
            promise.then(^(LVCUserValue *userValue) {
                [weakSelf showOrganizationsForUser:userValue];
            }).catch(^(NSError *error) {
                NSLog(@"Error: %@", error);
            });
        }

    };
    self.mainWindowController.window.contentView = self.loginVC.view;


//    NSURL *baseURL = [NSURL URLWithString:@"https://api.layervault.com/"];
//    AFOAuthCredential *cred = [[AFOAuthCredential alloc] initWithOAuthToken:LVOAuthToken
//                                                                  tokenType:@"Bearer"];
//    self.authenticationManager = [[MRTAuthenticationManager alloc] initWithBaseURL:baseURL];
//    [self.authenticationManager authenticateWithCredential:cred].then(^(LVCUserValue *userValue) {
//        NSLog(@"Successfully signed in as %@", userValue);
//    }).catch(^(NSError *error) {
//        NSLog(@"error: %@", error);
//    });

//    NSURL *baseURL = [NSURL URLWithString:@"https://api.layervault.com/api/v1"];
//    AFOAuthCredential *cred = [[AFOAuthCredential alloc] initWithOAuthToken:LVOAuthToken
//                                                                  tokenType:@"Bearer"];
//    self.treeBuilder = [[LVCTreeBuilder alloc] initWithBaseURL:baseURL authenticationCredential:cred persistentStoreURL:nil];
//
//    NSDate *startDate = [NSDate date];
//    [self.treeBuilder buildUserTreeWithCompletion:^(LVCUser *user, NSError *error) {
//        NSLog(@"user: %@", user);
//        NSLog(@"error: %@", error);
//        NSLog(@"finished in: %f", [[NSDate date] timeIntervalSinceDate:startDate]);
//    }];

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




    [self.mainWindowController showWindow:nil];
    [self.mainWindowController.window makeKeyAndOrderFront:self];
}

- (void)showOrganizationsForUser:(LVCUserValue *)user {
    if (!self.orgViewController) {
        self.orgViewController = [[LVCOrganizationsViewController alloc] initWithNibName:@"LVCOrganizationsViewController" bundle:nil];
    }
    self.orgViewController.organizations = nil;
    self.mainWindowController.window.contentView = self.orgViewController.view;

    NSURL *baseURL = [NSURL URLWithString:@"https://api.layervault.com/api/v2"];
    LVCV2AuthenticatedClient *v2Client = [[LVCV2AuthenticatedClient alloc] initWithBaseURL:baseURL oAuthCredential:self.authenticationManager.credential];
    __weak typeof(self) weakSelf = self;
    [v2Client organizationsWithIDs:user.organizationIDs].then(^(NSArray *orgValues) {
        weakSelf.orgViewController.organizations = orgValues;
    }).catch(^(NSError *error) {
        if ([error lvc_failedWithHTTPStatusCode:401]) {
            [self.authenticationManager expireCredential];
        }
        NSLog(@"at this point, we would show an error, unless we ");
    });
}

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.layervault.ORMLearning" in the user's Application Support directory.
    NSURL *appSupportURL = [[[NSFileManager defaultManager] URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject];
    return [appSupportURL URLByAppendingPathComponent:@"com.layervault.LayerVaultAPIClient"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context == LVCAppDelegateContext) {
        if ([keyPath isEqualToString:NSStringFromSelector(@selector(authenticationState))]) {
            NSLog(@"authenticationState: %@", LVCAuthenticationStateDescription[self.authenticationManager.authenticationState]);
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end
