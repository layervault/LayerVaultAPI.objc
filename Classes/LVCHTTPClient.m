//
//  LVCHTTPClient.m
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 10/13/13.
//  Copyright (c) 2013 LayerVault. All rights reserved.
//

#import "LVCHTTPClient.h"
#import <Mantle/Mantle.h>
#import <AFNetworking/AFJSONRequestOperation.h>
#import "LVCUser.h"
#import "LVCOrganization.h"
#import "LVCProject.h"
#import "LVCAmazonS3Client.h"
#import "LVCFileRevision.h"
#import "LVCFileRevisionFeedback.h"


@implementation LVCHTTPClient

+ (NSURL *)defaultBaseURL
{
    return [NSURL URLWithString:@"https://api.layervault.com/api/v1/"];
}

- (instancetype)initWithBaseURL:(NSURL *)url clientID:(NSString *)clientID secret:(NSString *)secret
{
    self = [super initWithBaseURL:url clientID:clientID secret:secret];
    if (self) {
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [self setDefaultHeader:@"Accept" value:@"application/json"];
        self.parameterEncoding = AFJSONParameterEncoding;
    }
    return self;
}


- (instancetype)initWithClientID:(NSString *)clientID secret:(NSString *)secret
{
    return [self initWithBaseURL:LVCHTTPClient.defaultBaseURL
                        clientID:clientID
                          secret:secret];
}


#pragma mark - Authentication
- (void)authenticateWithEmail:(NSString *)email
                     password:(NSString *)password
                   completion:(void (^)(AFOAuthCredential *credential,
                                        NSError *error))completion
{
    NSParameterAssert(email);
    NSParameterAssert(password);
    NSParameterAssert(completion);

    [self authenticateUsingOAuthWithPath:@"/oauth/token"
                                username:email
                                password:password
                                   scope:nil
                                 success:^(AFOAuthCredential *credential) {
                                     completion(credential, nil);
                                 }
                                 failure:^(NSError *error) {
                                     completion(nil, error);
                                 }];
}


#pragma mark - Users
- (void)getMeWithCompletion:(void (^)(LVCUser *user,
                                      NSError *error,
                                      AFHTTPRequestOperation *operation))completion
{
    NSParameterAssert(completion);

    [self getPath:@"me"
       parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSError *error = nil;
              LVCUser *user = [MTLJSONAdapter modelOfClass:LVCUser.class
                                        fromJSONDictionary:responseObject
                                                     error:&error];
              completion(user, error, operation);
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              completion(nil, error, operation);
          }];
}


#pragma mark - Organizations
- (void)getOrganizationWithPermalink:(NSString *)permalink
                               block:(void (^)(LVCOrganization *organization,
                                               NSError *error,
                                               AFHTTPRequestOperation *operation))block
{
    NSParameterAssert(permalink);
    NSParameterAssert(block);

    [self getPath:[permalink stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
       parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSError *error;
              LVCOrganization *org = [MTLJSONAdapter modelOfClass:LVCOrganization.class
                                               fromJSONDictionary:responseObject
                                                            error:&error];
              block(org, error, operation);
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              block(nil, error, operation);
          }];
}


#pragma mark - Projects
- (void)getProjectFromPartial:(LVCProject *)project
                   completion:(void (^)(LVCProject *project,
                                        NSError *error,
                                        AFHTTPRequestOperation *operation))completion
{
    NSParameterAssert(project);
    NSParameterAssert(completion);

    if (project.partial) {
        [self getProjectWithName:project.name
           organizationPermalink:project.organizationPermalink
                      completion:completion];
    }
    else {
        completion(project, nil, nil);
    }
}


- (void)getProjectWithName:(NSString *)projectName
     organizationPermalink:(NSString *)organizationPermalink
                completion:(void (^)(LVCProject *project,
                                     NSError *error,
                                     AFHTTPRequestOperation *operation))completion
{
    NSParameterAssert(projectName);
    NSParameterAssert(organizationPermalink);
    NSParameterAssert(completion);

    NSString *projectPath = [self pathForProjectName:projectName
                               organizationPermalink:organizationPermalink];

    projectPath = [projectPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    [self getPath:projectPath
       parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSError *error;
              LVCProject *project = [MTLJSONAdapter modelOfClass:LVCProject.class
                                              fromJSONDictionary:responseObject
                                                           error:&error];
              completion(project, error, operation);
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              completion(nil, error, operation);
          }];
}


- (void)createProjectWithName:(NSString *)projectName
        organizationPermalink:(NSString *)organizationPermalink
                   completion:(void (^)(LVCProject *project,
                                        NSError *error,
                                        AFHTTPRequestOperation *operation))completion
{
    NSParameterAssert(projectName);
    NSParameterAssert(organizationPermalink);
    NSParameterAssert(completion);

    NSString *projectPath = [self pathForProjectName:projectName
                               organizationPermalink:organizationPermalink];

    projectPath = [projectPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    [self postPath:projectPath
        parameters:nil
           success:^(AFHTTPRequestOperation *operation, id responseObject) {
               NSError *error;
               LVCProject *project = [MTLJSONAdapter modelOfClass:LVCProject.class
                                               fromJSONDictionary:responseObject
                                                            error:&error];
               completion(project, error, operation);
           }
           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               completion(nil, error, operation);
           }];

}


- (void)deleteProject:(LVCProject *)project
           completion:(void (^)(BOOL success,
                                NSError *error,
                                AFHTTPRequestOperation *operation))completion
{
    NSParameterAssert(project);
    NSParameterAssert(completion);

    NSString *projectPath = [self pathForProject:project includeOrganization:YES];
    projectPath = [projectPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    [self deletePath:projectPath
          parameters:nil
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 completion(YES, nil, operation);
             }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 completion(NO, error, operation);
             }];
}


- (void)renameProject:(LVCProject *)project
              newName:(NSString *)newName
           completion:(void (^)(LVCProject *project,
                                NSError *error,
                                AFHTTPRequestOperation *operation))completion
{
    NSParameterAssert(project);
    NSParameterAssert(newName);
    NSParameterAssert(completion);

    NSString *movePath = [[self pathForProject:project
                           includeOrganization:YES] stringByAppendingPathComponent:@"move"];
    movePath = [movePath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    NSDictionary *params = @{@"to": newName};

    [self postPath:movePath
        parameters:params
           success:^(AFHTTPRequestOperation *operation, id responseObject) {
               NSError *error;
               LVCProject *project = [MTLJSONAdapter modelOfClass:LVCProject.class
                                               fromJSONDictionary:responseObject
                                                            error:&error];
               completion(project, error, operation);
           }
           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               completion(nil, error, operation);
           }];
}


- (void)updateProject:(LVCProject *)project
           colorLabel:(LVCColorLabel)colorLabel
           completion:(void (^)(BOOL success,
                                NSError *error,
                                AFHTTPRequestOperation *operation))completion
{
    [self updateFolder:project
            colorLabel:colorLabel
            completion:completion];
}


#pragma mark - Folders
- (void)getFolderAtPath:(NSString *)path
             completion:(void (^)(LVCFolder *folder,
                                  NSError *error,
                                  AFHTTPRequestOperation *operation))completion
{
    NSParameterAssert(path);
    NSParameterAssert(completion);

    path = [LVCHTTPClient sanitizeRequestPath:path];

    [self getPath:path
       parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSError *error;
              LVCFolder *folder = [MTLJSONAdapter modelOfClass:LVCFolder.class
                                            fromJSONDictionary:responseObject
                                                         error:&error];
              completion(folder, error, operation);
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              completion(nil, error, operation);
          }];
}

- (void)getFolderAtPath:(NSString *)path
              inProject:(LVCProject *)project
             completion:(void (^)(LVCFolder *folder,
                                  NSError *error,
                                  AFHTTPRequestOperation *operation))completion
{
    NSParameterAssert(path);
    NSParameterAssert(project);
    NSParameterAssert(completion);

    NSString *folderPath = [self appendPath:path
                                  toProject:project
                        includeOrganization:YES];

    [self getFolderAtPath:folderPath
               completion:completion];
}


- (void)createFolderWithName:(NSString *)name
                    inFolder:(LVCFolder *)folder
                  completion:(void (^)(LVCFolder *folder,
                                       NSError *error,
                                       AFHTTPRequestOperation *operation))completion
{
    NSParameterAssert(name);
    NSParameterAssert(folder);

    NSString *folderPath = [folder.urlPath stringByAppendingPathComponent:name];
    [self createFolderAtPath:folderPath completion:completion];
}


- (void)createFolderAtPath:(NSString *)path
                completion:(void (^)(LVCFolder *folder,
                                     NSError *error,
                                     AFHTTPRequestOperation *operation))completion
{
    NSParameterAssert(path);
    NSParameterAssert(completion);

    [self postPath:[LVCHTTPClient sanitizeRequestPath:path]
        parameters:nil
           success:^(AFHTTPRequestOperation *operation, id responseObject) {
               NSError *error;
               LVCFolder *folder = [MTLJSONAdapter modelOfClass:LVCFolder.class
                                             fromJSONDictionary:responseObject
                                                          error:&error];
               completion(folder, error, operation);
           }
           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               completion(nil, error, operation);
           }];
}


- (void)createFolderAtPath:(NSString *)path
                 inProject:(LVCProject *)project
                completion:(void (^)(LVCFolder *folder,
                                     NSError *error,
                                     AFHTTPRequestOperation *operation))completion
{
    NSParameterAssert(path);
    NSParameterAssert(project);
    NSParameterAssert(completion);

    NSString *folderPath = [self appendPath:path
                                  toProject:project
                        includeOrganization:YES];
    [self createFolderAtPath:folderPath
                  completion:completion];
}


- (void)deleteFolder:(LVCFolder *)folder
          completion:(void (^)(BOOL success,
                               NSError *error,
                               AFHTTPRequestOperation *operation))completion
{
    NSParameterAssert(folder);

    [self deleteFolderAtPath:folder.urlPath
                  completion:completion];
}


- (void)deleteFolderAtPath:(NSString *)path
                completion:(void (^)(BOOL success,
                                     NSError *error,
                                     AFHTTPRequestOperation *operation))completion
{
    NSParameterAssert(path);
    NSParameterAssert(completion);

    [self deletePath:[LVCHTTPClient sanitizeRequestPath:path]
          parameters:nil
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 completion(YES, nil, operation);
             }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 completion(NO, error, operation);
             }];
}


- (void)moveFolder:(LVCFolder *)folder
            toPath:(NSString *)toPath
         inProject:(LVCProject *)project
        completion:(void (^)(LVCFolder *folder,
                             NSError *error,
                             AFHTTPRequestOperation *operation))completion
{
    [self moveFolderAtPath:folder.urlPath
                    toPath:toPath
                completion:completion];
}


- (void)moveFolder:(LVCFolder *)folder
            toPath:(NSString *)toPath
        completion:(void (^)(LVCFolder *folder,
                             NSError *error,
                             AFHTTPRequestOperation *operation))completion
{
    [self moveFolderAtPath:folder.urlPath
                    toPath:toPath
                completion:completion];
}


- (void)moveFolderAtPath:(NSString *)path
                  toPath:(NSString *)toPath
              completion:(void (^)(LVCFolder *folder,
                                   NSError *error,
                                   AFHTTPRequestOperation *operation))completion
{
    NSParameterAssert(path);
    NSParameterAssert(toPath);
    NSParameterAssert(completion);

    NSString *movePath = [path stringByAppendingPathComponent:@"move"];

    [self postPath:[LVCHTTPClient sanitizeRequestPath:movePath]
        parameters:@{@"to": toPath}
           success:^(AFHTTPRequestOperation *operation, id responseObject) {
               NSError *error;
               LVCFolder *folder = [MTLJSONAdapter modelOfClass:LVCFolder.class
                                             fromJSONDictionary:responseObject
                                                          error:&error];
               completion(folder, error, operation);
           }
           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               completion(nil, error, operation);
           }];
}


- (void)updateFolder:(LVCFolder *)folder
          colorLabel:(LVCColorLabel)colorLabel
          completion:(void (^)(BOOL success,
                               NSError *error,
                               AFHTTPRequestOperation *operation))completion
{
    NSParameterAssert(folder);
    NSParameterAssert(completion);

    [self updateFolderAtPath:folder.urlPath
                  colorLabel:colorLabel
                  completion:completion];
}


- (void)updateFolderAtPath:(NSString *)path
                colorLabel:(LVCColorLabel)colorLabel
                completion:(void (^)(BOOL success,
                                     NSError *error,
                                     AFHTTPRequestOperation *operation))completion
{
    NSParameterAssert(path);
    NSParameterAssert(completion);

    NSString *colorPath = [path stringByAppendingPathComponent:@"color"];

    NSDictionary *params = @{@"color": [LVCColorUtils colorNameForLabel:colorLabel]};

    [self putPath:[LVCHTTPClient sanitizeRequestPath:colorPath]
       parameters:params
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              completion(YES, nil, operation);
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              completion(NO, error, operation);
          }];
}


#pragma mark - Files
- (void)getFileAtPath:(NSString *)filePath
           completion:(void (^)(LVCFile *file,
                                NSError *error,
                                AFHTTPRequestOperation *operation))completion
{
    NSParameterAssert(filePath);
    NSParameterAssert(completion);

    filePath = [LVCHTTPClient sanitizeRequestPath:filePath];

    [self getPath:filePath
       parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSError *error;
              LVCFile *file = [MTLJSONAdapter modelOfClass:LVCFile.class
                                        fromJSONDictionary:responseObject
                                                     error:&error];
              completion(file, error, operation);
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              completion(nil, error, operation);
          }];
}


- (void)uploadLocalFile:(NSURL *)localFileURL
                 toPath:(NSString *)filePath
             completion:(void (^)(LVCFile *file,
                                  NSError *error,
                                  AFHTTPRequestOperation *operation))completion
{
    NSParameterAssert(localFileURL);
    NSParameterAssert(filePath);
    NSParameterAssert(completion);

    // Add filename if it's not part of the path
    NSString *fileName = localFileURL.lastPathComponent;
    NSRange range = [filePath rangeOfString:fileName];
    if (range.location == NSNotFound || range.location != (filePath.length - fileName.length)) {
        filePath = [filePath stringByAppendingPathComponent:fileName];
    }
    filePath = [self sanitizeRequestPath:filePath];

    NSString *md5 = md5ForFileURL(localFileURL);
    NSDictionary *params = nil;
    if (md5) {
        params = @{@"md5":md5};
    }

    if (md5) {
        [self putPath:filePath
           parameters:params
              success:^(AFHTTPRequestOperation *operation, id responseObject) {

                  AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:self.serviceProviderIdentifier];

                  LVCAmazonS3Client *s3Client = [LVCAmazonS3Client new];
                  [s3Client postFile:localFileURL
                          parameters:responseObject
                         accessToken:credential.accessToken
                             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                 NSError *error;
                                 LVCFile *file = [MTLJSONAdapter modelOfClass:LVCFile.class
                                                           fromJSONDictionary:responseObject
                                                                        error:&error];
                                 completion(file, error, operation);
                             }
                             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                 completion(nil, error, operation);
                             }];
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  completion(nil, error, operation);
              }];
    }
    else {
        NSError *error = [NSError errorWithDomain:@"asdf" code:-100 userInfo:nil];
        completion(nil, error, nil);
    }
}


- (void)uploadLocalFile:(NSURL *)localFileURL
                 toPath:(NSString *)filePath
              inProject:(LVCProject *)project
             completion:(void (^)(LVCFile *file,
                                  NSError *error,
                                  AFHTTPRequestOperation *operation))completion
{
    NSParameterAssert(localFileURL);
    NSParameterAssert(filePath);
    NSParameterAssert(project);
    NSParameterAssert(completion);

    filePath = [self appendPath:filePath toProject:project includeOrganization:YES];

    [self uploadLocalFile:localFileURL
                   toPath:filePath
               completion:completion];
}


- (void)deleteFile:(LVCFile *)file
        completion:(void (^)(BOOL, NSError *, AFHTTPRequestOperation *))completion
{
    NSParameterAssert(file);
    [self deleteFileAtPath:file.urlPath
                       md5:file.md5
                completion:completion];
}


- (void)deleteFileAtPath:(NSString *)filePath
                     md5:(NSString *)md5
              completion:(void (^)(BOOL success,
                                   NSError *error,
                                   AFHTTPRequestOperation *operation))completion;
{
    NSParameterAssert(filePath);
    NSParameterAssert(md5);
    NSParameterAssert(completion);

    [self deletePath:[self sanitizeRequestPath:filePath]
          parameters:@{@"md5": md5}
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 completion(YES, nil, operation);
             }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 completion(NO, error, operation);
             }];
}


- (void)moveFile:(LVCFile *)file
          toPath:(NSString *)toPath
     newFileName:(NSString *)newFileName
      completion:(void (^)(BOOL success,
                           NSError *error,
                           AFHTTPRequestOperation *operation))completion
{
    [self moveFileAtPath:file.urlPath
                  toPath:[toPath stringByAppendingPathComponent:newFileName]
              completion:completion];
}


- (void)moveFile:(LVCFile *)file
          toPath:(NSString *)toPath
      completion:(void (^)(BOOL, NSError *, AFHTTPRequestOperation *))completion
{
    [self moveFileAtPath:file.urlPath
                  toPath:toPath
              completion:completion];
}


- (void)moveFileAtPath:(NSString *)filePath
                toPath:(NSString *)toPath
            completion:(void (^)(BOOL success,
                                 NSError *error,
                                 AFHTTPRequestOperation *operation))completion
{
    NSParameterAssert(filePath);
    NSParameterAssert(toPath);
    NSParameterAssert(completion);

    NSString *toPathLessFileName = [toPath stringByReplacingOccurrencesOfString:toPath.lastPathComponent
                                                                     withString:@""];
    if ([toPathLessFileName hasSuffix:@"/"]) {
        toPathLessFileName = [toPathLessFileName substringToIndex:(toPathLessFileName.length - 1)];
    }
    NSMutableDictionary *params = @{@"to": toPathLessFileName}.mutableCopy;

    if (![filePath.lastPathComponent isEqualToString:toPath.lastPathComponent]) {
        params[@"new_file_name"] = toPath.lastPathComponent;
    }

    NSString *movePath = [filePath stringByAppendingPathComponent:@"move"];

    [self postPath:[LVCHTTPClient sanitizeRequestPath:movePath]
        parameters:params
           success:^(AFHTTPRequestOperation *operation, id responseObject) {
               completion(YES, nil, operation);
           }
           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               completion(NO, error, operation);
           }];
}


- (void)getPreviewURLsForFile:(LVCFile *)file
                        width:(NSUInteger)width
                       height:(NSUInteger)height
                   completion:(void (^)(NSArray *previewURLs,
                                        NSError *error,
                                        AFHTTPRequestOperation *operation))completion;
{
    NSParameterAssert(file);
    NSParameterAssert(width);
    NSParameterAssert(height);
    NSParameterAssert(completion);

    NSString *previewsPath = [file.urlPath stringByAppendingPathComponent:@"previews"];

    [self getPath:[LVCHTTPClient sanitizeRequestPath:previewsPath]
       parameters:@{@"w": @(width), @"h": @(height)}
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSMutableArray *previewURLs = @[].mutableCopy;
              if ([responseObject isKindOfClass:NSArray.class]) {
                  for (NSString *urlString in responseObject) {
                      NSURL *url = [NSURL URLWithString:urlString];
                      if (url) {
                          [previewURLs addObject:url];
                      }
                  }
              }
              completion(previewURLs.copy, nil, operation);
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              completion(nil, error, operation);
          }];
}


- (void)getFeebackForFile:(LVCFile *)file
                 revision:(NSUInteger)revision
               completion:(void (^)(NSArray *feedback,
                                    NSError *error,
                                    AFHTTPRequestOperation *operation))completion;
{
    NSParameterAssert(file);
    NSParameterAssert(revision);
    NSParameterAssert(completion);

    NSString *feedbackPath = [file.urlPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%lu", (unsigned long)revision]];
    feedbackPath = [feedbackPath stringByAppendingPathComponent:@"feedback_items"];

    [self getPath:[LVCHTTPClient sanitizeRequestPath:feedbackPath]
       parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSMutableArray *feedbackItems = @[].mutableCopy;
              if ([responseObject isKindOfClass:NSArray.class]) {
                  for (id jsonDictionary in responseObject) {
                      if (jsonDictionary == NSNull.null) {
                          [feedbackItems addObject:NSNull.null];
                          continue;
                      }

                      LVCFileRevisionFeedback *feedback = [MTLJSONAdapter modelOfClass:LVCFileRevisionFeedback.class
                                                                    fromJSONDictionary:jsonDictionary
                                                                                 error:nil];
                      if (feedback == nil) continue;

                      [feedbackItems addObject:feedback];
                  }
              }
              completion(feedbackItems.copy, nil, operation);
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              completion(nil, error, operation);
          }];
}


- (void)checkSyncStatusForFilePath:(NSString *)filePath
                               md5:(NSString *)md5
                        completion:(void (^)(LVCFileSyncStatus syncStatus,
                                             NSError *error,
                                             AFHTTPRequestOperation *operation))completion
{
    NSParameterAssert(filePath);
    NSParameterAssert(md5);
    NSParameterAssert(completion);

    NSString *syncCheckPath = [filePath stringByAppendingPathComponent:@"sync_check"];

    [self getPath:[self sanitizeRequestPath:syncCheckPath]
       parameters:@{@"md5": md5}
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              completion(LVCFileSyncStatusUploadOK, nil, operation);
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              LVCFileSyncStatus status = LVCFileSyncStatusError;
              if (operation.response.statusCode  == (LVCFileSyncStatusFileSizeMissing) ||
                  operation.response.statusCode  == (LVCFileSyncStatusFileTooLarge) ||
                  operation.response.statusCode  == (LVCFileSyncStatusUploadFullFile) ||
                  operation.response.statusCode  == (LVCFileSyncStatusUpToDate)) {
                  status = operation.response.statusCode;
              }
              completion(status, error, operation);
          }];
}


- (void)checkSyncStatusForFile:(LVCFile *)file
                    completion:(void (^)(LVCFileSyncStatus syncStatus,
                                         NSError *error,
                                         AFHTTPRequestOperation *operation))completion
{
    [self checkSyncStatusForFilePath:file.urlPath
                                 md5:file.md5
                          completion:completion];
}

#pragma mark - Revisions
- (void)getMetaDataForFileRevision:(LVCFileRevision *)fileRevision
                        completion:(void (^)(id fileMetaData,
                                             NSError *error,
                                             AFHTTPRequestOperation *operation))completion
{
    NSParameterAssert(fileRevision);
    NSParameterAssert(completion);

    NSString *metaPath = [fileRevision.urlPath stringByAppendingPathComponent:@"meta"];
    [self getPath:[LVCHTTPClient sanitizeRequestPath:metaPath]
       parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              completion(responseObject, nil, operation);
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              completion(nil, error, operation);
          }];
}


- (void)getPreviewURLsForRevision:(LVCFileRevision *)fileRevision
                            width:(NSUInteger)width
                           height:(NSUInteger)height
                       completion:(void (^)(NSArray *urls,
                                            NSError *error,
                                            AFHTTPRequestOperation *operation))completion
{
    NSParameterAssert(fileRevision);
    NSParameterAssert(width);
    NSParameterAssert(height);
    NSParameterAssert(completion);

    NSString *previewPath = [fileRevision.urlPath stringByAppendingPathComponent:@"previews"];
    [self getPath:[LVCHTTPClient sanitizeRequestPath:previewPath]
       parameters:@{@"w": @(width), @"h": @(height)}
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              // NOTE: I'm not too thrilled with how we handle failure cases
              // here. If we get data back that we're not expecting we just
              // return an empty array. If the server is sending back bad
              // data, we need to be able to catch and report this in a way
              // that doesn't crash the app but also in a way where the user
              // wont be affected
              NSMutableArray *urls = @[].mutableCopy;
              if ([responseObject isKindOfClass:NSArray.class]) {
                  for (NSString *urlString in responseObject) {
                      NSURL *url = [NSURL URLWithString:urlString];
                      if (url) {
                          [urls addObject:url];
                      }
                  }
              }
              completion(urls.copy, nil, operation);
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              completion(nil, error, operation);
          }];
}


#pragma mark - Cleanup Path
+ (NSString *)sanitizeRequestPath:(NSString *)path
{
    if ([[path substringToIndex:1] isEqualToString:@"/"]) {
        path = [path substringFromIndex:1];
    }
    return [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}


#pragma mark - Private Methods
- (NSString *)appendPath:(NSString *)path
               toProject:(LVCProject *)project
     includeOrganization:(BOOL)includeOrganization
{
    NSParameterAssert(path);
    NSParameterAssert(project);
    if (![[path substringToIndex:1] isEqualToString:@"/"]) {
        path = [NSString stringWithFormat:@"/%@", path];
    }

    return [NSString stringWithFormat:@"%@%@",
            [self pathForProject:project
             includeOrganization:includeOrganization],
            path];
}

- (NSString *)pathForProject:(LVCProject *)project
         includeOrganization:(BOOL)includeOrganization
{
    if (includeOrganization) {
        return [self pathForProjectName:project.name
                  organizationPermalink:project.organizationPermalink];
    }
    else {
        return project.name;
    }
}

- (NSString *)pathForProjectName:(NSString *)projectName
           organizationPermalink:(NSString *)organizationPermalink
{
    return [NSString stringWithFormat:@"%@/%@", organizationPermalink, projectName];
}

@end
