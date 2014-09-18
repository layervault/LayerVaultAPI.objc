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

        if ([responseObject isKindOfClass:NSDictionary.class]) {
            NSDictionary *responseDict = (NSDictionary *)responseObject;
            NSArray *users = responseDict[@"users"];
            if ((users.count == 1) && [users[0] isKindOfClass:NSDictionary.class]) {
                NSDictionary *userDict = users[0];
                userResponse = [MTLJSONAdapter modelOfClass:MRTUserResponse.class
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
    [self getCollectionOfClass:MRTOrganizationsResponse.class
                   resourceKey:@"organizations"
                       withIDs:organizationIDs
                    completion:completion];
}

- (void)getProjectsWithIDs:(NSArray *)projectIDs
              completion:(void (^)(MRTProjectsResponse *projectsResponse,
                                   NSError *error,
                                   AFHTTPRequestOperation *operation))completion
{
    [self getCollectionOfClass:MRTProjectsResponse.class
                   resourceKey:@"projects"
                       withIDs:projectIDs
                    completion:completion];
}

- (void)getFoldersWithIDs:(NSArray *)folderIDs
                completion:(void (^)(MRTFoldersResponse *foldersResponse,
                                     NSError *error,
                                     AFHTTPRequestOperation *operation))completion
{
    [self getCollectionOfClass:MRTFoldersResponse.class
                   resourceKey:@"folders"
                       withIDs:folderIDs
                    completion:completion];
}

- (void)getFilesWithIDs:(NSArray *)fileIDs
             completion:(void (^)(MRTFilesResponse *filesResponse,
                                  NSError *error,
                                  AFHTTPRequestOperation *operation))completion
{
    [self getCollectionOfClass:MRTFilesResponse.class
                   resourceKey:@"files"
                       withIDs:fileIDs
                    completion:completion];
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
        MRTProjectsResponse *collectionResponses = nil;

        if ([responseObject isKindOfClass:NSDictionary.class]) {
            NSDictionary *responseDict = (NSDictionary *)responseObject;
            collectionResponses = [MTLJSONAdapter modelOfClass:class
                                         fromJSONDictionary:responseDict
                                                      error:&error];
        } else {
            /// TODO: Unexpected object return type
        }

        if ([collectionResponses isKindOfClass:class]) {
            completion(collectionResponses, error, operation);
        } else {
            /// TODO: Unexpected collection type
            completion(nil, error, operation);
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error, operation);
    }];
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

- (PMKPromise *)foldersWithIDs:(NSArray *)folderIDs
{
    return [self collectionsOfClass:[MRTFoldersResponse class]
                        resourceKey:@"folders"
                            withIDs:folderIDs];
}

- (PMKPromise *)filesWithIDs:(NSArray *)fileIDs
{
    return [self collectionsOfClass:[MRTFilesResponse class]
                        resourceKey:@"files"
                            withIDs:fileIDs];
}

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
