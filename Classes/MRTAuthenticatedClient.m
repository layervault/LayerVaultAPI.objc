//
//  MRTAuthenticatedClient.m
//  Pods
//
//  Created by Matt Thomas on 9/17/14.
//
//

#import "MRTAuthenticatedClient.h"
#import <AFNetworking/AFNetworking.h>
#import <PromiseKit/PromiseKit.h>
#import "MRTUsersResponse.h"
#import "MRTOrganizationsResponse.h"
#import "MRTProjectsResponse.h"
#import "MRTFoldersResponse.h"
#import "MRTFilesResponse.h"
#import "MRTRevisionsResponse.h"
#import "LVCOrganization.h"
#import "LVCProject.h"


@implementation MRTAuthenticatedClient

- (instancetype)initWithBaseURL:(NSURL *)url
                oAuthCredential:(AFOAuthCredential *)oAuthCredential
{
    self = [super initWithBaseURL:url];
    if (self) {
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [self setDefaultHeader:@"Accept" value:@"application/vnd.api+json"];
        [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"application/vnd.api+json"]];
        self.parameterEncoding = AFJSONParameterEncoding;
        _oAuthCredential = oAuthCredential;
        [self setAuthorizationHeaderWithCredential:oAuthCredential];
    }
    return self;
}

- (void)getMeWithCompletion:(void (^)(MRTUserResponse *userResponse,
                                      NSError *error,
                                      AFHTTPRequestOperation *operation))completion
{
    NSParameterAssert(completion);

    [self getPath:@"me" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error = nil;
        MRTUserResponse *userResponse = nil;

        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *responseDict = (NSDictionary *)responseObject;
            NSArray *users = responseDict[@"users"];
            if ((users.count == 1) && [users[0] isKindOfClass:[NSDictionary class]]) {
                NSDictionary *userDict = users[0];
                userResponse = [MTLJSONAdapter modelOfClass:[MRTUserResponse class]
                                         fromJSONDictionary:userDict
                                                      error:&error];
            }
            else {
                /// TODO: Unable to find users
            }
        }
        else {
            /// TODO: Unexpected object return type
        }

        completion(userResponse, error, operation);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error, operation);
    }];
}

- (void)getOrganizationsWithIDs:(NSArray *)organizationIDs
                     completion:(void (^)(MRTOrganizationsResponse *organizationsResponse,
                                          NSError *error,
                                          AFHTTPRequestOperation *operation))completion
{
    [self getCollectionOfClass:[MRTOrganizationsResponse class]
                   resourceKey:@"organizations"
                       withIDs:organizationIDs
                    completion:completion];
}

- (void)getProjectsWithIDs:(NSArray *)projectIDs
                completion:(void (^)(MRTProjectsResponse *projectsResponse,
                                     NSError *error,
                                     AFHTTPRequestOperation *operation))completion
{
    [self getCollectionOfClass:[MRTProjectsResponse class]
                   resourceKey:@"projects"
                       withIDs:projectIDs
                    completion:completion];
}

- (void)createProjectWithName:(NSString *)name
               organizationID:(NSString *)organizationID
                     isPublic:(BOOL)isPublic
                    colorName:(NSString *)colorName
                   completion:(void (^)(MRTProjectsResponse *projectsResponse,
                                        NSError *error,
                                        AFHTTPRequestOperation *operation))completion
{
    [self createResourceWithCollectionClass:[MRTProjectsResponse class]
                                resourceKey:@"projects"
                               resourceInfo:@{@"name": name,
                                              @"is_public": @(isPublic),
                                              @"color": colorName,
                                              @"links": @{@"organization": organizationID}}
                                 completion:completion];
}

- (void)updateProject:(MRTProjectResponse *)project
           completion:(void (^)(MRTProjectsResponse *projectsResponse, NSError *error, AFHTTPRequestOperation *operation))completion
{

}

- (void)deleteProject:(MRTProjectResponse *)project
           completion:(void (^)(MRTProjectsResponse *projectsResponse, NSError *error, AFHTTPRequestOperation *operation))completion
{

}

- (void)getFoldersWithIDs:(NSArray *)folderIDs
               completion:(void (^)(MRTFoldersResponse *foldersResponse,
                                    NSError *error,
                                    AFHTTPRequestOperation *operation))completion
{
    [self getCollectionOfClass:[MRTFoldersResponse class]
                   resourceKey:@"folders"
                       withIDs:folderIDs
                    completion:completion];
}

- (void)createFolderWithName:(NSString *)name
                   projectID:(NSString *)projectID
                  completion:(void (^)(MRTFoldersResponse *foldersResponse,
                                       NSError *error,
                                       AFHTTPRequestOperation *operation))completion
{
    [self createResourceWithCollectionClass:[MRTFoldersResponse class]
                                resourceKey:@"folders"
                               resourceInfo:@{@"name": name,
                                              @"links": @{@"project": projectID}}
                                 completion:completion];
}

- (void)createFolderWithName:(NSString *)name
              parentFolderID:(NSString *)parentFolderID
                  completion:(void (^)(MRTFoldersResponse *foldersResponse,
                                       NSError *error,
                                       AFHTTPRequestOperation *operation))completion
{
    [self createResourceWithCollectionClass:[MRTFoldersResponse class]
                                resourceKey:@"folders"
                               resourceInfo:@{@"name": name,
                                              @"links": @{@"parent_folder": parentFolderID}}
                                 completion:completion];
}

- (void)getFilesWithIDs:(NSArray *)fileIDs
             completion:(void (^)(MRTFilesResponse *filesResponse,
                                  NSError *error,
                                  AFHTTPRequestOperation *operation))completion
{
    [self getCollectionOfClass:[MRTFilesResponse class]
                   resourceKey:@"files"
                       withIDs:fileIDs
                    completion:completion];
}

- (void)createFileWithName:(NSString *)name
                 projectID:(NSString *)projectID
                completion:(void (^)(MRTFilesResponse *filesResponse,
                                     NSError *error,
                                     AFHTTPRequestOperation *operation))completion
{
    [self createResourceWithCollectionClass:[MRTFilesResponse class]
                                resourceKey:@"files"
                               resourceInfo:@{@"name": name,
                                              @"links": @{@"project": projectID}}
                                 completion:completion];
}

- (void)createFileWithName:(NSString *)name
            parentFolderID:(NSString *)parentFolderID
                completion:(void (^)(MRTFilesResponse *filesResponse,
                                     NSError *error,
                                     AFHTTPRequestOperation *operation))completion
{
    [self createResourceWithCollectionClass:[MRTFilesResponse class]
                                resourceKey:@"files"
                               resourceInfo:@{@"name": name,
                                              @"links": @{@"folder": parentFolderID}}
                                 completion:completion];
}

- (void)getRevisionsWithIDs:(NSArray *)revisionIDs
                 completion:(void (^)(MRTRevisionsResponse *revisionsResponse,
                                      NSError *error,
                                      AFHTTPRequestOperation *operation))completion
{
    [self getCollectionOfClass:[MRTRevisionsResponse class]
                   resourceKey:@"revisions"
                       withIDs:revisionIDs
                    completion:completion];
}

- (void)createRevisionForFileID:(NSString *)fileID
                            md5:(NSString *)md5
                      remoteURL:(NSURL *)remoteURL
                      parentMD5:(NSString *)parentMD5
                     completion:(void (^)(MRTRevisionsResponse *revisionsResponse,
                                          NSError *error,
                                          AFHTTPRequestOperation *operation))completion
{
    NSDictionary *dict = @{@"md5": md5,
                           @"remoteURL": [remoteURL absoluteString],
                           @"links": @{@"file": fileID}};
    if (parentMD5.length > 0) {
        NSMutableDictionary *mDict = dict.mutableCopy;
        mDict[@"parent_md5"] = parentMD5;
        dict = mDict.copy;
    }
    [self createResourceWithCollectionClass:[MRTFilesResponse class]
                                resourceKey:@"revisions"
                               resourceInfo:dict
                                 completion:completion];
}

#pragma mark - Generic Methods
- (void)createResourceWithCollectionClass:(Class)class
                              resourceKey:(NSString *)resourceKey
                             resourceInfo:(NSDictionary *)resourceInfo
                               completion:(void (^)(id resourceCollectionResponse,
                                                    NSError *error,
                                                    AFHTTPRequestOperation *operation))completion
{
    NSString *mime = @"application/vnd.api+json";
    NSDictionary *params = @{@"Content-Type": mime};

    /// TODO: Ugly
    NSDictionary *dict = @{resourceKey: @[resourceInfo]};
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict
                                                   options:0
                                                     error:&error];

    NSMutableURLRequest *request = [self requestWithMethod:@"POST" path:resourceKey parameters:params];
    [request setValue:mime forHTTPHeaderField:@"Content-Type"];
    request.HTTPBody = data;

    AFHTTPRequestOperation *op = [self HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error;
        id resourceResponse = [MRTAuthenticatedClient parseCollectionResponse:responseObject
                                                                      ofClass:class
                                                                  resourceKey:resourceKey
                                                                        error:&error];
        completion(resourceResponse, error, operation);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error, operation);
    }];
    [self enqueueHTTPRequestOperation:op];
}

- (void)getCollectionOfClass:(Class)class
                 resourceKey:(NSString *)resourceKey
                     withIDs:(NSArray *)ids
                  completion:(void (^)(id collectionResponse,
                                       NSError *error,
                                       AFHTTPRequestOperation *operation))completion
{
    NSParameterAssert(resourceKey);
    NSParameterAssert(ids);
    NSParameterAssert(completion);

    NSString *commaSeparatedIDs = [ids componentsJoinedByString:@","];
    NSString *resourcePath = [resourceKey stringByAppendingPathComponent:commaSeparatedIDs];

    [self getPath:resourcePath parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error = nil;
        id collectionResponse = [MRTAuthenticatedClient parseCollectionResponse:responseObject
                                                                        ofClass:class
                                                                    resourceKey:resourceKey
                                                                          error:&error];
        completion(collectionResponse, error, operation);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error, operation);
    }];
}

+ (id)parseCollectionResponse:(id)responseObject
                      ofClass:(Class)class
                  resourceKey:(NSString *)resourceKey
                        error:(NSError* __autoreleasing *)error
{
    id collectionResponse = nil;

    if ([responseObject isKindOfClass:[NSDictionary class]]) {
        NSDictionary *responseDict = (NSDictionary *)responseObject;
        collectionResponse = [MTLJSONAdapter modelOfClass:class
                                       fromJSONDictionary:responseDict
                                                    error:error];
    } else {
        /// TODO: Unexpected object return type
    }

    if ([collectionResponse isKindOfClass:class]) {
        return collectionResponse;
    }

    return nil;
}
@end

@implementation MRTAuthenticatedClient (PromiseKit)

- (PMKPromise *)me
{
    return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject){
        [self getMeWithCompletion:^(MRTUserResponse *userResponse,
                                    NSError *error,
                                    AFHTTPRequestOperation *operation) {
            if (userResponse) {
                fulfill(userResponse);
            }
            else {
                reject(error);
            }
        }];
    }];
}

- (PMKPromise *)organizationsWithIDs:(NSArray *)organizationIDs
{
    return [self collectionsOfClass:[MRTOrganizationsResponse class]
                        resourceKey:@"organizations"
                            withIDs:organizationIDs];
}

- (PMKPromise *)projectsWithIDs:(NSArray *)projectIDs
{
    return [self collectionsOfClass:[MRTProjectsResponse class]
                        resourceKey:@"projects"
                            withIDs:projectIDs];
}

- (PMKPromise *)createProjectWithName:(NSString *)name
                       organizationID:(NSString *)organizationID
                             isPublic:(BOOL)isPublic
                            colorName:(NSString *)colorName
{
    return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
        [self createProjectWithName:name organizationID:organizationID isPublic:isPublic colorName:colorName completion:^(MRTProjectsResponse *projectsResponse, NSError *error, AFHTTPRequestOperation *operation) {
            if (projectsResponse.projectResponses.count == 1) {
                fulfill(projectsResponse.projectResponses[0]);
            } else {
                reject(error);
            }
        }];
    }];
}

- (PMKPromise *)foldersWithIDs:(NSArray *)folderIDs
{
    return [self collectionsOfClass:[MRTFoldersResponse class]
                        resourceKey:@"folders"
                            withIDs:folderIDs];
}

- (PMKPromise *)createFolderWithName:(NSString *)name
                           projectID:(NSString *)projectID
{
    return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
        [self createFolderWithName:name projectID:projectID completion:^(MRTFoldersResponse *foldersResponse, NSError *error, AFHTTPRequestOperation *operation) {
            if (foldersResponse.folderResponses.count == 1) {
                fulfill(foldersResponse.folderResponses[0]);
            } else {
                reject(error);
            }
        }];
    }];
}

- (PMKPromise *)createFolderWithName:(NSString *)name
                      parentFolderID:(NSString *)parentFolderID
{
    return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
        [self createFolderWithName:name parentFolderID:parentFolderID completion:^(MRTFoldersResponse *foldersResponse, NSError *error, AFHTTPRequestOperation *operation) {
            if (foldersResponse.folderResponses.count == 1) {
                fulfill(foldersResponse.folderResponses[0]);
            } else {
                reject(error);
            }
        }];
    }];
}

- (PMKPromise *)filesWithIDs:(NSArray *)fileIDs
{
    return [self collectionsOfClass:[MRTFilesResponse class]
                        resourceKey:@"files"
                            withIDs:fileIDs];
}

- (PMKPromise *)createFileWithName:(NSString *)name
                         projectID:(NSString *)projectID
{
    return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
        [self createFileWithName:name projectID:projectID completion:^(MRTFilesResponse *filesResponse, NSError *error, AFHTTPRequestOperation *operation) {
            if (filesResponse.fileResponses.count == 1) {
                fulfill(filesResponse.fileResponses[0]);
            } else {
                reject(error);
            }
        }];
    }];
}

- (PMKPromise *)createFileWithName:(NSString *)name
                    parentFolderID:(NSString *)parentFolderID
{
    return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
        [self createFileWithName:name parentFolderID:parentFolderID completion:^(MRTFilesResponse *filesResponse, NSError *error, AFHTTPRequestOperation *operation) {
            if (filesResponse) {
                fulfill(filesResponse.fileResponses[0]);
            } else {
                reject(error);
            }
        }];
    }];
}

- (PMKPromise *)revisionsWithIDs:(NSArray *)revisionIDs
{
    return [self collectionsOfClass:[MRTRevisionsResponse class]
                        resourceKey:@"revisions"
                            withIDs:revisionIDs];
}

- (PMKPromise *)createRevisionForFileID:(NSString *)fileID
                                    md5:(NSString *)md5
                              remoteURL:(NSURL *)remoteURL
                              parentMD5:(NSString *)parentMD5
{
    __weak typeof(self) weakSelf = self;
    return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
        [weakSelf createRevisionForFileID:fileID md5:md5 remoteURL:remoteURL parentMD5:parentMD5 completion:^(MRTRevisionsResponse *revisionsResponse, NSError *error, AFHTTPRequestOperation *operation) {
            if (revisionsResponse.revisionResponses.count == 1) {
                fulfill(revisionsResponse.revisionResponses[0]);
            } else {
                reject(error);
            }
        }];
    }];
}


#pragma mark - Private
- (PMKPromise *)collectionsOfClass:(Class)class resourceKey:(NSString *)resourceKey withIDs:(NSArray *)ids
{
    return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
        [self getCollectionOfClass:class resourceKey:resourceKey withIDs:ids completion:^(id collectionResponse, NSError *error, AFHTTPRequestOperation *operation) {
            if (collectionResponse) {
                fulfill(collectionResponse);
            } else {
                reject(error);
            }
        }];
    }];
}

@end
