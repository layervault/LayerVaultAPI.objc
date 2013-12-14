//
//  LVCHTTPClient.h
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 10/13/13.
//  Copyright (c) 2013 codecaffeine. All rights reserved.
//

#import <AFOAuth2Client/AFOAuth2Client.h>
#import "LVCColorUtils.h"
#import "LVCFile.h"

@class LVTUser;
@class LVCOrganization;
@class LVTProject;
@class LVCFolder;
@class LVCFileRevision;

@interface LVCHTTPClient : AFOAuth2Client

- (instancetype)initWithClientID:(NSString *)clientID secret:(NSString *)secret;

#pragma mark - Authentication
- (void)authenticateWithEmail:(NSString *)email
                     password:(NSString *)password
                   completion:(void (^)(AFOAuthCredential *credential, NSError *error))completion;

#pragma mark - User
- (void)getMeWithBlock:(void (^)(LVTUser *user, NSError *error, AFHTTPRequestOperation *operation))block;

#pragma mark - Organizations
- (void)getOrganizationWithParmalink:(NSString *)permalink
                               block:(void (^)(LVCOrganization *organization,
                                               NSError *error,
                                               AFHTTPRequestOperation *operation))block;

#pragma mark - Projects
- (void)getProjectFromPartial:(LVTProject *)project
                   completion:(void (^)(LVTProject *project,
                                        NSError *error,
                                        AFHTTPRequestOperation *operation))block;

- (void)getProjectWithName:(NSString *)projectName
            inOrganization:(LVCOrganization *)organization
                     block:(void (^)(LVTProject *project,
                                     NSError *error,
                                     AFHTTPRequestOperation *operation))block;

- (void)getProjectWithName:(NSString *)projectName
     organizationPermalink:(NSString *)organizationPermalink
                     block:(void (^)(LVTProject *project,
                                     NSError *error,
                                     AFHTTPRequestOperation *operation))block;

- (void)createProjectWithName:(NSString *)projectName
        organizationPermalink:(NSString *)organizationPermalink
                   completion:(void (^)(LVTProject *project,
                                        NSError *error,
                                        AFHTTPRequestOperation *operation))block;

- (void)deleteProject:(LVTProject *)project
           completion:(void (^)(BOOL success,
                                NSError *error,
                                AFHTTPRequestOperation *operation))block;

- (void)moveProject:(LVTProject *)project
      toDestination:(NSString *)destination
         completion:(void (^)(LVTProject *project,
                              NSError *error,
                              AFHTTPRequestOperation *operation))block;

- (void)updateProject:(LVTProject *)project
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
              inProject:(LVTProject *)project
             completion:(void (^)(LVCFolder *folder,
                                  NSError *error,
                                  AFHTTPRequestOperation *operation))completion;


- (void)createFolderAtPath:(NSString *)path
                 inProject:(LVTProject *)project
                completion:(void (^)(LVCFolder *folder,
                                     NSError *error,
                                     AFHTTPRequestOperation *operation))completion;


- (void)deleteFolder:(LVCFolder *)folder
          completion:(void (^)(BOOL success,
                               NSError *error,
                               AFHTTPRequestOperation *operation))completion;


- (void)moveFolder:(LVCFolder *)folder
            toPath:(NSString *)toPath
         inProject:(LVTProject *)project
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
              inProject:(LVTProject *)project
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

- (void)getRevisionsForFile:(LVCFile *)file
                 completion:(void (^)(NSArray *revisions,
                                      NSError *error,
                                      AFHTTPRequestOperation *operation))completion;

- (void)getPreviewURLsForFile:(LVCFile *)file
                        width:(NSUInteger)width
                       height:(NSUInteger)height
                   completion:(void (^)(NSArray *previewURLs,
                                        NSError *error,
                                        AFHTTPRequestOperation *operation))completion;
// TODO: Feedback type
- (void)getFeebackForFile:(LVCFile *)file
                 revision:(NSUInteger)revision
               completion:(void (^)(NSArray *feedback,
                                    NSError *error,
                                    AFHTTPRequestOperation *operation))completion;

- (void)checkSyncStatusForFile:(LVCFile *)file
                    completion:(void (^)(LVCFileSyncStatus syncStatus,
                                         NSError *error,
                                         AFHTTPRequestOperation *operation))completion;

#pragma mark - Revisions
- (void)getRevisionWithNumber:(NSUInteger)revisionNumber
                       ofFile:(LVCFile *)file
                   completion:(void (^)(LVCFileRevision *fileRevision,
                                        NSError *error,
                                        AFHTTPRequestOperation *operation))completion;

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
