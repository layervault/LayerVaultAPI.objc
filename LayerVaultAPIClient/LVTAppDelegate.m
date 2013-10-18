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
#import <Mantle/EXTScope.h>

@interface LVTAppDelegate ()
@property (nonatomic) LVTHTTPClient *client;
@property (weak) IBOutlet NSTextField *loggedInLabel;
@property (weak) IBOutlet NSTextField *emailField;
@property (weak) IBOutlet NSSecureTextField *passwordField;
@property (weak) IBOutlet NSButton *loginButton;
@property (nonatomic) AFOAuthCredential *credential;
@end

@implementation LVTAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.client = [[LVTHTTPClient alloc] initWithClientID:LVClientID
                                                   secret:LVClientSecret];

    [RACObserve(self.client, user) subscribeNext:^(LVTUser *user) {
        if (user.email) {
            [self.loggedInLabel setStringValue:user.email];
            NSLog(@"logged in as: %@", user);
        }
        else {
            self.loggedInLabel.stringValue = NSLocalizedString(@"Not Logged In", nil);
        }
    }];

    @weakify(self);
    [RACObserve(self, credential) subscribeNext:^(AFOAuthCredential *credential) {
        @strongify(self);
        if (credential) {
            if (credential.isExpired) {
                @weakify(self);
                [self.client authenticateUsingOAuthWithPath:@"/oauth/token"
                                               refreshToken:credential.refreshToken
                                                    success:^(AFOAuthCredential *credential) {
                                                        @strongify(self);
                                                        self.credential = credential;
                                                    }
                                                    failure:^(NSError *error) {
                                                        @strongify(self);
                                                        self.credential = nil;
                                                    }];
            }
            else {
                [AFOAuthCredential storeCredential:credential
                                    withIdentifier:self.client.serviceProviderIdentifier];

                [self.emailField setEnabled:NO];
                self.emailField.stringValue = @"";
                [self.passwordField setEnabled:NO];
                self.passwordField.stringValue = @"";
                [self.loginButton setEnabled:NO];
                
                [[self.client fetchUserInfo] subscribeError:^(NSError *error) {
                    self.credential = nil;
                }];
            }
        }
        else {
            [AFOAuthCredential deleteCredentialWithIdentifier:self.client.serviceProviderIdentifier];
            [self.emailField setEnabled:YES];
            [self.emailField becomeFirstResponder];
            [self.passwordField setEnabled:YES];
            [self.loginButton setEnabled:YES];
        }
    }];


    self.credential = [AFOAuthCredential retrieveCredentialWithIdentifier:self.client.serviceProviderIdentifier];
}

- (IBAction)loginPressed:(NSButton *)sender
{
    @weakify(self)
    [self.client authenticateUsingOAuthWithPath:@"/oauth/token"
                                       username:self.emailField.stringValue
                                       password:self.passwordField.stringValue
                                          scope:nil
                                        success:^(AFOAuthCredential *credential) {
                                            @strongify(self);
                                            NSLog(@"I have a token! %@", credential);
                                            self.credential = credential;
                                        }
                                        failure:^(NSError *error) {
                                            @strongify(self);
                                            self.credential = nil;
                                        }];
}


@end
