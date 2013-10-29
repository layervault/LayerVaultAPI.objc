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
@property (nonatomic) LVTUser *user;
@property (weak) IBOutlet NSTextField *orgTextField;
@property (weak) IBOutlet NSButton *orgButton;
@property (weak) IBOutlet NSTextField *projectTextField;
@property (weak) IBOutlet NSButton *projectButton;
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


- (IBAction)orgPressed:(NSButton *)sender
{
    [self.client getOrganizationWithName:self.orgTextField.stringValue
                                   block:^(LVTOrganization *organization,
                                           NSError *error,
                                           AFHTTPRequestOperation *operation) {
                                       NSLog(@"organization: %@", organization);
                                   }];
}


- (IBAction)projectPressed:(NSButton *)sender
{
}

@end
