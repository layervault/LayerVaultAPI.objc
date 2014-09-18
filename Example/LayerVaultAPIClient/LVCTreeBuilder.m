//
//  LVCTreeBuilder.m
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 9/17/14.
//  Copyright (c) 2014 LayerVault. All rights reserved.
//

#import "LVCTreeBuilder.h"
#import <AFNetworking/AFNetworking.h>
#import <LayerVaultAPI/LayerVaultAPI.h>
#import <PromiseKit/PromiseKit.h>
#import <SSKeychain/SSKeychain.h>
#import "LVConstants.h"

#import <LayerVaultAPI/MRTAuthenticatedClient.h>
#import <LayerVaultAPI/MRTUsersResponse.h>
#import <LayerVaultAPI/MRTOrganizationsResponse.h>
#import <LayerVaultAPI/MRTProjectsResponse.h>
#import <LayerVaultAPI/MRTFoldersResponse.h>
#import <LayerVaultAPI/MRTFilesResponse.h>

NSString *const LVCTreeBuilderKeychain = @"LayerVaultAPIDemoApp";

@interface LVCTreeBuilder ()
@property (nonatomic, readonly) LVCHTTPClient *client;
@property (nonatomic) MRTAuthenticatedClient *authenticatedClient;
@end

@implementation LVCTreeBuilder

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSURL *url = [NSURL URLWithString:@"https://api.layervault.com/api/v2/"];
        _client = [[LVCAuthenticatedClient alloc] initWithBaseURL:url
                                                         clientID:LVClientID
                                                           secret:LVClientSecret];

        NSString *accountEmail = nil;
        NSString *accountPassword = nil;
        NSArray *accounts = [SSKeychain accountsForService:LVCTreeBuilderKeychain];
        if (accounts.count > 0) {
            accountEmail = accounts[0][kSSKeychainAccountKey];
            accountPassword = [SSKeychain passwordForService:LVCTreeBuilderKeychain
                                                     account:accountEmail];
            __weak typeof(self) weakSelf = self;
            [_client authenticateWithEmail:accountEmail password:accountPassword completion:^(AFOAuthCredential *credential, NSError *error) {
                if (credential) {
                    [weakSelf authenticatedWithCredential:credential];
                }
            }];
        }
    }
    return self;
}

- (void)authenticatedWithCredential:(AFOAuthCredential *)credential {
    NSLog(@"logged in! %@", credential);
    self.authenticatedClient = [[MRTAuthenticatedClient alloc] initWithBaseURL:self.client.baseURL oAuthCredential:credential];

    __block NSString *userID = nil;

    __weak typeof(self) weakSelf = self;
    self.authenticatedClient.me.then(^(MRTUserResponse *userResponse) {
        NSLog(@"%@", userResponse);
        userID = userResponse.userID;
        return [weakSelf.authenticatedClient organizationsWithIDs:userResponse.organizationIDs];
    }).then(^(MRTOrganizationsResponse *organizationsResponse) {
        NSMutableArray *projectRequests = @[].mutableCopy;
        for (MRTOrganizationResponse *orgResponse in organizationsResponse.organizationResponses) {
            if ((orgResponse.syncType == LVCSyncTypeLayerVault)
                && (orgResponse.projectIDs.count > 0)
                && (![orgResponse.spectatorIDs containsObject:userID])) {
                NSLog(@"org: %@", orgResponse.slug);
                [projectRequests addObject:[weakSelf.authenticatedClient projectsWithIDs:orgResponse.projectIDs]];
            }
        }
        return [PMKPromise when:projectRequests];
    }).then(^(NSArray *projectsResponses) {
        NSMutableArray *folderRequests = @[].mutableCopy;
        for (MRTProjectsResponse *projectsResponse in projectsResponses) {
            for (MRTProjectResponse *projectResponse in projectsResponse.projectResponses) {
                if ((projectResponse.folderIDs.count > 0)
                    && [projectResponse.userIDs containsObject:userID]) {
                    NSLog(@"project: %@", projectResponse.slug);
                    [folderRequests addObject:[weakSelf.authenticatedClient foldersWithIDs:projectResponse.folderIDs]];
                }
            }
        }
        return [PMKPromise when:folderRequests];
    }).then(^(NSArray *foldersResponses) {
        NSMutableArray *fileRequests = @[].mutableCopy;
        for (MRTFoldersResponse *foldersResponse in foldersResponses) {
            for (MRTFolderResponse *folderResponse in foldersResponse.folderResponses) {
                if (folderResponse.fileIDs.count > 0) {
                    NSLog(@"folder (%lu files): %@", (unsigned long)folderResponse.fileIDs.count, folderResponse.slug);
                    [fileRequests addObject:[weakSelf.authenticatedClient filesWithIDs:folderResponse.fileIDs]];
                }
            }
        }
        return [PMKPromise when:fileRequests];
    }).then(^(NSArray *filesResponses) {
        for (MRTFilesResponse *filesResponse in filesResponses) {
            for (MRTFileResponse *fileResponse in filesResponse.fileResponses) {
                NSLog(@"file: %@", fileResponse.slug);
            }
        }
    }).catch(^(NSError *error) {
        NSLog(@"%@", error);
    });
}

@end
