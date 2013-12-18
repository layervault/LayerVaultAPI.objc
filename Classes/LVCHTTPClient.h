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

/**
 *  Create a new LayerVault HTTP Client instance
 *
 *  @param clientID The OAuth Client ID
 *  @param secret   The OAuth Client Secret
 *
 *  @return A new LayerVault HTTP Client instance
 */
- (instancetype)initWithClientID:(NSString *)clientID secret:(NSString *)secret;


/*************************
   @name Authentication
 *************************/

/**
 *  Authenticates using an email and password. Completion block returns an
 *  OAuth credential if successful or nil if it fails. The error describes why 
 *  the request failed.
 *
 *  @param email      User's email for authentication
 *  @param password   User's password for authentication
 *  @param completion Callback that returns an OAuth credential on success, or 
 *                    nil on failure with an error
 */
- (void)authenticateWithEmail:(NSString *)email
                     password:(NSString *)password
                   completion:(void (^)(AFOAuthCredential *credential,
                                        NSError *error))completion;


/***************
   @name User
 ***************/

/**
 *  Get the current authenticated user's info including name, email, 
 *  organizations and projects.
 *
 *  @param completion Callback that returns a User on success, or nil on 
 *         failure with an error
 */
- (void)getMeWithCompletion:(void (^)(LVCUser *user,
                                      NSError *error,
                                      AFHTTPRequestOperation *operation))completion;


/***********************
   @name Organizations
 ***********************/

/**
 *  Returns an organization given a permalink string.
 *
 *  @param permalink    Permalink string for organization
 *  @param completion   Callback that returns an Organization on success, or 
 *                      nil on failure with an error
 */
- (void)getOrganizationWithParmalink:(NSString *)permalink
                               block:(void (^)(LVCOrganization *organization,
                                               NSError *error,
                                               AFHTTPRequestOperation *operation))block;

/******************
   @name Projects
 ******************/

/**
 *  The projects returned by /me and /:organization_permalink only contain 
 *  partial information. They don't contain the fil hierarchy. This method will 
 *  update a project with partial information with the full project information.
 *
 *  @param project      Project with partial information to update
 *  @param completion   Callback that returns a Project on success, or nil on
 *                      failure with an error
 */
- (void)getProjectFromPartial:(LVCProject *)project
                   completion:(void (^)(LVCProject *project,
                                        NSError *error,
                                        AFHTTPRequestOperation *operation))completion;

/**
 *  Returns a project given a project name and organization permalink
 *
 *  @param projectName           The name of the project to return
 *  @param organizationPermalink The organization-permalink used to look up the 
 *                               project
 *  @param completion            Callback that returns a Project on success, or
 *                               nil on failure with an error
 */
- (void)getProjectWithName:(NSString *)projectName
     organizationPermalink:(NSString *)organizationPermalink
                completion:(void (^)(LVCProject *project,
                                     NSError *error,
                                     AFHTTPRequestOperation *operation))completion;

/**
 *  Creates a new project with a given name inside of an organization.
 *
 *  @param projectName           The name of the new project
 *  @param organizationPermalink The organization permalink of the new project
 *  @param completion            Callback that returns a new Project on success, 
 *                               or nil on failure with an error
 */
- (void)createProjectWithName:(NSString *)projectName
        organizationPermalink:(NSString *)organizationPermalink
                   completion:(void (^)(LVCProject *project,
                                        NSError *error,
                                        AFHTTPRequestOperation *operation))completion;

/**
 *  Deletes a given project.
 *
 *  @param project      The Project to delete.
 *  @param completion   Callback that returns YES on successful deletion, or NO 
 *                      with an error if the project could not be deleted.
 */
- (void)deleteProject:(LVCProject *)project
           completion:(void (^)(BOOL success,
                                NSError *error,
                                AFHTTPRequestOperation *operation))completion;

/**
 *  Renames a project to a new name.
 *
 *  @param project    The Project to rename
 *  @param newName    The new name for the project
 *  @param completion Callback that returns the Project with it's new name on 
 *                    success, or nil on failure with an error
 */
- (void)renameProject:(LVCProject *)project
              newName:(NSString *)newName
           completion:(void (^)(LVCProject *project,
                                NSError *error,
                                AFHTTPRequestOperation *operation))completion;

/**
 *  Update the color label for a project. This is equivalent to the label or 
 *  tag attribute on OS X, and will display the color on the website.
 *
 *  @param project    The project to change the color label to.
 *  @param colorLabel The new color label.
 *  @param completion Callback that returns YES if the color change succeeded, 
 *                    or NO with an error if color change failed
 */
- (void)updateProject:(LVCProject *)project
           colorLabel:(LVCColorLabel)colorLabel
           completion:(void (^)(BOOL success,
                                NSError *error,
                                AFHTTPRequestOperation *operation))completion;

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
- (void)getMetaDataForFileRevision:(LVCFileRevision *)fileRevision
                        completion:(void (^)(id fileMetaData,
                                             NSError *error,
                                             AFHTTPRequestOperation *operation))completion;

- (void)getPreviewURLsForRevision:(LVCFileRevision *)fileRevision
                            width:(NSUInteger)width
                           height:(NSUInteger)height
                       completion:(void (^)(NSArray *urls,
                                            NSError *error,
                                            AFHTTPRequestOperation *operation))completion;



@end
