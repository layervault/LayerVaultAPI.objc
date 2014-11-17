//
//  LVCV2AuthenticatedClient.m
//  Pods
//
//  Created by Matt Thomas on 9/17/14.
//
//

#import "LVCV2AuthenticatedClient.h"
#import <AFNetworking/AFNetworking.h>
#import <PromiseKit/PromiseKit.h>
#import <PromiseKit/Promise+When.h>
#import <TransformerKit/TTTDateTransformers.h>
#import "LVCModelCollection.h"
#import "LVCUserCollection.h"
#import "LVCOrganizationCollection.h"
#import "LVCProjectCollection.h"
#import "LVCFolderCollection.h"
#import "LVCFileCollection.h"
#import "LVCRevisionCollection.h"
#import "LVCOrganization.h"
#import "LVCProject.h"
#import "LVCAmazonS3Client.h"

@interface LVCV2AuthenticatedClient ()
@property (nonatomic) LVCAmazonS3Client *amazonS3Client;
@end

@implementation LVCV2AuthenticatedClient

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

- (void)getMeWithCompletion:(void (^)(LVCUserValue *userValue,
                                      NSError *error,
                                      AFHTTPRequestOperation *operation))completion
{
    NSParameterAssert(completion);

    NSMutableURLRequest *urlRequest = [self requestWithMethod:@"GET" path:@"me" parameters:nil];
    urlRequest.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    AFHTTPRequestOperation *op = [self HTTPRequestOperationWithRequest:urlRequest success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error = nil;
        LVCUserValue *userValue = nil;

        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *responseDict = (NSDictionary *)responseObject;
            NSArray *users = responseDict[@"users"];
            if ((users.count == 1) && [users[0] isKindOfClass:[NSDictionary class]]) {
                NSDictionary *userDict = users[0];
                userValue = [MTLJSONAdapter modelOfClass:[LVCUserValue class]
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

        completion(userValue, error, operation);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error, operation);
    }];

    [self enqueueHTTPRequestOperation:op];
}

- (void)getOrganizationsWithIDs:(NSArray *)organizationIDs
                     completion:(void (^)(LVCOrganizationCollection *organizationCollection,
                                          NSError *error,
                                          AFHTTPRequestOperation *operation))completion
{
    [self getCollectionOfClass:[LVCOrganizationCollection class]
                   resourceKey:@"organizations"
                       withIDs:organizationIDs
                    completion:completion];
}

- (void)getProjectsWithIDs:(NSArray *)projectIDs
                completion:(void (^)(LVCProjectCollection *projectCollection,
                                     NSError *error,
                                     AFHTTPRequestOperation *operation))completion
{
    [self getCollectionOfClass:[LVCProjectCollection class]
                   resourceKey:@"projects"
                       withIDs:projectIDs
                    completion:completion];
}

- (void)createProjectWithName:(NSString *)name
               organizationID:(NSString *)organizationID
                     isPublic:(BOOL)isPublic
                    colorName:(NSString *)colorName
                   completion:(void (^)(LVCProjectCollection *projectCollection,
                                        NSError *error,
                                        AFHTTPRequestOperation *operation))completion
{
    [self createResourceWithCollectionClass:[LVCProjectCollection class]
                                resourceKey:@"projects"
                               resourceInfo:@{@"name": name,
                                              @"is_public": @(isPublic),
                                              @"color": colorName,
                                              @"links": @{@"organization": organizationID}}
                                 completion:completion];
}

- (void)updateProject:(LVCProjectValue *)project
           completion:(void (^)(LVCProjectCollection *projectCollection, NSError *error, AFHTTPRequestOperation *operation))completion
{

}

- (void)deleteProject:(LVCProjectValue *)project
           completion:(void (^)(LVCProjectCollection *projectCollection, NSError *error, AFHTTPRequestOperation *operation))completion
{

}

- (void)getFoldersWithIDs:(NSArray *)folderIDs
               completion:(void (^)(LVCFolderCollection *folderCollection,
                                    NSError *error,
                                    AFHTTPRequestOperation *operation))completion
{
    [self getCollectionOfClass:[LVCFolderCollection class]
                   resourceKey:@"folders"
                       withIDs:folderIDs
                    completion:completion];
}

- (void)createFolderWithName:(NSString *)name
                   projectID:(NSString *)projectID
                  completion:(void (^)(LVCFolderCollection *folderCollection,
                                       NSError *error,
                                       AFHTTPRequestOperation *operation))completion
{
    [self createResourceWithCollectionClass:[LVCFolderCollection class]
                                resourceKey:@"folders"
                               resourceInfo:@{@"name": name,
                                              @"links": @{@"project": projectID}}
                                 completion:completion];
}

- (void)createFolderWithName:(NSString *)name
              parentFolderID:(NSString *)parentFolderID
                  completion:(void (^)(LVCFolderCollection *folderCollection,
                                       NSError *error,
                                       AFHTTPRequestOperation *operation))completion
{
    [self createResourceWithCollectionClass:[LVCFolderCollection class]
                                resourceKey:@"folders"
                               resourceInfo:@{@"name": name,
                                              @"links": @{@"parent_folder": parentFolderID}}
                                 completion:completion];
}

- (void)getFilesWithIDs:(NSArray *)fileIDs
             completion:(void (^)(LVCFileCollection *filesCollection,
                                  NSError *error,
                                  AFHTTPRequestOperation *operation))completion
{
    [self getCollectionOfClass:[LVCFileCollection class]
                   resourceKey:@"files"
                       withIDs:fileIDs
                    completion:completion];
}

- (void)createFileWithName:(NSString *)name
                 projectID:(NSString *)projectID
                completion:(void (^)(LVCFileCollection *filesCollection,
                                     NSError *error,
                                     AFHTTPRequestOperation *operation))completion
{
    [self createResourceWithCollectionClass:[LVCFileCollection class]
                                resourceKey:@"files"
                               resourceInfo:@{@"name": name,
                                              @"links": @{@"project": projectID}}
                                 completion:completion];
}

- (void)createFileWithName:(NSString *)name
            parentFolderID:(NSString *)parentFolderID
                completion:(void (^)(LVCFileCollection *filesCollection,
                                     NSError *error,
                                     AFHTTPRequestOperation *operation))completion
{
    [self createResourceWithCollectionClass:[LVCFileCollection class]
                                resourceKey:@"files"
                               resourceInfo:@{@"name": name,
                                              @"links": @{@"folder": parentFolderID}}
                                 completion:completion];
}

- (void)getRevisionsWithIDs:(NSArray *)revisionIDs
                 completion:(void (^)(LVCRevisionCollection *revisionCollection,
                                      NSError *error,
                                      AFHTTPRequestOperation *operation))completion
{
    [self getCollectionOfClass:[LVCRevisionCollection class]
                   resourceKey:@"revisions"
                       withIDs:revisionIDs
                    completion:completion];
}

- (void)createRevisionForFileID:(NSString *)fileID
                            md5:(NSString *)md5
                      remoteURL:(NSURL *)remoteURL
                      parentMD5:(NSString *)parentMD5
                     completion:(void (^)(LVCRevisionCollection *revisionCollection,
                                          NSError *error,
                                          AFHTTPRequestOperation *operation))completion
{
    NSDictionary *dict = @{@"md5": md5,
                           @"remote_url": [remoteURL absoluteString],
                           @"links": @{@"file": fileID}};
    if (parentMD5.length > 0) {
        NSMutableDictionary *mDict = dict.mutableCopy;
        mDict[@"parent_md5"] = parentMD5;
        dict = mDict.copy;
    }
    [self createResourceWithCollectionClass:[LVCRevisionCollection class]
                                resourceKey:@"revisions"
                               resourceInfo:dict
                                 completion:completion];
}

#pragma mark - S3
- (void)generateS3ResourceForPath:(NSString *)path
                           bucket:(NSString *)bucket
                      maxFileSize:(NSString *)maxFileSize
                       completion:(void (^)(NSDictionary *responseParams,
                                            NSError *error,
                                            AFHTTPRequestOperation *operation))completion
{
    NSMutableDictionary *dict = @{@"path": path}.mutableCopy;
    if (bucket.length > 0) {
        dict[@"bucket"] = bucket;
    }
    if (maxFileSize.length > 0) {
        dict[@"max_file_size"] = maxFileSize;
    }

    NSString *mime = @"application/json";
    NSDictionary *params = @{@"Content-Type": mime};

    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict
                                                   options:0
                                                     error:&error];

    NSMutableURLRequest *request = [self requestWithMethod:@"POST" path:@"/api/s3/generate" parameters:params];
    [request setValue:mime forHTTPHeaderField:@"Content-Type"];
    request.HTTPBody = data;

    AFHTTPRequestOperation *op = [self HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            completion(responseObject, nil, operation);
        } else {
#warning - TODO Real Error
            NSError *error = [NSError errorWithDomain:@"asdf" code:1234 userInfo:nil];
            completion(nil, error, operation);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error, operation);
    }];
    [self enqueueHTTPRequestOperation:op];
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
        id resourceResponse = [LVCV2AuthenticatedClient parseCollectionResponse:responseObject
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
        id collectionResponse = [LVCV2AuthenticatedClient parseCollectionResponse:responseObject
                                                                          ofClass:class
                                                                      resourceKey:resourceKey
                                                                            error:&error];

        if ([collectionResponse isKindOfClass:[LVCOrganizationCollection class]]) {
            LVCOrganizationCollection *orgCollection = (LVCOrganizationCollection *)collectionResponse;
            NSDate *serverDate = nil;
            NSString *serverDateString = operation.response.allHeaderFields[@"Date"];
            if (serverDateString) {
                NSValueTransformer *rfc2822DateTransformer = [NSValueTransformer valueTransformerForName:TTTRFC2822DateTransformerName];
                serverDate = [rfc2822DateTransformer reverseTransformedValue:serverDateString];
            }
            if (!serverDate) {
                serverDate = [NSDate date];
            }
            orgCollection.currentServerTime = serverDate;
        }
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

@implementation LVCV2AuthenticatedClient (PromiseKit)

- (PMKPromise *)me
{
    return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject){
        [self getMeWithCompletion:^(LVCUserValue *userValue,
                                    NSError *error,
                                    AFHTTPRequestOperation *operation) {
            if (userValue) {
                fulfill(userValue);
            }
            else {
                reject(error);
            }
        }];
    }];
}

- (PMKPromise *)organizationCollectionWithIDs:(NSArray *)organizationIDs
{
    if (organizationIDs.count > 0) {
        return [self collectionsOfClass:[LVCOrganizationCollection class]
                            resourceKey:@"organizations"
                                withIDs:organizationIDs];
    } else {
        LVCOrganizationCollection *orgCollection = [[LVCOrganizationCollection alloc] init];
        // Since organizations is a readonly property, set it sneakily
        [orgCollection setValue:@[]
                         forKey:NSStringFromSelector(@selector(organizations))];
        return [PMKPromise promiseWithValue:orgCollection];
    }
}

- (PMKPromise *)organizationsWithIDs:(NSArray *)organizationIDs
{
    return [self objectsOfClass:[LVCOrganizationCollection class]
                    resourceKey:@"organizations"
                        withIDs:organizationIDs];
}

- (PMKPromise *)projectsWithIDs:(NSArray *)projectIDs
{
    return [self objectsOfClass:[LVCProjectCollection class]
                    resourceKey:@"projects"
                        withIDs:projectIDs];
}

- (PMKPromise *)createProjectWithName:(NSString *)name
                       organizationID:(NSString *)organizationID
                             isPublic:(BOOL)isPublic
                            colorName:(NSString *)colorName
{
    return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
        [self createProjectWithName:name organizationID:organizationID isPublic:isPublic colorName:colorName completion:^(LVCProjectCollection *projectCollection, NSError *error, AFHTTPRequestOperation *operation) {
            if (projectCollection.projects.count == 1) {
                fulfill(projectCollection.projects[0]);
            } else {
                reject(error);
            }
        }];
    }];
}

- (PMKPromise *)foldersWithIDs:(NSArray *)folderIDs
{
    return [self objectsOfClass:[LVCFolderCollection class]
                    resourceKey:@"folders"
                        withIDs:folderIDs];
}

- (PMKPromise *)createFolderWithName:(NSString *)name
                           projectID:(NSString *)projectID
{
    return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
        [self createFolderWithName:name projectID:projectID completion:^(LVCFolderCollection *folderCollection, NSError *error, AFHTTPRequestOperation *operation) {
            if (folderCollection.folders.count == 1) {
                fulfill(folderCollection.folders[0]);
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
        [self createFolderWithName:name parentFolderID:parentFolderID completion:^(LVCFolderCollection *folderCollection, NSError *error, AFHTTPRequestOperation *operation) {
            if (folderCollection.folders.count == 1) {
                fulfill(folderCollection.folders[0]);
            } else {
                reject(error);
            }
        }];
    }];
}

- (PMKPromise *)filesWithIDs:(NSArray *)fileIDs
{
    return [self objectsOfClass:[LVCFileCollection class]
                    resourceKey:@"files"
                        withIDs:fileIDs];
}

- (PMKPromise *)createFileWithName:(NSString *)name
                         projectID:(NSString *)projectID
{
    return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
        [self createFileWithName:name projectID:projectID completion:^(LVCFileCollection *fileCollection,
                                                                       NSError *error,
                                                                       AFHTTPRequestOperation *operation) {
            if (fileCollection.files.count == 1) {
                fulfill(fileCollection.files[0]);
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
        [self createFileWithName:name parentFolderID:parentFolderID completion:^(LVCFileCollection *filesCollection,
                                                                                 NSError *error,
                                                                                 AFHTTPRequestOperation *operation) {
            if (filesCollection) {
                fulfill(filesCollection.files[0]);
            } else {
                reject(error);
            }
        }];
    }];
}

- (PMKPromise *)revisionsWithIDs:(NSArray *)revisionIDs
{
    return [self objectsOfClass:[LVCRevisionCollection class]
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
        [weakSelf createRevisionForFileID:fileID md5:md5 remoteURL:remoteURL parentMD5:parentMD5 completion:^(LVCRevisionCollection *revisionCollection, NSError *error, AFHTTPRequestOperation *operation) {
            if (revisionCollection.revisions.count == 1) {
                fulfill(revisionCollection.revisions[0]);
            } else {
                reject(error);
            }
        }];
    }];
}

#pragma mark - S3
- (PMKPromise *)generateS3ResourceForPath:(NSString *)path
                                   bucket:(NSString *)bucket
                              maxFileSize:(NSString *)maxFileSize
{
    __weak typeof(self) weakSelf = self;
    return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {
        [weakSelf generateS3ResourceForPath:path bucket:bucket maxFileSize:maxFileSize completion:^(NSDictionary *response, NSError *error, AFHTTPRequestOperation *operation) {
            if (response) {
                fulfill(response);
            } else {
                reject(error);
            }
        }];
    }];
}


#pragma mark - Promises
- (PMKPromise *)uploadFile:(NSURL *)fileURL
                parameters:(NSDictionary *)parameters
{
    NSError *accessTokenError;
    NSString *accessToken = [self accessTokenWithError:&accessTokenError];
    __weak typeof(self) weakSelf = self;
    return [PMKPromise new:^(PMKPromiseFulfiller fulfill, PMKPromiseRejecter reject) {

        if (!accessToken) {
            reject(accessTokenError);
        } else {
            weakSelf.amazonS3Client = [[LVCAmazonS3Client alloc] init];
            AFHTTPRequestOperation *s3Op = [weakSelf.amazonS3Client uploadOperationForFile:fileURL parameters:parameters accessToken:accessToken success:^(AFHTTPRequestOperation *operation, id responseObject) {
                fulfill(responseObject);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                reject(error);
            }];
            [weakSelf enqueueHTTPRequestOperation:s3Op];
        }
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

- (PMKPromise *)objectsOfClass:(Class)class
                   resourceKey:(NSString *)resourceKey
                       withIDs:(NSArray *)ids
                     groupSize:(NSUInteger)groupSize
{
    NSAssert(groupSize > 0, @"group size must be > 0");
    NSParameterAssert(resourceKey);
    NSParameterAssert(ids);

    NSUInteger groupCount = (NSUInteger)ceil((double)ids.count/(double)groupSize);

    NSMutableArray *idGroups = [[NSMutableArray alloc] initWithCapacity:groupCount];
    for (NSUInteger groupNumber = 0; groupNumber < groupCount; groupNumber++) {
        NSUInteger start = groupSize * groupNumber;
        NSUInteger end = MIN(groupSize, ids.count - start);
        idGroups[groupNumber] = [ids subarrayWithRange:NSMakeRange(start, end)];
    }

    NSMutableArray *requestGroup = [[NSMutableArray alloc] initWithCapacity:groupCount];
    for (NSArray *idGroup in idGroups) {
        [requestGroup addObject:[self collectionsOfClass:class resourceKey:resourceKey withIDs:idGroup]];
    }

    return [PMKPromise all:requestGroup].then(^(NSArray *collectionGroup) {
        NSMutableArray *objects = [[NSMutableArray alloc] initWithCapacity:ids.count];
        for (id<LVCModelCollection>collection in collectionGroup) {
            [objects addObjectsFromArray:[collection allModels]];
        }
        return objects;
    });
}

- (PMKPromise *)objectsOfClass:(Class)class
                   resourceKey:(NSString *)resourceKey
                       withIDs:(NSArray *)ids
{
    return [self objectsOfClass:class resourceKey:resourceKey withIDs:ids groupSize:50];
}

- (NSString *)accessTokenWithError:(NSError * __autoreleasing *)error
{
    NSString *accessToken = nil;
    NSString *authHeader = [self defaultValueForHeader:@"Authorization"];
    if (authHeader.length > 7 && [authHeader hasPrefix:@"Bearer "]) {
        accessToken = [authHeader substringFromIndex:7];
    }

    if (!accessToken && error) {
        *error = [NSError errorWithDomain:@"LVCHTTPClientErrorDomain"
                                     code:1
                                 userInfo:@{NSLocalizedDescriptionKey: @"No Access Token Found. Check your authentication Credentials"}];
    }
    
    return accessToken;
}

@end
