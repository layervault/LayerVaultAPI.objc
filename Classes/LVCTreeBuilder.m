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
#import "LVCModelCollection.h"
#import "LVCOrganization.h"
#import "LVCOrganizationCollection.h"
#import "LVCProject.h"
#import "LVCProjectCollection.h"
#import "LVCRevisionCollection.h"
#import "LVCUserCollection.h"
#import "LVCUser.h"
#import "LVCV2AuthenticatedClient.h"

@interface NSArray (LVCUniqueResource)
- (id<LVCResourceUniquing>)lvc_uniqueResourceMatching:(id<LVCResourceUniquing>)resource
                                              ofClass:(Class)class;
@end


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

- (void)buildUserTreeWithPrevious:(LVCUser *)previousUser
                       completion:(void (^)(LVCUser *user, NSError *error))completion {
    __weak typeof(self) weakSelf = self;
    NSDate *startDate = [NSDate date];
    self.authenticatedClient.me.then(^(LVCUserValue *userValue) {
        Class class = [userValue class];
        NSAssert([class conformsToProtocol:@protocol(LVCResourceUniquing)], @"does not conform");
        return [weakSelf userTreeWithPrevious:previousUser
                                    fromValue:userValue];
    }).then(^(LVCUser *user){
        NSLog(@"completed in: %f", [[NSDate date] timeIntervalSinceDate:startDate]);
        completion(user, nil);
    }).catch(^(NSError *error) {
        completion(nil, error);
    });
}

- (PMKPromise *)userTreeWithPrevious:(LVCUser *)previousUser
                           fromValue:(LVCUserValue *)userValue {
    __weak typeof(self) weakSelf = self;

    NSArray *previousOrganizations = [previousUser.organizations copy];

    return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
        [weakSelf.authenticatedClient organizationsWithIDs:userValue.organizationIDs].then(^(NSArray *organizationValues) {
            return [weakSelf organizationsTreesWithPrevious:previousOrganizations
                                                     userID:userValue.uid
                                                 fromValues:organizationValues];
        }).then(^(NSArray *organizations) {

            // Note, always create new user
            LVCUser *user = [[LVCUser alloc] init];
            user.uid = userValue.uid;
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

- (PMKPromise *)organizationsTreesWithPrevious:(NSArray *)previousOrganizations
                                        userID:(NSString *)userID
                                    fromValues:(NSArray *)organizationValues {
    __weak typeof(self) weakSelf = self;
    return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
        // Create Organizations with the projects
        NSMutableArray *organizationRequests = @[].mutableCopy;
        for (LVCOrganizationValue *orgValue in organizationValues) {

            LVCOrganization *previousOrganization = (LVCOrganization *)[previousOrganizations lvc_uniqueResourceMatching:orgValue ofClass:[LVCOrganization class]];

            if ((orgValue.syncType == LVCSyncTypeLayerVault)
                && (orgValue.projectIDs.count > 0)
                && (![orgValue.spectatorIDs containsObject:userID])) {
                [organizationRequests addObject:[weakSelf organizationTreeWithPrevious:previousOrganization
                                                                                userID:userID
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

- (PMKPromise *)organizationTreeWithPrevious:(LVCOrganization *)previousOrganization
                                      userID:(NSString *)userID
                                   fromValue:(LVCOrganizationValue *)organizationValue {
    __weak typeof(self) weakSelf = self;
    return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {

        // if the organization has not changed, then just return it
        if ([organizationValue.dateUpdated isEqualToDate:previousOrganization.dateUpdated]) {
            fulfill(previousOrganization);
        }
        else { // Organization has changed, start loading projects
            [self.authenticatedClient projectsWithIDs:organizationValue.projectIDs].then(^(NSArray *projectValues) {

                return [weakSelf projectTreesWithPrevious:previousOrganization.projects
                                                   member:userID
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
                organization.uid = organizationValue.uid;
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
        }
    }];
}

- (PMKPromise *)projectTreesWithPrevious:(NSArray *)previousProjects
                                  member:(NSString *)userID
                   organizationPermalink:(NSString *)organizationPermalink
                              fromValues:(NSArray *)projectValues {
    __weak typeof(self) weakSelf = self;
    return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
        NSMutableArray *projectRequests = @[].mutableCopy;
        for (LVCProjectValue *projectValue in projectValues) {
            if ([projectValue.userIDs containsObject:userID]) {

                LVCProject *previousProject = (LVCProject *)[previousProjects lvc_uniqueResourceMatching:projectValue ofClass:[LVCProject class]];

                [projectRequests addObject:[weakSelf projectTreeWithPrevious:previousProject
                                                                      member:userID
                                                       organizationPermalink:organizationPermalink
                                                                   fromValue:projectValue]];
            }
        }
        [PMKPromise when:projectRequests].then(^(NSArray *projects) {
            fulfill(projects);
        }).catch(^(NSError *error) {
            reject(error);
        });
    }];
}

- (PMKPromise *)projectTreeWithPrevious:(LVCProject *)previousProject
                                 member:(NSString *)userID
                  organizationPermalink:(NSString *)organizationPermalink
                              fromValue:(LVCProjectValue *)projectValue {

    __weak typeof(self) weakSelf = self;
    return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {

        if ([projectValue.dateUpdated isEqualToDate:previousProject.dateUpdated]) {
            fulfill(previousProject);
        }
        else {

            NSString *currentPath = [[@"~/LayerVault" stringByExpandingTildeInPath] stringByAppendingPathComponent:projectValue.name];

            __block NSArray *subFolders = @[];
            __block NSArray *subFiles = @[];

            [weakSelf.authenticatedClient foldersWithIDs:projectValue.folderIDs].then(^(NSArray *folderValues) {
                
                return [weakSelf folderTreesWithPrevious:previousProject.folders
                                              pathPrefix:currentPath
                                   organizationPermalink:organizationPermalink
                                              fromValues:folderValues];
            }).then(^(NSArray *treeFolders) {
                subFolders = treeFolders;
                return [weakSelf.authenticatedClient filesWithIDs:projectValue.fileIDs];
            }).then(^(NSArray *fileValues) {
                return [weakSelf fileTreesWithPrevious:previousProject.files
                                            pathPrefix:currentPath
                                            fromValues:fileValues];
            }).then(^(NSArray *treeFiles) {
                subFiles = treeFiles;

                LVCProject *project = [[LVCProject alloc] init];
                project.uid = projectValue.uid;
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
        }
    }];
}

- (PMKPromise *)folderTreesWithPrevious:(NSArray *)previousFolders
                             pathPrefix:(NSString *)pathPrefix
                  organizationPermalink:(NSString *)organizationPermalink
                             fromValues:(NSArray *)folderValues {
    __weak typeof(self) weakSelf = self;
    return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
        NSMutableArray *foldersRequests = @[].mutableCopy;
        for (LVCFolderValue *folderValue in folderValues) {

            LVCFolder *previousFolder = (LVCFolder *)[previousFolders lvc_uniqueResourceMatching:folderValue
                                                                                         ofClass:[LVCFolder class]];
            [foldersRequests addObject:[weakSelf folderTreeWithPrevious:previousFolder
                                                             pathPrefix:pathPrefix
                                                  organizationPermalink:organizationPermalink
                                                              fromValue:folderValue]];
        }
        [PMKPromise when:foldersRequests].then(^(NSArray *folders) {
            fulfill(folders);
        }).catch(^(NSError *error) {
            reject(error);
        });
    }];
}


- (PMKPromise *)folderTreeWithPrevious:(LVCFolder *)previousFolder
                            pathPrefix:(NSString *)pathPrefix
                   organizationPermalink:(NSString *)organizationPermalink
                               fromValue:(LVCFolderValue *)folderValue {

    __weak typeof(self) weakSelf = self;
    return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {

        if ([folderValue.dateUpdated isEqualToDate:previousFolder.dateUpdated]) {
            fulfill(previousFolder);
        }
        else {
            NSString *currentPath = [pathPrefix stringByAppendingPathComponent:folderValue.name];

            __block NSArray *subFolders = @[];
            __block NSArray *subFiles = @[];

            [weakSelf.authenticatedClient foldersWithIDs:folderValue.folderIDs].then(^(NSArray *folderValues) {
                return [weakSelf folderTreesWithPrevious:previousFolder.folders
                                              pathPrefix:currentPath
                                   organizationPermalink:organizationPermalink
                                              fromValues:folderValues];
            }).then(^(NSArray *treeFolders) {
                subFolders = treeFolders;
                return [weakSelf.authenticatedClient filesWithIDs:folderValue.fileIDs];
            }).then(^(NSArray *fileValues) {
                return [weakSelf fileTreesWithPrevious:previousFolder.files
                                            pathPrefix:currentPath
                                            fromValues:fileValues];
            }).then(^(NSArray *treeFiles) {
                subFiles = treeFiles;

                LVCFolder *folder = [[LVCFolder alloc] init];
                folder.uid = folderValue.uid;
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
                folder.folders = subFolders;
                folder.files = subFiles;
                
                fulfill(folder);
            }).catch(^(NSError *error) {
                reject(error);
            });
        }
    }];
}


- (PMKPromise *)fileTreesWithPrevious:(NSArray *)previousFiles
                           pathPrefix:(NSString *)pathPrefix
                           fromValues:(NSArray *)fileValues {
    __weak typeof(self) weakSelf = self;
    return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
        NSMutableArray *filesRequests = @[].mutableCopy;
        for (LVCFileValue *fileValue in fileValues) {

            LVCFile *previousFile = (LVCFile *)[previousFiles lvc_uniqueResourceMatching:fileValue
                                                                                 ofClass:[LVCFile class]];

            [filesRequests addObject:[weakSelf fileTreeWithPrevious:previousFile
                                                     pathPrefix:pathPrefix
                                                          fromValue:fileValue]];
        }
        [PMKPromise when:filesRequests].then(^(NSArray *files) {
            fulfill(files);
        }).catch(^(NSError *error) {
            reject(error);
        });
    }];
}


- (PMKPromise *)fileTreeWithPrevious:(LVCFile *)previousFile
                          pathPrefix:(NSString *)pathPrefix
                           fromValue:(LVCFileValue *)fileValue {

    __weak typeof(self) weakSelf = self;
    return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {

        if ([fileValue.dateUpdated isEqualToDate:previousFile.dateUpdated]) {
            fulfill(previousFile);
        }
        else {

            NSString *currentPath = [pathPrefix stringByAppendingPathComponent:fileValue.name];

            [weakSelf.authenticatedClient revisionsWithIDs:@[fileValue.lastRevisionID]].then(^(NSArray *revisionValues) {

                if (revisionValues.count > 0) {
                    LVCRevisionValue *revisionValue = revisionValues[0];
                    LVCFile *file = [[LVCFile alloc] init];
                    file.uid = fileValue.uid;
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
        }
    }];
}

@end

@implementation NSArray (LVCUniqueResource)
- (id<LVCResourceUniquing>)lvc_uniqueResourceMatching:(id<LVCResourceUniquing>)resource
                                              ofClass:(Class<LVCResourceUniquing>)class
{
    id<LVCResourceUniquing> foundResource = nil;
    for (id object in self) {
        // Class doesn't have to conform to protocol... 'cause objc
        if ([object isKindOfClass:class] && [object conformsToProtocol:@protocol(LVCResourceUniquing)]) {
            id<LVCResourceUniquing> currentResource = (id<LVCResourceUniquing>)object;
            if ([currentResource.uid isEqualToString:resource.uid]) {
                foundResource = currentResource;
                break;
            }
        }
    }
    return foundResource;
}
@end

