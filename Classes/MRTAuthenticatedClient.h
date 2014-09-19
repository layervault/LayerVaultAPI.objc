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

@interface MRTAuthenticatedClient : AFOAuth2Client

@property (nonatomic, readonly) AFOAuthCredential *oAuthCredential;

- (instancetype)initWithBaseURL:(NSURL *)url
                oAuthCredential:(AFOAuthCredential *)oAuthCredential;

- (void)getMeWithCompletion:(void (^)(MRTUserResponse *userResponse,
                                      NSError *error,
                                      AFHTTPRequestOperation *operation))completion;

- (void)getOrganizationsWithIDs:(NSArray *)organizationIDs
                     completion:(void (^)(MRTOrganizationsResponse *organizationsResponse,
                                          NSError *error,
                                          AFHTTPRequestOperation *operation))completion;

- (void)getProjectsWithIDs:(NSArray *)projectIDs
                completion:(void (^)(MRTProjectsResponse *projectsResponse,
                                     NSError *error,
                                     AFHTTPRequestOperation *operation))completion;

- (void)getFoldersWithIDs:(NSArray *)folderIDs
               completion:(void (^)(MRTFoldersResponse *foldersResponse,
                                    NSError *error,
                                    AFHTTPRequestOperation *operation))completion;

- (void)getFilesWithIDs:(NSArray *)fileIDs
             completion:(void (^)(MRTFilesResponse *filesResponse,
                                  NSError *error,
                                  AFHTTPRequestOperation *operation))completion;

- (void)getRevisionsWithIDs:(NSArray *)revisionIDs
             completion:(void (^)(MRTRevisionsResponse *revisionsResponse,
                                  NSError *error,
                                  AFHTTPRequestOperation *operation))completion;
@end

@interface MRTAuthenticatedClient (PromiseKit)
- (PMKPromise *)me;
- (PMKPromise *)organizationsWithIDs:(NSArray *)organizationIDs;
- (PMKPromise *)projectsWithIDs:(NSArray *)projectIDs;
- (PMKPromise *)foldersWithIDs:(NSArray *)folderIDs;
- (PMKPromise *)filesWithIDs:(NSArray *)fileIDs;
- (PMKPromise *)revisionsWithIDs:(NSArray *)revisionIDs;
@end
