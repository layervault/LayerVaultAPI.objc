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


/********************
 @name Authentication
 ********************/

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


/**********
 @name User
 **********/

/**
 *  Get the current authenticated user's info including name, email, 
 *  organizations and projects.
 *
 *  @param completion Callback that returns an LVCUser on success, or nil on
 *         failure with an error
 */
- (void)getMeWithCompletion:(void (^)(LVCUser *user,
                                      NSError *error,
                                      AFHTTPRequestOperation *operation))completion;


/*******************
 @name Organizations
 *******************/

/**
 *  Returns an organization given a permalink string.
 *
 *  @param permalink    Permalink string for organization
 *  @param completion   Callback that returns an LVCOrganization on success, or
 *                      nil on failure with an error
 */
- (void)getOrganizationWithParmalink:(NSString *)permalink
                               block:(void (^)(LVCOrganization *organization,
                                               NSError *error,
                                               AFHTTPRequestOperation *operation))block;

/**************
 @name Projects
 **************/

/**
 *  The projects returned by /me and /:organization-permalink only contain
 *  partial information. They don't contain the fil hierarchy. This method will 
 *  update a project with partial information with the full project information.
 *
 *  @param project      Project with partial information to update
 *  @param completion   Callback that returns an LVCProject on success, or nil
 *                      on failure with an error
 */
- (void)getProjectFromPartial:(LVCProject *)project
                   completion:(void (^)(LVCProject *project,
                                        NSError *error,
                                        AFHTTPRequestOperation *operation))completion;

/**
 *  Returns a project given a project name and organization-permalink
 *
 *  @param projectName           The name of the project to return
 *  @param organizationPermalink The organization-permalink used to look up the 
 *                               project
 *  @param completion            Callback that returns an LVCProject on success, 
 *                               or nil on failure with an error
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
 *  @param organizationPermalink The organization-permalink of the new project
 *  @param completion            Callback that returns a new LVCProject on 
 *                               success, or nil on failure with an error
 */
- (void)createProjectWithName:(NSString *)projectName
        organizationPermalink:(NSString *)organizationPermalink
                   completion:(void (^)(LVCProject *project,
                                        NSError *error,
                                        AFHTTPRequestOperation *operation))completion;

/**
 *  Deletes a given project and any of it's contents.
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
 *  @param completion Callback that returns an LVCProject with it's new name on
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
 *  @param project    LVCProject to change the color label
 *  @param colorLabel New color label
 *  @param completion Callback that returns YES if the color change succeeded, 
 *                    or NO with an error if color change failed
 */
- (void)updateProject:(LVCProject *)project
           colorLabel:(LVCColorLabel)colorLabel
           completion:(void (^)(BOOL success,
                                NSError *error,
                                AFHTTPRequestOperation *operation))completion;


/*************
 @name Folders
 *************/

/**
 *  Returns a folder given a full folder path including organization-permalink
 *  and project.
 *
 *  @param path       Folder path including organization-permalink (should not 
 *                    be URL encoded)
 *  @param completion Callback that returns an LVCFolde on success, or nil on
 *                    failure with an error
 */
- (void)getFolderAtPath:(NSString *)path
             completion:(void (^)(LVCFolder *folder,
                                  NSError *error,
                                  AFHTTPRequestOperation *operation))completion;

/**
 *  Returns a folder given a path within a specified project.
 *
 *  @param path       Path relative to project
 *  @param project    LVCProject that contains the path
 *  @param completion Callback that returns an LVCFolder on success, or nil on
 *                    failure with an error
 */
- (void)getFolderAtPath:(NSString *)path
              inProject:(LVCProject *)project
             completion:(void (^)(LVCFolder *folder,
                                  NSError *error,
                                  AFHTTPRequestOperation *operation))completion;


#warning Verify
/**
 *  Create a folder at a given path within a specified Project. This will 
 *  create any intermediate folders if needed.
 *
 *  @param path       Path relative to project
 *  @param project    Project where new folder will be created.
 *  @param completion Callback that returns the LVCFolder if it was created
 *                    successfully, or nil with an error if the folder could 
 *                    not be created
 */
- (void)createFolderAtPath:(NSString *)path
                 inProject:(LVCProject *)project
                completion:(void (^)(LVCFolder *folder,
                                     NSError *error,
                                     AFHTTPRequestOperation *operation))completion;


/**
 *  Deletes a given folder and all of it's contents.
 *
 *  @param folder     Folder to delete
 *  @param completion Callback that return YES on successful deletion, or NO
 *                    with an error if the folder could not be deleted
 */
- (void)deleteFolder:(LVCFolder *)folder
          completion:(void (^)(BOOL success,
                               NSError *error,
                               AFHTTPRequestOperation *operation))completion;

#warning verify
/**
 *  Move a folder to a new path. This move is permitted across different 
 *  projects, but it has to be within the same Organization.
 *
 *  @param folder     LVCFolder to move
 *  @param toPath     New folder path (excluding organization-permalink)
 *  @param project    New LVCProject or nil if toPath is within the same 
 *                    LVCProject
 *  @param completion Callback that returns the LVCFolder on successful move, or
 *                    nil with an error if the move failed
 */
- (void)moveFolder:(LVCFolder *)folder
            toPath:(NSString *)toPath
         inProject:(LVCProject *)project
        completion:(void (^)(LVCFolder *folder,
                             NSError *error,
                             AFHTTPRequestOperation *operation))completion;

/**
 *  Update the color label for a folder. This is equivalent to the label or
 *  tag attribute on OS X.
 *
 *  @param folder     LVCFolder of which to change the color label
 *  @param colorLabel New color label
 *  @param completion Callback that returns YES if the color change succeeded,
 *                    or NO with an error if color change failed
 */
- (void)updateFolder:(LVCFolder *)folder
          colorLabel:(LVCColorLabel)colorLabel
          completion:(void (^)(BOOL success,
                               NSError *error,
                               AFHTTPRequestOperation *operation))completion;


/***************
 @name Files
 ***************/

/**
 *  Returns a folder given a full file path including organization-permalink
 *  and project.
 *
 *  @param filePath   File path including organization-permalink (should not be 
 *                    URL encoded)
 *  @param completion Callback that returns an LVCFile on success, or nil on
 *                    failure with an error
 */
- (void)getFileAtPath:(NSString *)filePath
           completion:(void (^)(LVCFile *file,
                                NSError *error,
                                AFHTTPRequestOperation *operation))completion;

/**
 *  Uploads a local file to a full file path including organization-permalink
 *  and project. The file must be an image type (including Sketch and 
 *  OmniGraffle). Any intermediate folder needed will be created.
 *
 *  @param localFileURL Local file URL to upload
 *  @param filePath     File path including organization-permalink (should not
 *                      be URL encoded)
 *  @param completion   Callback that returns an LVCFile on successful upload, 
 *                      or nil on failure with an error
 */
- (void)uploadLocalFile:(NSURL *)localFileURL
                 toPath:(NSString *)filePath
             completion:(void (^)(LVCFile *file,
                                  NSError *error,
                                  AFHTTPRequestOperation *operation))completion;

/**
 *  Upload a local file to a path inside a project. The file must be an image
 *  type (including Sketch and OmniGraffle). Any intermediate folder needed 
 *  will be created.
 *
 *  @param localFileURL Local file URL to upload
 *  @param filePath     Path inside project to upload the file to
 *  @param project      LVCProject the file will be uploaded to
 *  @param completion   Callback that returns an LVCFile on successful upload, 
 *                      or nil on failure with an error
 */
- (void)uploadLocalFile:(NSURL *)localFileURL
                 toPath:(NSString *)filePath
              inProject:(LVCProject *)project
             completion:(void (^)(LVCFile *file,
                                  NSError *error,
                                  AFHTTPRequestOperation *operation))completion;

/**
 *  Deletes a given file.
 *
 *  @param file       LVCFile to delete
 *  @param completion Callback that return YES on successful deletion, or NO
 *                    with an error if the file could not be deleted
 */
- (void)deleteFile:(LVCFile *)file
        completion:(void (^)(BOOL success,
                             NSError *error,
                             AFHTTPRequestOperation *operation))completion;

/**
 *  Move file to a new location within the organization.
 *
 *  @param file        LVCFile to move
 *  @param path        New path within the LVCOrganization (excluding
 *                     organization-permalink)
 *  @param newFileName New filename, or nil to preserve filename
 *  @param completion  Callback that return YES on successful move, or NO
 *                     with an error if the file could not be moved
 */
- (void)moveFile:(LVCFile *)file
          toPath:(NSString *)path
     newFileName:(NSString *)newFileName
      completion:(void (^)(BOOL success,
                           NSError *error,
                           AFHTTPRequestOperation *operation))completion;

/**
 *  Get all the preview URLs across all the revisions for a given file. The 
 *  preview images will maintain their aspect ratio while not exceeding the max 
 *  width or height.
 *
 *  @param file       LVCFile to get the previews for
 *  @param width      Max width of the previews
 *  @param height     Max height of the previews
 *  @param completion Callback that return an array of NSURLs on success, or nil
 *                    with an error of failure
 */
- (void)getPreviewURLsForFile:(LVCFile *)file
                        width:(NSUInteger)width
                       height:(NSUInteger)height
                   completion:(void (^)(NSArray *previewURLs,
                                        NSError *error,
                                        AFHTTPRequestOperation *operation))completion;

/**
 *  Get all the feedback for a file at a specific revision.
 *
 *  @param file       LVCFile to get the feedback for
 *  @param revision   File revision number to get the feedback for.
 *  @param completion Callback that return an array of LVCFileRevisionFeedback 
 *                    on success, or nil with an error of failure
 */
- (void)getFeebackForFile:(LVCFile *)file
                 revision:(NSUInteger)revision
               completion:(void (^)(NSArray *feedback,
                                    NSError *error,
                                    AFHTTPRequestOperation *operation))completion;

/**
 *  Check the sync status of a file against an MD5.
 *
 *  @param filePath   File path including organization-permalink (should not be
 *                    URL encoded)
 *  @param md5        New md5 we're comparing against
 *  @param completion Callback that return a LVCFileSyncStatus. An error will 
 *                    be returned in each case except LVCFileSyncStatusUploadOK
 */
- (void)checkSyncStatusForFilePath:(NSString *)filePath
                               md5:(NSString *)md5
                        completion:(void (^)(LVCFileSyncStatus syncStatus,
                                             NSError *error,
                                             AFHTTPRequestOperation *operation))completion;

/**
 *  Check the sync status of a LVCFile.
 *
 *  @param file       File we are comparing against the server with.
 *  @param completion Callback that return a LVCFileSyncStatus. An error will
 *                    be returned in each case except LVCFileSyncStatusUploadOK
 */
- (void)checkSyncStatusForFile:(LVCFile *)file
                    completion:(void (^)(LVCFileSyncStatus syncStatus,
                                         NSError *error,
                                         AFHTTPRequestOperation *operation))completion;


/*******************
 @name File Revision
 *******************/

// TODO: FileMetadata type
/**
 *  Get metadata for a specific file revision
 *
 *  @param fileRevision LVCFileRevision we want the metadata for
 *  @param completion   Callback that returns file metadata. This may be nil if
 *                      LayerVault doesn't
 */
- (void)getMetaDataForFileRevision:(LVCFileRevision *)fileRevision
                        completion:(void (^)(id fileMetaData,
                                             NSError *error,
                                             AFHTTPRequestOperation *operation))completion;

/**
 *  Get preview URLs for a specific file revision.
 *
 *  @param fileRevision LVCFileRevision
 *  @param width        Max width of the previews
 *  @param height       Max height of the previews
 *  @param completion   Callback that return an array of NSURLs on success, or 
 *                      nil with an error of failure
 */
- (void)getPreviewURLsForRevision:(LVCFileRevision *)fileRevision
                            width:(NSUInteger)width
                           height:(NSUInteger)height
                       completion:(void (^)(NSArray *urls,
                                            NSError *error,
                                            AFHTTPRequestOperation *operation))completion;



@end
