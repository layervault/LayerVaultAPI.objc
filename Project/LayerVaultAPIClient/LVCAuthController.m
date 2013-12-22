//
//  LVCAuthController.m
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 12/21/13.
//  Copyright (c) 2013 LayerVault. All rights reserved.
//

#import "LVCAuthController.h"
#import "LVConstants.h"
#import <LayerVaultAPI/LayerVaultAPI.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <AFOAuth2Client/AFOAuth2Client.h>

@interface LVCAuthController ()
@property (nonatomic) AFOAuthCredential *credential;
@property (nonatomic) LVCUser *user;
@property (nonatomic, copy) void (^loginHander)(LVCUser *user, LVCHTTPClient *client, NSError *error);
@end


@implementation LVCAuthController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [RACObserve(self, credential) subscribeNext:^(AFOAuthCredential *credential) {
            if (credential) {
                if (credential.expired) {
                    [self.client authenticateUsingOAuthWithPath:@"/oauth/token"
                                                   refreshToken:credential.refreshToken
                                                        success:^(AFOAuthCredential *refreshedCredential) {
                                                            self.credential = refreshedCredential;
                                                        }
                                                        failure:^(NSError *error) {
                                                            if (self.loginHander) {
                                                                self.loginHander(nil, self.client, error);
                                                            }
                                                            self.credential = nil;
                                                        }];
                }
                else {
                    [AFOAuthCredential storeCredential:credential
                                        withIdentifier:self.client.serviceProviderIdentifier];
                    [self.client setAuthorizationHeaderWithCredential:credential];
                    [self.client getMeWithCompletion:^(LVCUser *user,
                                                       NSError *error,
                                                       AFHTTPRequestOperation *operation) {
                        self.user = user;
                        if (!user) {
                            self.credential = nil;
                        }
                        if (self.loginHander) {
                            self.loginHander(self.user, self.client, error);
                        }
                    }];
                }
            }
        }];

        _client = [[LVCHTTPClient alloc] initWithClientID:LVClientID
                                                   secret:LVClientSecret];
        self.credential = [AFOAuthCredential retrieveCredentialWithIdentifier:_client.serviceProviderIdentifier];

    }
    return self;
}

- (void)loginWithEmail:(NSString *)email
              password:(NSString *)password
            completion:(void (^)(LVCUser *user,
                                 LVCHTTPClient *client,
                                 NSError *error))completion
{
    self.loginHander = completion;
    [self.client authenticateWithEmail:email
                              password:password
                            completion:^(AFOAuthCredential *credential,
                                         NSError *error) {
                                if (credential) {
                                    self.credential = credential;
                                }
                                else if (self.loginHander) {
                                    self.loginHander(nil, self.client, error);
                                }
                            }];
}

- (void)logout
{

}


@end
