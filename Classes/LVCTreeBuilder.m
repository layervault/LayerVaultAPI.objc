//
//  LVCTreeBuilder.m
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 9/17/14.
//  Copyright (c) 2014 LayerVault. All rights reserved.
//

#import "LVCTreeBuilder.h"
#import <AFNetworking/AFNetworking.h>
#import <PromiseKit/PromiseKit.h>
#import <PromiseKit/Promise+When.h>

#import "LVCFile.h"
#import "LVCFileCollection.h"
#import "LVCFileRevision.h"
#import "LVCFolder.h"
#import "LVCFolderCollection.h"
#import "LVCOrganization.h"
#import "LVCOrganizationCollection.h"
#import "LVCProject.h"
#import "LVCProjectCollection.h"
#import "LVCRevisionCollection.h"
#import "LVCUserCollection.h"
#import "LVCUser.h"
#import "LVCV2AuthenticatedClient.h"


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

- (void)playground {
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
        return [weakSelf treeUserFromValue:userValue];
    }).then(^(LVCUser *user){
        NSLog(@"completed in: %f", [[NSDate date] timeIntervalSinceDate:startDate]);
        completion(user, nil);
    }).catch(^(NSError *error) {
        completion(nil, error);
    });
}

- (PMKPromise *)treeUserFromValue:(LVCUserValue *)userValue {
    __weak typeof(self) weakSelf = self;
    return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
        [weakSelf.authenticatedClient organizationsWithIDs:userValue.organizationIDs].then(^(NSArray *organizationValues) {
            return [weakSelf treeOrganizationsWithUserID:userValue.uid
                                              fromValues:organizationValues];
        }).then(^(NSArray *organizations) {
            LVCUser *user = [[LVCUser alloc] init];
            user.userID = (NSUInteger)[userValue.uid integerValue];
            user.email = userValue.email;
            user.firstName = userValue.firstName;
            user.lastName = userValue.lastName;
            user.organizations = organizations;
            NSMutableArray *projects = @[].mutableCopy;
            for (LVCOrganization *org in organizations) {
                [projects addObjectsFromArray:org.projects];
            }
            user.projects = projects;
#warning - No admin
            user.admin = NO;
            fulfill(user);
        }).catch(^(NSError *error) {
            reject(error);
        });
    }];
}

- (PMKPromise *)treeOrganizationsWithUserID:(NSString *)userID
                                 fromValues:(NSArray *)organizationValues {
    __weak typeof(self) weakSelf = self;
    return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
        // Create Organizations with the projects
        NSMutableArray *organizationRequests = @[].mutableCopy;
        for (LVCOrganizationValue *orgValue in organizationValues) {
            if ((orgValue.syncType == LVCSyncTypeLayerVault)
                && (orgValue.projectIDs.count > 0)
                && (![orgValue.spectatorIDs containsObject:userID])) {
                [organizationRequests addObject:[weakSelf treeOrganizationWithUserID:userID
                                                                           fromValue:orgValue]];
            }
        }
        [PMKPromise when:organizationRequests].then(^(NSArray *organizations) {
            fulfill(organizations);
        }).catch(^(NSError *error) {
            reject(error);
        });
    }];
}

- (PMKPromise *)treeOrganizationWithUserID:(NSString *)userID
                                 fromValue:(LVCOrganizationValue *)organizationValue {
    __weak typeof(self) weakSelf = self;
    return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {

        [self.authenticatedClient projectsWithIDs:organizationValue.projectIDs].then(^(NSArray *projectValues) {
            return [weakSelf treeProjectsWithMember:userID
                              organizationPermalink:organizationValue.slug
                                         fromValues:projectValues];
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

- (PMKPromise *)treeProjectsWithMember:(NSString *)userID
                 organizationPermalink:(NSString *)organizationPermalink
                            fromValues:(NSArray *)projectValues {
    __weak typeof(self) weakSelf = self;
    return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
        NSMutableArray *projectRequests = @[].mutableCopy;
        for (LVCProjectValue *project in projectValues) {
            if ([project.userIDs containsObject:userID]) {
                [projectRequests addObject:[weakSelf treeProjectWithMember:userID
                                                     organizationPermalink:organizationPermalink
                                                                 fromValue:project]];
            }
        }
        [PMKPromise when:projectRequests].then(^(NSArray *projects) {
            fulfill(projects);
        }).catch(^(NSError *error) {
            reject(error);
        });
    }];
}

- (PMKPromise *)treeProjectWithMember:(NSString *)userID
                organizationPermalink:(NSString *)organizationPermalink
                            fromValue:(LVCProjectValue *)projectValue {

    NSString *currentPath = [[@"~/LayerVault" stringByExpandingTildeInPath] stringByAppendingPathComponent:projectValue.name];

    __weak typeof(self) weakSelf = self;
    return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {

        __block NSArray *subFolders = @[];
        __block NSArray *subFiles = @[];

        [weakSelf.authenticatedClient foldersWithIDs:projectValue.folderIDs].then(^(NSArray *folderValues) {
            return [weakSelf treeFoldersWithPathPrefix:currentPath organizationPermalink:organizationPermalink fromValues:folderValues];
        }).then(^(NSArray *treeFolders) {
            subFolders = treeFolders;
            return [weakSelf.authenticatedClient filesWithIDs:projectValue.fileIDs];
        }).then(^(NSArray *fileValues) {
            return [weakSelf treeFilesWithPathPrefix:currentPath fromValues:fileValues];
        }).then(^(NSArray *treeFiles) {
            subFiles = treeFiles;

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
            project.folders = subFolders;
            project.files = subFiles;

            fulfill(project);
        }).catch(^(NSError *error) {
            reject(error);
        });
    }];
}

- (PMKPromise *)treeFoldersWithPathPrefix:(NSString *)pathPrefix
                    organizationPermalink:(NSString *)organizationPermalink
                               fromValues:(NSArray *)folderValues {
    __weak typeof(self) weakSelf = self;
    return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
        NSMutableArray *foldersRequests = @[].mutableCopy;
        for (LVCFolderValue *folder in folderValues) {
            [foldersRequests addObject:[weakSelf treeFolderWithPathPrefix:pathPrefix
                                                    organizationPermalink:organizationPermalink
                                                                fromValue:folder]];
        }
        [PMKPromise when:foldersRequests].then(^(NSArray *folders) {
            fulfill(folders);
        }).catch(^(NSError *error) {
            reject(error);
        });
    }];
}


- (PMKPromise *)treeFolderWithPathPrefix:(NSString *)pathPrefix
                   organizationPermalink:(NSString *)organizationPermalink
                               fromValue:(LVCFolderValue *)folderValues {

    NSString *currentPath = [pathPrefix stringByAppendingPathComponent:folderValues.name];

    __weak typeof(self) weakSelf = self;
    return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {

        __block NSArray *subFolders = @[];
        __block NSArray *subFiles = @[];

        [weakSelf.authenticatedClient foldersWithIDs:folderValues.folderIDs].then(^(NSArray *folderValues) {
            return [weakSelf treeFoldersWithPathPrefix:currentPath organizationPermalink:organizationPermalink fromValues:folderValues];
        }).then(^(NSArray *treeFolders) {
            subFolders = treeFolders;
            return [weakSelf.authenticatedClient filesWithIDs:folderValues.fileIDs];
        }).then(^(NSArray *fileValues) {
            return [weakSelf treeFilesWithPathPrefix:currentPath fromValues:fileValues];
        }).then(^(NSArray *treeFiles) {
            subFiles = treeFiles;

            LVCFolder *folder = [[LVCFolder alloc] init];
            folder.colorLabel = LVCColorWhite;
            folder.name = folderValues.name;
#warning - Both?!?!
            folder.path = currentPath;
            folder.fileURL = [NSURL fileURLWithPath:folder.path];
            folder.organizationPermalink = organizationPermalink;
#warning - Pass organization Value?
//            folder.organizationPermalink = organizationValue.slug;
            folder.dateUpdated = folderValues.dateUpdated;
            folder.url = folderValues.url;
#warning - url path is based on slugs. Best way to calculate it? pass in org here?
//            folder.urlPath = organizationValue.slug;
#warning - Can we actually get dateDeleted?
//            folder.dateDeleted = nil;
            folder.folders = subFolders;
            folder.files = subFiles;

            fulfill(folder);
        }).catch(^(NSError *error) {
            reject(error);
        });
    }];
}


- (PMKPromise *)treeFilesWithPathPrefix:(NSString *)pathPrefix
                             fromValues:(NSArray *)fileValues {
    __weak typeof(self) weakSelf = self;
    return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
        NSMutableArray *filesRequests = @[].mutableCopy;
        for (LVCFileValue *file in fileValues) {
            [filesRequests addObject:[weakSelf treeFileWithPathPrefix:pathPrefix
                                                            fromValue:file]];
        }
        [PMKPromise when:filesRequests].then(^(NSArray *files) {
            fulfill(files);
        }).catch(^(NSError *error) {
            reject(error);
        });
    }];
}


- (PMKPromise *)treeFileWithPathPrefix:(NSString *)pathPrefix
                             fromValue:(LVCFileValue *)fileValue {

    NSString *currentPath = [pathPrefix stringByAppendingPathComponent:fileValue.name];

    __weak typeof(self) weakSelf = self;
    return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
        [weakSelf.authenticatedClient revisionsWithIDs:@[fileValue.lastRevisionID]].then(^(NSArray *revisionValues) {

            if (revisionValues.count > 0) {
                LVCRevisionValue *revisionValue = revisionValues[0];
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
