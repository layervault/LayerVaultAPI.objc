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
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "LVConstants.h"

@interface LVTAppDelegate ()
@property (nonatomic) LVTHTTPClient *client;
@property (weak) IBOutlet NSTextField *loggedInLabel;
@property (weak) IBOutlet NSTextField *emailField;
@property (weak) IBOutlet NSTextField *passwordField;
@property (weak) IBOutlet NSButton *loginButton;
@end

@implementation LVTAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.client = [[LVTHTTPClient alloc] initWithClientID:LVClientID
                                                   secret:LVClientSecret];

    [RACObserve(self.client, user) subscribeNext:^(LVTUser *user) {
        if (user.email) {
            [self.loggedInLabel setStringValue:user.email];
        }
        else {
            self.loggedInLabel.stringValue = NSLocalizedString(@"Not Logged In", nil);
        }
    }];

    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:self.client.serviceProviderIdentifier];
    if (credential) {
        [self.client setAuthorizationHeaderWithCredential:credential];
        [self.client getMyInfo:nil];
    }
    else {
        
    }
}

@end
