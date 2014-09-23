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

#import <LayerVaultAPI/LVCV2AuthenticatedClient.h>
#import <LayerVaultAPI/LVCUserCollection.h>
#import "LVMUser.h"
#import "LVCAppDelegate.h"
#import <LayerVaultAPI/LVCOrganizationCollection.h>
#import <LayerVaultAPI/LVCProjectCollection.h>
#import <LayerVaultAPI/LVCFolderCollection.h>
#import <LayerVaultAPI/LVCFileCollection.h>
#import <LayerVaultAPI/MRTRevisionsResponse.h>
#import "MRTUserResponse+ManagedObjectSerialization.h"
#import "LVCModelResponseGlue.h"

NSString *const LVCTreeBuilderKeychain = @"LayerVaultAPIDemoApp";

@interface LVCTreeBuilder ()
@property (nonatomic, readonly) LVCHTTPClient *client;
@property (nonatomic) LVCV2AuthenticatedClient *authenticatedClient;
@end

@implementation LVCTreeBuilder

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSURL *url = [NSURL URLWithString:@"https://beta.layervault.com/api/v2/"];
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
    self.authenticatedClient = [[LVCV2AuthenticatedClient alloc] initWithBaseURL:self.client.baseURL oAuthCredential:credential];


/// Creating
//    NSString *orgID = @"1450";
//    __block NSString *slugPath;
//    __block NSString *fileID;
//    __block NSURL *remoteURL = [NSURL URLWithString:@"https://s3.amazonaws.com"];
//    NSURL *fileURL = [NSURL fileURLWithPath:@"/Users/matt/Downloads/homunculus.jpg"];
//    NSString *md5 = @"7d4d3d94da5fe96fb83ff62dfd9bb0bb";
//
//    __weak typeof(self) weakSelf = self;
//
//    [self.authenticatedClient organizationsWithIDs:@[orgID]].then(^(LVCOrganizationCollection *organizationCollection) {
//        LVCOrganizationValue *organization = nil;
//        if (organizationCollection.organizations.count == 1) {
//            organization = organizationCollection.organizations[0];
//        }
//
//        return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
//            if (organization) {
//                fulfill(organization);
//            } else {
//                reject([NSError errorWithDomain:@"asdf" code:1234 userInfo:nil]);
//            }
//        }];
//    }).then(^(LVCOrganizationValue *orgaizationResponse) {
//        slugPath = orgaizationResponse.slug;
//        return [weakSelf.authenticatedClient createProjectWithName:@"The Beatles"
//                                                    organizationID:@"1450"
//                                                          isPublic:YES
//                                                         colorName:[LVCColorUtils colorNameForLabel:LVCColorRed]];
//    }).then(^(MRTProjectResponse *project) {
//        slugPath = [slugPath stringByAppendingPathComponent:project.slug];
//        return [weakSelf.authenticatedClient createFolderWithName:@"George"
//                                                        projectID:project.uid];
//    }).then(^(LVCFolderValue *folder) {
//        slugPath = [slugPath stringByAppendingPathComponent:folder.slug];
//        return [weakSelf.authenticatedClient createFolderWithName:@"Ringo"
//                                                   parentFolderID:folder.uid];
//    }).then(^(LVCFolderValue *folder) {
//        slugPath = [slugPath stringByAppendingPathComponent:folder.slug];
//        return [weakSelf.authenticatedClient createFileWithName:@"John.png"
//                                                 parentFolderID:folder.uid];
//    }).then(^(LVCFileValue *file) {
//        fileID = file.uid;
//        slugPath = [slugPath stringByAppendingPathComponent:file.slug];
//        remoteURL = [remoteURL URLByAppendingPathComponent:@"omnivore-scratch"];
//        return [weakSelf.authenticatedClient generateS3ResourceForPath:slugPath bucket:nil maxFileSize:nil];
//    }).then(^(NSDictionary *responseParameters) {
//        NSString *key = responseParameters[@"key"];
//        if (key) {
//            remoteURL = [remoteURL URLByAppendingPathComponent:key];
//        }
//        return [weakSelf.authenticatedClient uploadFile:fileURL
//                                             parameters:responseParameters];
//    }).then(^(id response) {
//        return [weakSelf.authenticatedClient createRevisionForFileID:fileID md5:md5 remoteURL:remoteURL parentMD5:nil];
//    }).then(^(MRTRevisionResponse *revisionResponse) {
//        NSLog(@"revision response: %@", revisionResponse);
//    }).catch(^(NSError *error) {
//        NSLog(@"Error: %@", error);
//    });


//    __weak typeof(self) weakSelf = self;
//    [self.authenticatedClient organizationsWithIDs:@[orgID]].then(^(LVCOrganizationCollection *organizationCollection) {
//        LVCOrganizationValue *organization = nil;
//        if (organizationCollection.organizations.count == 1) {
//            organization = organizationCollection.organizations[0];
//        }
//
//        return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
//            if (organization) {
//                fulfill(organization);
//            } else {
//                reject([NSError errorWithDomain:@"asdf" code:1234 userInfo:nil]);
//            }
//        }];
//    }).then(^(LVCOrganizationValue *orgaizationResponse) {
//        slugPath = orgaizationResponse.slug;
//        return [weakSelf.authenticatedClient createProjectWithName:@"Music"
//                                                    organizationID:@"1450"
//                                                          isPublic:YES
//                                                         colorName:[LVCColorUtils colorNameForLabel:LVCColorGreen]];
//    }).then(^(MRTProjectResponse *project) {
//        slugPath = [slugPath stringByAppendingPathComponent:project.slug];
//        return [weakSelf.authenticatedClient createFolderWithName:@"Bill Evans"
//                                                        projectID:project.uid];
//    }).then(^(LVCFolderValue *folder) {
//        slugPath = [slugPath stringByAppendingPathComponent:folder.slug];
//        return [weakSelf.authenticatedClient createFolderWithName:@"Conversations with Myself"
//                                                   parentFolderID:folder.uid];
//    }).then(^(LVCFolderValue *folder) {
//        slugPath = [slugPath stringByAppendingPathComponent:folder.slug];
//        return [weakSelf.authenticatedClient createFileWithName:@"Blue Monk"
//                                                 parentFolderID:folder.uid];
//    }).then(^(LVCFileValue *file) {
//        slugPath = [slugPath stringByAppendingPathComponent:file.slug];
//        return [weakSelf.authenticatedClient createFileWithName:@"Blue Monk"
//                                                 parentFolderID:file.uid];
//    }).catch(^(NSError *error) {
//        NSLog(@"Error: %@", error);
//    });


//    __weak typeof(self) weakSelf = self;
//    NSDate *startDate = [NSDate date];
//    __block LVCUserModel *userValue;
//    self.authenticatedClient.me.then(^(LVCUserModel *recievedUserResponse) {
//        userValue = recievedUserResponse;
//        return [weakSelf userFromUserResponse:recievedUserResponse];
//    }).then(^(LVCUser *user){
//        NSLog(@"user: %@", user);
//        NSLog(@"completed in: %f", [[NSDate date] timeIntervalSinceDate:startDate]);
//        NSLog(@"foo");
//    }).catch(^(NSError *error) {
//        NSLog(@"%@", error);
//    });
}

- (PMKPromise *)userFromUserResponse:(LVCUserValue *)userValue {
    __weak typeof(self) weakSelf = self;
    return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
        [weakSelf.authenticatedClient organizationsWithIDs:userValue.organizationIDs].then(^(LVCOrganizationCollection *organizationCollection) {
            return [weakSelf organizationsWithUserID:userValue.uid
                           fromOrganizationsResponse:organizationCollection];
        }).thenOn(dispatch_get_main_queue(), ^(NSArray *organizations) {

            NSManagedObjectContext *moc = [(LVCAppDelegate *)[[NSApplication sharedApplication] delegate] managedObjectContext];

            NSFetchRequest *request = [[NSFetchRequest alloc] init];
            NSEntityDescription *entity =
            [NSEntityDescription entityForName:@"User"
                        inManagedObjectContext:moc];
            [request setEntity:entity];

            NSPredicate *predicate =
            [NSPredicate predicateWithFormat:@"uid == %@", userValue.uid];
            [request setPredicate:predicate];

            LVMUser *user = nil;

            NSError *error;
            NSArray *array = [moc executeFetchRequest:request error:&error];
            if (array.count > 0) {
                user = array[0];
                NSLog(@"user found: %@", user);
            } else {
                NSLog(@"Creating user from: %@", userValue);
                user = (LVMUser *)[NSEntityDescription insertNewObjectForEntityForName:@"LVMUser" inManagedObjectContext:moc];
                user.uid = userValue.uid;
                user.email = userValue.email;
                user.firstName = userValue.firstName;
                user.lastName = userValue.lastName;
                user.hasSeenTourValue = userValue.hasSeenTour;
                user.hasConfiguredAccountValue = userValue.hasConfiguredAccount;
                [moc save:&error];
            }

            NSLog(@"user: %@", user);
            NSLog(@"Error: %@", error);
            NSLog(@"Foo");

//            userValue.organizations = organizations;
            fulfill(userValue);
        }).catch(^(NSError *error) {
            reject(error);
        });
    }];
}

- (PMKPromise *)organizationsWithUserID:(NSString *)userID
              fromOrganizationsResponse:(LVCOrganizationCollection *)organizationCollection {
    __weak typeof(self) weakSelf = self;
    return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
        // Create Organizations with the projects
        NSMutableArray *organizationRequests = @[].mutableCopy;
        for (LVCOrganizationValue *orgResponse in organizationCollection.organizations) {
            if ((orgResponse.syncType == LVCSyncTypeLayerVault)
                && (orgResponse.projectIDs.count > 0)
                && (![orgResponse.spectatorIDs containsObject:userID])) {
                [organizationRequests addObject:[weakSelf organizationWithUserID:userID
                                                   fromOrganizationResponse:orgResponse]];
            }
        }
        [PMKPromise when:organizationRequests].then(^(NSArray *organizations) {
            fulfill(organizations);
        }).catch(^(NSError *error) {
            reject(error);
        });
    }];
}

- (PMKPromise *)organizationWithUserID:(NSString *)userID
              fromOrganizationResponse:(LVCOrganizationValue *)organizationCollection {
    __weak typeof(self) weakSelf = self;
    return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {

        [self.authenticatedClient projectsWithIDs:organizationCollection.projectIDs].then(^(LVCProjectCollection *projectsRespnse) {
            return [weakSelf projectsWithMember:userID fromProjectsResponse:projectsRespnse];
        }).then(^(NSArray *projects) {
//            organizationCollection.projects = projects;
            fulfill(organizationCollection);
        }).catch(^(NSError *error) {
            reject(error);
        });
    }];
}

- (PMKPromise *)projectsWithMember:(NSString *)userID fromProjectsResponse:(LVCProjectCollection *)projectCollection {
    __weak typeof(self) weakSelf = self;
    return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
        NSMutableArray *projectRequests = @[].mutableCopy;
        for (LVCProjectValue *project in projectCollection.projects) {
            if ([project.userIDs containsObject:userID]) {
                [projectRequests addObject:[weakSelf projectFromProjectResponse:project]];
            }
        }
        [PMKPromise when:projectRequests].then(^(NSArray *projects) {
            fulfill(projects);
        }).catch(^(NSError *error) {
            reject(error);
        });
    }];
}

- (PMKPromise *)projectFromProjectResponse:(LVCProjectValue *)project {
    __weak typeof(self) weakSelf = self;
    return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {

        NSMutableArray *resourceRequests = @[].mutableCopy;
        if (project.folderIDs.count > 0) {
            [resourceRequests addObject:[weakSelf.authenticatedClient foldersWithIDs:project.folderIDs]];
        }
        if (project.fileIDs.count > 0) {
            [resourceRequests addObject:[weakSelf.authenticatedClient filesWithIDs:project.fileIDs]];
        }

        [PMKPromise when:resourceRequests].then(^(NSArray *foldersAndFiles) {
            NSMutableArray *foldersAndFilesRequests = @[].mutableCopy;
            for (id foldersOrFiles in foldersAndFiles) {
                if ([foldersOrFiles isKindOfClass:[LVCFolderCollection class]]) {
                    LVCFolderCollection *folderCollection = (LVCFolderCollection *)foldersOrFiles;
                    [foldersAndFilesRequests addObject:[weakSelf foldersFromFoldersResponse:folderCollection]];
                }
                else if ([foldersOrFiles isKindOfClass:[LVCFileCollection class]]) {
                    LVCFileCollection *files = (LVCFileCollection *)foldersOrFiles;
                    [foldersAndFilesRequests addObject:[weakSelf filesFromFilesResponse:files]];
                }
            }
            return [PMKPromise when:foldersAndFilesRequests];
        }).then(^(NSArray *foldersOrFiles) {
            for (NSArray *folderOrFileArray in foldersOrFiles) {
                if ((folderOrFileArray.count > 0)
                    && [folderOrFileArray[0] isKindOfClass:[LVCFolderValue class]]) {
//                    project.folders = folderOrFileArray;
                } else if ((folderOrFileArray.count > 0)
                           && [folderOrFileArray[0] isKindOfClass:[LVCFolderValue class]]) {
//                    project.files = folderOrFileArray;
                }
            }
            fulfill(project);
        }).catch(^(NSError *error) {
            reject(error);
        });
    }];
}

- (PMKPromise *)foldersFromFoldersResponse:(LVCFolderCollection *)folderCollection {
    __weak typeof(self) weakSelf = self;
    return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
        NSMutableArray *foldersRequests = @[].mutableCopy;
        for (LVCFolderValue *folder in folderCollection.folders) {
            [foldersRequests addObject:[weakSelf folderFromFolderResponse:folder]];
        }
        [PMKPromise when:foldersRequests].then(^(NSArray *folders) {
            fulfill(folders);
        }).catch(^(NSError *error) {
            reject(error);
        });
    }];
}


- (PMKPromise *)folderFromFolderResponse:(LVCFolderValue *)folder {
    __weak typeof(self) weakSelf = self;
    return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {

        NSMutableArray *resourceRequests = @[].mutableCopy;
        if (folder.folderIDs.count > 0) {
            [resourceRequests addObject:[weakSelf.authenticatedClient foldersWithIDs:folder.folderIDs]];
        }
        if (folder.fileIDs.count > 0) {
            [resourceRequests addObject:[weakSelf.authenticatedClient filesWithIDs:folder.fileIDs]];
        }

        [PMKPromise when:resourceRequests].then(^(NSArray *foldersAndFiles) {
            NSMutableArray *foldersAndFilesRequests = @[].mutableCopy;
            for (id foldersOrFiles in foldersAndFiles) {
                if ([foldersOrFiles isKindOfClass:[LVCFolderCollection class]]) {
                    LVCFolderCollection *folderCollection = (LVCFolderCollection *)foldersOrFiles;
                    [foldersAndFilesRequests addObject:[weakSelf foldersFromFoldersResponse:folderCollection]];
                }
                else if ([foldersOrFiles isKindOfClass:[LVCFileCollection class]]) {
                    LVCFileCollection *files = (LVCFileCollection *)foldersOrFiles;
                    [foldersAndFilesRequests addObject:[weakSelf filesFromFilesResponse:files]];
                }
            }
            return [PMKPromise when:foldersAndFilesRequests];
        }).then(^(NSArray *foldersOrFiles) {

            for (NSArray *folderOrFileArray in foldersOrFiles) {
                if ((folderOrFileArray.count > 0)
                    && [folderOrFileArray[0] isKindOfClass:[LVCFolderValue class]]) {
//                    folder.folders = folderOrFileArray;
                } else if ((folderOrFileArray.count > 0)
                           && [folderOrFileArray[0] isKindOfClass:[LVCFileValue class]]) {
//                    folder.files = folderOrFileArray;
                }
            }

            fulfill(folder);

        }).catch(^(NSError *error) {
            reject(error);
        });
    }];
}


- (PMKPromise *)filesFromFilesResponse:(LVCFileCollection *)fileCollection {
    __weak typeof(self) weakSelf = self;
    return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
        NSMutableArray *filesRequests = @[].mutableCopy;
        for (LVCFileValue *file in fileCollection.files) {
            [filesRequests addObject:[weakSelf fileFromFileResponse:file]];
        }
        [PMKPromise when:filesRequests].then(^(NSArray *files) {
            fulfill(files);
        }).catch(^(NSError *error) {
            reject(error);
        });
    }];
}


- (PMKPromise *)fileFromFileResponse:(LVCFileValue *)file {
    __weak typeof(self) weakSelf = self;
    return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
        [weakSelf.authenticatedClient revisionsWithIDs:@[file.lastRevisionID]].thenOn(dispatch_get_main_queue(), ^(MRTRevisionsResponse *revisionsResponse) {

//            LVMRevision *lastRevision = nil;
//            if (revisionsResponse.revisionResponses.count > 0) {
//                MRTRevisionResponse *revision = revisionsResponse.revisionResponses[0];
//            }
//            file.lastRevision = lastRevision;
            fulfill(file);
        }).catch(^(NSError *error) {
            reject(error);
        });
    }];
}

@end
