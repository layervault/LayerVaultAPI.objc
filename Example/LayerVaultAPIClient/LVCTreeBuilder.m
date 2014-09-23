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

#import <LayerVaultAPI/LVCV2AuthenticatedClient.h>
#import <LayerVaultAPI/LVCUserCollection.h>
#import <LayerVaultAPI/LVCOrganizationCollection.h>
#import <LayerVaultAPI/LVCProjectCollection.h>
#import <LayerVaultAPI/LVCFolderCollection.h>
#import <LayerVaultAPI/LVCFileCollection.h>
#import <LayerVaultAPI/LVCRevisionCollection.h>
#import "LVCModelResponseGlue.h"

@interface LVCTreeBuilder ()
@property (nonatomic) LVCV2AuthenticatedClient *authenticatedClient;
@end

@implementation LVCTreeBuilder

- (instancetype)initWithAuthenticationCredential:(AFOAuthCredential *)authenticationCredential
{
    self = [super init];
    if (self) {
#warning - Keeping this at beta for now
        NSURL *url = [NSURL URLWithString:@"https://beta.layervault.com/api/v2/"];
        _authenticatedClient = [[LVCV2AuthenticatedClient alloc] initWithBaseURL:url
                                                                 oAuthCredential:authenticationCredential];
    }
    return self;
}

- (void)sampleMethods:(AFOAuthCredential *)credential {
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
//    }).then(^(LVCRevisionValue *revision) {
//        NSLog(@"revision response: %@", revision);
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
}

- (void)buildUserTreeWithCompletion:(void (^)(LVCUser *user, NSError *error))completion {
    __weak typeof(self) weakSelf = self;
    NSDate *startDate = [NSDate date];
    self.authenticatedClient.me.then(^(LVCUserValue *userValue) {
        return [weakSelf userFromUserValue:userValue];
    }).then(^(LVCUser *user){
        NSLog(@"completed in: %f", [[NSDate date] timeIntervalSinceDate:startDate]);
        completion(user, nil);
    }).catch(^(NSError *error) {
        completion(nil, error);
    });
}

- (PMKPromise *)userFromUserValue:(LVCUserValue *)userValue {
    __weak typeof(self) weakSelf = self;
    return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
        [weakSelf.authenticatedClient organizationsWithIDs:userValue.organizationIDs].then(^(LVCOrganizationCollection *organizationCollection) {
            return [weakSelf organizationsWithUserID:userValue.uid
                           fromOrganizationsValue:organizationCollection];
        }).then(^(NSArray *organizations) {
            LVCUser *user = [[LVCUser alloc] init];
            user.userID = (NSUInteger)[userValue.uid integerValue];
            user.email = userValue.email;
            user.firstName = userValue.firstName;
            user.lastName = userValue.lastName;
            user.organizations = organizations;
#warning - No admin
            user.admin = NO;
            fulfill(user);
        }).catch(^(NSError *error) {
            reject(error);
        });
    }];
}

- (PMKPromise *)organizationsWithUserID:(NSString *)userID
                 fromOrganizationsValue:(LVCOrganizationCollection *)organizationCollection {
    __weak typeof(self) weakSelf = self;
    return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
        // Create Organizations with the projects
        NSMutableArray *organizationRequests = @[].mutableCopy;
        for (LVCOrganizationValue *orgValue in organizationCollection.organizations) {
            if ((orgValue.syncType == LVCSyncTypeLayerVault)
                && (orgValue.projectIDs.count > 0)
                && (![orgValue.spectatorIDs containsObject:userID])) {
                [organizationRequests addObject:[weakSelf organizationWithUserID:userID
                                                   fromOrganizationValue:orgValue]];
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
              fromOrganizationValue:(LVCOrganizationValue *)organizationValue {
    __weak typeof(self) weakSelf = self;
    return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {

        [self.authenticatedClient projectsWithIDs:organizationValue.projectIDs].then(^(LVCProjectCollection *projectCollection) {
            return [weakSelf projectsWithMember:userID
                          organizationPermalink:organizationValue.slug
                          fromProjectCollection:projectCollection];
        }).then(^(NSArray *projects) {

#warning - use constants
            NSString *userRole = @"spectator";
            if ([organizationValue.editorIDs containsObject:userID]) {
                userRole = @"editor";
            } else if ([organizationValue.administratorIDs containsObject:userID]) {
                userRole = @"admin";
            }
            NSString *syncType = @"layervault";
            if (organizationValue.syncType == LVCSyncTypeDropBox) {
                syncType = @"dropbox";
            }

            LVCOrganization *organization = [[LVCOrganization alloc] init];
            organization.name = organizationValue.name;
            organization.userRole = userRole;
            organization.permalink = organizationValue.slug;
            organization.dateDeleted = organizationValue.dateDeleted;
            organization.dateUpdated = organizationValue.dateUpdated;
            organization.url = organizationValue.url;
            organization.syncType = syncType;
            for (LVCProject *project in projects) {
                project.organizationPermalink = organization.permalink;
            }
            organization.projects = projects;
            fulfill(organization);
        }).catch(^(NSError *error) {
            reject(error);
        });
    }];
}

- (PMKPromise *)projectsWithMember:(NSString *)userID
             organizationPermalink:(NSString *)organizationPermalink
             fromProjectCollection:(LVCProjectCollection *)projectCollection {
    __weak typeof(self) weakSelf = self;
    return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
        NSMutableArray *projectRequests = @[].mutableCopy;
        for (LVCProjectValue *project in projectCollection.projects) {
            if ([project.userIDs containsObject:userID]) {
                [projectRequests addObject:[weakSelf projectWithMember:userID
                                                 organizationPermalink:organizationPermalink
                                                      fromProjectValue:project]];
            }
        }
        [PMKPromise when:projectRequests].then(^(NSArray *projects) {
            fulfill(projects);
        }).catch(^(NSError *error) {
            reject(error);
        });
    }];
}

- (PMKPromise *)projectWithMember:(NSString *)userID
            organizationPermalink:(NSString *)organizationPermalink
                 fromProjectValue:(LVCProjectValue *)projectValue {
    __weak typeof(self) weakSelf = self;

    NSString *currentPath = [[@"~/LayerVault" stringByExpandingTildeInPath] stringByAppendingPathComponent:projectValue.name];

    return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {

        NSMutableArray *resourceRequests = @[].mutableCopy;
        if (projectValue.folderIDs.count > 0) {
            [resourceRequests addObject:[weakSelf.authenticatedClient foldersWithIDs:projectValue.folderIDs]];
        }
        if (projectValue.fileIDs.count > 0) {
            [resourceRequests addObject:[weakSelf.authenticatedClient filesWithIDs:projectValue.fileIDs]];
        }

        [PMKPromise when:resourceRequests].then(^(NSArray *foldersAndFiles) {
            NSMutableArray *foldersAndFilesRequests = @[].mutableCopy;
            for (id foldersOrFiles in foldersAndFiles) {
                if ([foldersOrFiles isKindOfClass:[LVCFolderCollection class]]) {
                    LVCFolderCollection *folderCollection = (LVCFolderCollection *)foldersOrFiles;
                    [foldersAndFilesRequests addObject:[weakSelf foldersWithPathPrefix:currentPath
                                                                 organizationPermalink:organizationPermalink
                                                                  fromFolderCollection:folderCollection]];
                }
                else if ([foldersOrFiles isKindOfClass:[LVCFileCollection class]]) {
                    LVCFileCollection *files = (LVCFileCollection *)foldersOrFiles;
                    [foldersAndFilesRequests addObject:[weakSelf filesWithPathPrefix:currentPath
                                                                 fromFilesCollection:files]];
                }
            }
            return [PMKPromise when:foldersAndFilesRequests];
        }).then(^(NSArray *foldersOrFiles) {

            LVCProject *project = [[LVCProject alloc] init];
            project.member = [projectValue.userIDs containsObject:userID];
#warning - deprecate this
            project.partial = NO; // at this point, we will have everything! \o/
#warning - deprecate this
            project.synced = YES;
            project.colorLabel = projectValue.colorLabel;
            project.name = projectValue.name;
#warning - Both?!?!
            project.path = currentPath;
            project.fileURL = [NSURL fileURLWithPath:project.path];
            project.organizationPermalink = organizationPermalink;
            project.dateUpdated = projectValue.dateUpdated;
            project.url = projectValue.url;
#warning - url path is based on slugs. Best way to calculate it? pass in org here?
//            project.urlPath = organizationValue.slug;
#warning - Can we actually get dateDeleted?
//            project.dateDeleted = nil;
            for (NSArray *folderOrFileArray in foldersOrFiles) {
                if ((folderOrFileArray.count > 0)
                    && [folderOrFileArray[0] isKindOfClass:[LVCFolder class]]) {
                    NSArray *folders = folderOrFileArray;
                    for (LVCFolder *currentFolder in folders) {
                        currentFolder.parentFolder = project;
                    }
                    project.folders = folders;
                } else if ((folderOrFileArray.count > 0)
                           && [folderOrFileArray[0] isKindOfClass:[LVCFile class]]) {
                    NSArray *files = folderOrFileArray;
                    for (LVCFile *file in files) {
                        file.parentFolder = project;
                    }
                    project.files = files;
                }
            }
            fulfill(project);
        }).catch(^(NSError *error) {
            reject(error);
        });
    }];
}

- (PMKPromise *)foldersWithPathPrefix:(NSString *)pathPrefix
                organizationPermalink:(NSString *)organizationPermalink
                 fromFolderCollection:(LVCFolderCollection *)folderCollection {
    __weak typeof(self) weakSelf = self;
    return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
        NSMutableArray *foldersRequests = @[].mutableCopy;
        for (LVCFolderValue *folder in folderCollection.folders) {
            [foldersRequests addObject:[weakSelf folderWithPathPrefix:pathPrefix
                                                organizationPermalink:organizationPermalink
                                                      fromFolderValue:folder]];
        }
        [PMKPromise when:foldersRequests].then(^(NSArray *folders) {
            fulfill(folders);
        }).catch(^(NSError *error) {
            reject(error);
        });
    }];
}


- (PMKPromise *)folderWithPathPrefix:(NSString *)pathPrefix
               organizationPermalink:(NSString *)organizationPermalink
                     fromFolderValue:(LVCFolderValue *)folderValue {

    NSString *currentPath = [pathPrefix stringByAppendingPathComponent:folderValue.name];

    __weak typeof(self) weakSelf = self;
    return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {

        NSMutableArray *resourceRequests = @[].mutableCopy;
        if (folderValue.folderIDs.count > 0) {
            [resourceRequests addObject:[weakSelf.authenticatedClient foldersWithIDs:folderValue.folderIDs]];
        }
        if (folderValue.fileIDs.count > 0) {
            [resourceRequests addObject:[weakSelf.authenticatedClient filesWithIDs:folderValue.fileIDs]];
        }

        [PMKPromise when:resourceRequests].then(^(NSArray *foldersAndFiles) {
            NSMutableArray *foldersAndFilesRequests = @[].mutableCopy;
            for (id foldersOrFiles in foldersAndFiles) {
                if ([foldersOrFiles isKindOfClass:[LVCFolderCollection class]]) {
                    LVCFolderCollection *folderCollection = (LVCFolderCollection *)foldersOrFiles;
                    [foldersAndFilesRequests addObject:[weakSelf foldersWithPathPrefix:currentPath
                                                                 organizationPermalink:organizationPermalink
                                                                  fromFolderCollection:folderCollection]];
                }
                else if ([foldersOrFiles isKindOfClass:[LVCFileCollection class]]) {
                    LVCFileCollection *files = (LVCFileCollection *)foldersOrFiles;
                    [foldersAndFilesRequests addObject:[weakSelf filesWithPathPrefix:currentPath
                                                                 fromFilesCollection:files]];
                }
            }
            return [PMKPromise when:foldersAndFilesRequests];
        }).then(^(NSArray *foldersOrFiles) {

            LVCFolder *folder = [[LVCFolder alloc] init];
            folder.colorLabel = LVCColorWhite;
            folder.name = folderValue.name;
#warning - Both?!?!
            folder.path = currentPath;
            folder.fileURL = [NSURL fileURLWithPath:folder.path];
            folder.organizationPermalink = organizationPermalink;
#warning - Pass organization Value?
//            folder.organizationPermalink = organizationValue.slug;
            folder.dateUpdated = folderValue.dateUpdated;
            folder.url = folderValue.url;
#warning - url path is based on slugs. Best way to calculate it? pass in org here?
//            folder.urlPath = organizationValue.slug;
#warning - Can we actually get dateDeleted?
//            folder.dateDeleted = nil;
            for (NSArray *folderOrFileArray in foldersOrFiles) {
                if ((folderOrFileArray.count > 0)
                    && [folderOrFileArray[0] isKindOfClass:[LVCFolder class]]) {
                    NSArray *folders = folderOrFileArray;
                    for (LVCFolder *currentFolder in folders) {
                        currentFolder.parentFolder = folder;
                    }
                    folder.folders = folders;
                } else if ((folderOrFileArray.count > 0)
                           && [folderOrFileArray[0] isKindOfClass:[LVCFile class]]) {
                    NSArray *files = folderOrFileArray;
                    for (LVCFile *file in files) {
                        file.parentFolder = folder;
                    }
                    folder.files = files;
                }
            }
            fulfill(folder);
        }).catch(^(NSError *error) {
            reject(error);
        });
    }];
}


- (PMKPromise *)filesWithPathPrefix:(NSString *)pathPrefix
                     fromFilesCollection:(LVCFileCollection *)fileCollection {
    __weak typeof(self) weakSelf = self;
    return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
        NSMutableArray *filesRequests = @[].mutableCopy;
        for (LVCFileValue *file in fileCollection.files) {
            [filesRequests addObject:[weakSelf fileWithPathPrefix:pathPrefix
                                                    fromFileValue:file]];
        }
        [PMKPromise when:filesRequests].then(^(NSArray *files) {
            fulfill(files);
        }).catch(^(NSError *error) {
            reject(error);
        });
    }];
}


- (PMKPromise *)fileWithPathPrefix:(NSString *)pathPrefix
                     fromFileValue:(LVCFileValue *)fileValue {

    NSString *currentPath = [pathPrefix stringByAppendingPathComponent:fileValue.name];

    __weak typeof(self) weakSelf = self;
    return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
        [weakSelf.authenticatedClient revisionsWithIDs:@[fileValue.lastRevisionID]].then(^(LVCRevisionCollection *revisionCollection) {

            if (revisionCollection.revisions.count > 0) {
                LVCRevisionValue *revisionValue = revisionCollection.revisions[0];
                LVCFile *file = [[LVCFile alloc] init];
                file.revisionNumber = [NSNumber numberWithInteger:revisionValue.revisionNumber];
#warning - deprecate this
                file.revisions = nil;
#warning - both!??!
                file.dateModified = fileValue.dateUpdated;
                file.dateUpdated = fileValue.dateUpdated;
                file.downloadURL = revisionValue.downloadURL;
                file.name = fileValue.name;
                file.fileURL = [NSURL fileURLWithPath:currentPath];
                file.md5 = revisionValue.md5;

                fulfill(file);
            } else {
                reject([NSError errorWithDomain:@"plm" code:987 userInfo:nil]);
            }
        }).catch(^(NSError *error) {
            reject(error);
        });
    }];
}

@end
