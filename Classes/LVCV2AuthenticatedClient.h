//
//  MRTAuthenticatedClient.h
//  Pods
//
//  Created by Matt Thomas on 9/17/14.
//
//

#import <AFOAuth2Client/AFOAuth2Client.h>
@class AFOAuthCredential;
@class MRTUserResponse;
@class MRTOrganizationsResponse;
@class MRTProjectsResponse;
@class MRTFoldersResponse;
@class MRTFilesResponse;
@class MRTRevisionsResponse;
@class PMKPromise;
@class MRTProjectResponse;

@interface MRTAuthenticatedClient : AFOAuth2Client

@property (nonatomic, readonly) AFOAuthCredential *oAuthCredential;

- (instancetype)initWithBaseURL:(NSURL *)url
                oAuthCredential:(AFOAuthCredential *)oAuthCredential;

#pragma mark - User
- (void)getMeWithCompletion:(void (^)(MRTUserResponse *userResponse,
                                      NSError *error,
                                      AFHTTPRequestOperation *operation))completion;

#pragma mark - Organizations
- (void)getOrganizationsWithIDs:(NSArray *)organizationIDs
                     completion:(void (^)(MRTOrganizationsResponse *organizationsResponse,
                                          NSError *error,
                                          AFHTTPRequestOperation *operation))completion;

#pragma mark - Projects
- (void)getProjectsWithIDs:(NSArray *)projectIDs
                completion:(void (^)(MRTProjectsResponse *projectsResponse,
                                     NSError *error,
                                     AFHTTPRequestOperation *operation))completion;

- (void)createProjectWithName:(NSString *)name
               organizationID:(NSString *)organizationID
                     isPublic:(BOOL)isPublic
                    colorName:(NSString *)colorName
                   completion:(void (^)(MRTProjectsResponse *projectsResponse,
                                        NSError *error,
                                        AFHTTPRequestOperation *operation))completion;

- (void)updateProject:(MRTProjectResponse *)project
           completion:(void (^)(MRTProjectsResponse *projectsResponse, NSError *error, AFHTTPRequestOperation *operation))completion;

- (void)deleteProject:(MRTProjectResponse *)project
           completion:(void (^)(MRTProjectsResponse *projectsResponse, NSError *error, AFHTTPRequestOperation *operation))completion;

#pragma mark - Folders
- (void)getFoldersWithIDs:(NSArray *)folderIDs
               completion:(void (^)(MRTFoldersResponse *foldersResponse,
                                    NSError *error,
                                    AFHTTPRequestOperation *operation))completion;

- (void)createFolderWithName:(NSString *)name
                   projectID:(NSString *)projectID
                  completion:(void (^)(MRTFoldersResponse *foldersResponse,
                                       NSError *error,
                                       AFHTTPRequestOperation *operation))completion;

- (void)createFolderWithName:(NSString *)name
              parentFolderID:(NSString *)parentFolderID
                  completion:(void (^)(MRTFoldersResponse *foldersResponse,
                                       NSError *error,
                                       AFHTTPRequestOperation *operation))completion;

#pragma mark - Files
- (void)getFilesWithIDs:(NSArray *)fileIDs
             completion:(void (^)(MRTFilesResponse *filesResponse,
                                  NSError *error,
                                  AFHTTPRequestOperation *operation))completion;

- (void)createFileWithName:(NSString *)name
                 projectID:(NSString *)projectID
                completion:(void (^)(MRTFilesResponse *filesResponse,
                                     NSError *error,
                                     AFHTTPRequestOperation *operation))completion;

- (void)createFileWithName:(NSString *)name
            parentFolderID:(NSString *)parentFolderID
                completion:(void (^)(MRTFilesResponse *filesResponse,
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

@interface MRTAuthenticatedClient (PromiseKit)
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
