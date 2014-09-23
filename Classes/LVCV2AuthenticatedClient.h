//
//  LVCV2AuthenticatedClient.h
//  Pods
//
//  Created by Matt Thomas on 9/17/14.
//
//

#import <AFOAuth2Client/AFOAuth2Client.h>
@class AFOAuthCredential;
@class LVCUserValue;
@class LVCOrganizationCollection;
@class LVCProjectCollection;
@class LVCFolderCollection;
@class LVCFileCollection;
@class MRTRevisionsResponse;
@class PMKPromise;
@class LVCProjectValue;

@interface LVCV2AuthenticatedClient : AFOAuth2Client

@property (nonatomic, readonly) AFOAuthCredential *oAuthCredential;

- (instancetype)initWithBaseURL:(NSURL *)url
                oAuthCredential:(AFOAuthCredential *)oAuthCredential;

#pragma mark - User
- (void)getMeWithCompletion:(void (^)(LVCUserValue *userValue,
                                      NSError *error,
                                      AFHTTPRequestOperation *operation))completion;

#pragma mark - Organizations
- (void)getOrganizationsWithIDs:(NSArray *)organizationIDs
                     completion:(void (^)(LVCOrganizationCollection *organizationCollection,
                                          NSError *error,
                                          AFHTTPRequestOperation *operation))completion;

#pragma mark - Projects
- (void)getProjectsWithIDs:(NSArray *)projectIDs
                completion:(void (^)(LVCProjectCollection *projectCollection,
                                     NSError *error,
                                     AFHTTPRequestOperation *operation))completion;

- (void)createProjectWithName:(NSString *)name
               organizationID:(NSString *)organizationID
                     isPublic:(BOOL)isPublic
                    colorName:(NSString *)colorName
                   completion:(void (^)(LVCProjectCollection *projectCollection,
                                        NSError *error,
                                        AFHTTPRequestOperation *operation))completion;

- (void)updateProject:(LVCProjectValue *)project
           completion:(void (^)(LVCProjectCollection *projectCollection, NSError *error, AFHTTPRequestOperation *operation))completion;

- (void)deleteProject:(LVCProjectValue *)project
           completion:(void (^)(LVCProjectCollection *projectCollection, NSError *error, AFHTTPRequestOperation *operation))completion;

#pragma mark - Folders
- (void)getFoldersWithIDs:(NSArray *)folderIDs
               completion:(void (^)(LVCFolderCollection *folderCollection,
                                    NSError *error,
                                    AFHTTPRequestOperation *operation))completion;

- (void)createFolderWithName:(NSString *)name
                   projectID:(NSString *)projectID
                  completion:(void (^)(LVCFolderCollection *folderCollection,
                                       NSError *error,
                                       AFHTTPRequestOperation *operation))completion;

- (void)createFolderWithName:(NSString *)name
              parentFolderID:(NSString *)parentFolderID
                  completion:(void (^)(LVCFolderCollection *folderCollection,
                                       NSError *error,
                                       AFHTTPRequestOperation *operation))completion;

#pragma mark - Files
- (void)getFilesWithIDs:(NSArray *)fileIDs
             completion:(void (^)(LVCFileCollection *filesCollection,
                                  NSError *error,
                                  AFHTTPRequestOperation *operation))completion;

- (void)createFileWithName:(NSString *)name
                 projectID:(NSString *)projectID
                completion:(void (^)(LVCFileCollection *filesCollection,
                                     NSError *error,
                                     AFHTTPRequestOperation *operation))completion;

- (void)createFileWithName:(NSString *)name
            parentFolderID:(NSString *)parentFolderID
                completion:(void (^)(LVCFileCollection *filesCollection,
                                     NSError *error,
                                     AFHTTPRequestOperation *operation))completion;

#pragma mark - Revisions
- (void)getRevisionsWithIDs:(NSArray *)revisionIDs
             completion:(void (^)(MRTRevisionsResponse *revisionsResponse,
                                  NSError *error,
                                  AFHTTPRequestOperation *operation))completion;

- (void)createRevisionForFileID:(NSString *)fileID
                            md5:(NSString *)md5
                      remoteURL:(NSURL *)remoteURL
                      parentMD5:(NSString *)parentMD5
                     completion:(void (^)(MRTRevisionsResponse *revisionsResponse,
                                          NSError *error,
                                          AFHTTPRequestOperation *operation))completion;

#pragma mark - S3
- (void)generateS3ResourceForPath:(NSString *)path
                           bucket:(NSString *)bucket
                      maxFileSize:(NSString *)maxFileSize
                       completion:(void (^)(NSDictionary *responseParams,
                                            NSError *error,
                                            AFHTTPRequestOperation *operation))completion;
@end

@interface LVCV2AuthenticatedClient (PromiseKit)
- (PMKPromise *)me;

- (PMKPromise *)organizationsWithIDs:(NSArray *)organizationIDs;

- (PMKPromise *)projectsWithIDs:(NSArray *)projectIDs;

- (PMKPromise *)createProjectWithName:(NSString *)name
                       organizationID:(NSString *)organizationID
                             isPublic:(BOOL)isPublic
                            colorName:(NSString *)colorName;

- (PMKPromise *)foldersWithIDs:(NSArray *)folderIDs;

- (PMKPromise *)createFolderWithName:(NSString *)name
                           projectID:(NSString *)projectID;

- (PMKPromise *)createFolderWithName:(NSString *)name
                      parentFolderID:(NSString *)parentFolderID;

- (PMKPromise *)filesWithIDs:(NSArray *)fileIDs;

- (PMKPromise *)createFileWithName:(NSString *)name
                         projectID:(NSString *)projectID;

- (PMKPromise *)createFileWithName:(NSString *)name
                    parentFolderID:(NSString *)parentFolderID;

- (PMKPromise *)revisionsWithIDs:(NSArray *)revisionIDs;

- (PMKPromise *)createRevisionForFileID:(NSString *)fileID
                                    md5:(NSString *)md5
                              remoteURL:(NSURL *)remoteURL
                              parentMD5:(NSString *)parentMD5;

- (PMKPromise *)generateS3ResourceForPath:(NSString *)path
                                   bucket:(NSString *)bucket
                              maxFileSize:(NSString *)maxFileSize;

- (PMKPromise *)uploadFile:(NSURL *)fileURL
                parameters:(NSDictionary *)parameters;

@end
