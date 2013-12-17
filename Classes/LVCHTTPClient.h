//
//  LVCHTTPClient.h
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 10/13/13.
//  Copyright (c) 2013 LayerVault. All rights reserved.
//

#import <AFOAuth2Client/AFOAuth2Client.h>
#import "LVCColorUtils.h"
#import "LVCFile.h"

@class LVCUser;
@class LVCOrganization;
@class LVCProject;
@class LVCFolder;
@class LVCFileRevision;

@interface LVCHTTPClient : AFOAuth2Client

- (instancetype)initWithClientID:(NSString *)clientID secret:(NSString *)secret;

#pragma mark - Authentication
- (void)authenticateWithEmail:(NSString *)email
                     password:(NSString *)password
                   completion:(void (^)(AFOAuthCredential *credential, NSError *error))completion;

#pragma mark - User
- (void)getMeWithBlock:(void (^)(LVCUser *user, NSError *error, AFHTTPRequestOperation *operation))block;

#pragma mark - Organizations
- (void)getOrganizationWithParmalink:(NSString *)permalink
                               block:(void (^)(LVCOrganization *organization,
                                               NSError *error,
                                               AFHTTPRequestOperation *operation))block;

#pragma mark - Projects
- (void)getProjectFromPartial:(LVCProject *)project
                   completion:(void (^)(LVCProject *project,
                                        NSError *error,
                                        AFHTTPRequestOperation *operation))block;

- (void)getProjectWithName:(NSString *)projectName
            inOrganization:(LVCOrganization *)organization
                     block:(void (^)(LVCProject *project,
                                     NSError *error,
                                     AFHTTPRequestOperation *operation))block;

- (void)getProjectWithName:(NSString *)projectName
     organizationPermalink:(NSString *)organizationPermalink
                     block:(void (^)(LVCProject *project,
                                     NSError *error,
                                     AFHTTPRequestOperation *operation))block;

- (void)createProjectWithName:(NSString *)projectName
        organizationPermalink:(NSString *)organizationPermalink
                   completion:(void (^)(LVCProject *project,
                                        NSError *error,
                                        AFHTTPRequestOperation *operation))block;

- (void)deleteProject:(LVCProject *)project
           completion:(void (^)(BOOL success,
                                NSError *error,
                                AFHTTPRequestOperation *operation))block;

- (void)moveProject:(LVCProject *)project
      toDestination:(NSString *)destination
         completion:(void (^)(LVCProject *project,
                              NSError *error,
                              AFHTTPRequestOperation *operation))block;

- (void)updateProject:(LVCProject *)project
           colorLabel:(LVCColorLabel)colorLabel
           completion:(void (^)(BOOL success,
                                NSError *error,
                                AFHTTPRequestOperation *operation))block;

#pragma mark - Folders
- (void)getFolderAtPath:(NSString *)path
             completion:(void (^)(LVCFolder *folder,
                                  NSError *error,
                                  AFHTTPRequestOperation *operation))completion;

- (void)getFolderAtPath:(NSString *)path
              inProject:(LVCProject *)project
             completion:(void (^)(LVCFolder *folder,
                                  NSError *error,
                                  AFHTTPRequestOperation *operation))completion;


- (void)createFolderAtPath:(NSString *)path
                 inProject:(LVCProject *)project
                completion:(void (^)(LVCFolder *folder,
                                     NSError *error,
                                     AFHTTPRequestOperation *operation))completion;


- (void)deleteFolder:(LVCFolder *)folder
          completion:(void (^)(BOOL success,
                               NSError *error,
                               AFHTTPRequestOperation *operation))completion;


- (void)moveFolder:(LVCFolder *)folder
            toPath:(NSString *)toPath
         inProject:(LVCProject *)project
        completion:(void (^)(LVCFolder *folder,
                             NSError *error,
                             AFHTTPRequestOperation *operation))completion;

- (void)updateFolder:(LVCFolder *)folder
          colorLabel:(LVCColorLabel)colorLabel
          completion:(void (^)(BOOL success,
                               NSError *error,
                               AFHTTPRequestOperation *operation))completion;


#pragma mark - Files
- (void)getFileAtPath:(NSString *)filePath
           completion:(void (^)(LVCFile *file,
                                NSError *error,
                                AFHTTPRequestOperation *operation))completion;

- (void)uploadLocalFile:(NSURL *)localFileURL
                 toPath:(NSString *)filePath
              inProject:(LVCProject *)project
             completion:(void (^)(LVCFile *file,
                                  NSError *error,
                                  AFHTTPRequestOperation *operation))completion;

- (void)uploadLocalFile:(NSURL *)localFileURL
                 toPath:(NSString *)filePath
             completion:(void (^)(LVCFile *file,
                                  NSError *error,
                                  AFHTTPRequestOperation *operation))completion;

- (void)deleteFile:(LVCFile *)file
        completion:(void (^)(BOOL success,
                             NSError *error,
                             AFHTTPRequestOperation *operation))completion;


- (void)moveFile:(LVCFile *)file
          toPath:(NSString *)path
     newFileName:(NSString *)newFileName
      completion:(void (^)(BOOL success,
                           NSError *error,
                           AFHTTPRequestOperation *operation))completion;

- (void)getPreviewURLsForFile:(LVCFile *)file
                        width:(NSUInteger)width
                       height:(NSUInteger)height
                   completion:(void (^)(NSArray *previewURLs,
                                        NSError *error,
                                        AFHTTPRequestOperation *operation))completion;

- (void)getFeebackForFile:(LVCFile *)file
                 revision:(NSUInteger)revision
               completion:(void (^)(NSArray *feedback,
                                    NSError *error,
                                    AFHTTPRequestOperation *operation))completion;

- (void)checkSyncStatusForFile:(LVCFile *)file
                    completion:(void (^)(LVCFileSyncStatus syncStatus,
                                         NSError *error,
                                         AFHTTPRequestOperation *operation))completion;


- (void)checkSyncStatusForFileURL:(NSURL *)filePath
                              md5:(NSString *)md5
                       completion:(void (^)(LVCFileSyncStatus syncStatus,
                                            NSError *error,
                                            AFHTTPRequestOperation *operation))completion;

#pragma mark - Revisions
// TODO: FileMetadata type
- (void)getMetaDataForRevision:(LVCFileRevision *)fileRevision
                        ofFile:(LVCFile *)file
                    completion:(void (^)(id fileMetaData,
                                         NSError *error,
                                         AFHTTPRequestOperation *operation))completion;

- (void)getPreviewURLForRevision:(LVCFileRevision *)fileRevision
                          ofFile:(LVCFile *)file
                      completion:(void (^)(NSURL *url,
                                           NSError *error,
                                           AFHTTPRequestOperation *operation))completion;



@end
