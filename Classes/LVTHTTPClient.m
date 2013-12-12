//
//  LVTHTTPClient.m
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 10/13/13.
//  Copyright (c) 2013 codecaffeine. All rights reserved.
//

#import "LVTHTTPClient.h"
#import <CommonCrypto/CommonDigest.h>
#import <Mantle/Mantle.h>
#import <AFNetworking/AFJSONRequestOperation.h>
#import "LVTUser.h"
#import "LVTOrganization.h"
#import "LVTProject.h"
#import "LVTAmazonS3Client.h"


static NSString *md5ForFile(NSURL *fileURL)
{
    NSError *error;
    NSData *data = [NSData dataWithContentsOfURL:fileURL
                                         options:NSDataReadingMappedIfSafe
                                           error:&error];
    if (!data) {
        NSLog(@"%@", error);
        return nil;
    }

    unsigned char md[CC_MD5_DIGEST_LENGTH];
    CC_MD5([data bytes], (unsigned int)[data length], md);
    NSMutableString *md5 = [NSMutableString string];
    for (NSUInteger i = 0; i < CC_MD5_DIGEST_LENGTH; ++i) {
        [md5 appendFormat:@"%02x", md[i]];
    }

    return md5;
}

@implementation LVTHTTPClient

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
    return [self initWithBaseURL:[NSURL URLWithString:@"https://api.layervault.com/api/v1/"]
                        clientID:clientID
                          secret:secret];
}


#pragma mark - Authentication
- (void)authenticateWithEmail:(NSString *)email
                     password:(NSString *)password
                   completion:(void (^)(AFOAuthCredential *credential, NSError *error))completion
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
- (void)getMeWithBlock:(void (^)(LVTUser *user, NSError *error, AFHTTPRequestOperation *operation))block
{
    NSParameterAssert(block);

    [self getPath:@"me"
       parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSError *error = nil;
              LVTUser *user = [MTLJSONAdapter modelOfClass:LVTUser.class
                                        fromJSONDictionary:responseObject
                                                     error:&error];
              block(user, error, operation);
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              block(nil, error, operation);
          }];
}


#pragma mark - Organizations
- (void)getOrganizationWithParmalink:(NSString *)permalink
                               block:(void (^)(LVTOrganization *organization,
                                               NSError *error,
                                               AFHTTPRequestOperation *operation))block
{
    NSParameterAssert(permalink);
    NSParameterAssert(block);

    [self getPath:[permalink stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
       parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSError *error;
              LVTOrganization *org = [MTLJSONAdapter modelOfClass:LVTOrganization.class
                                               fromJSONDictionary:responseObject
                                                            error:&error];
              block(org, error, operation);
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              block(nil, error, operation);
          }];
}


#pragma mark - Projects
- (void)getProjectFromPartial:(LVTProject *)project
                   completion:(void (^)(LVTProject *project,
                                        NSError *error,
                                        AFHTTPRequestOperation *operation))block
{
    NSParameterAssert(project);
    NSParameterAssert(block);

    [self getProjectWithName:project.name
       organizationPermalink:project.organizationPermalink
                       block:block];
}


- (void)getProjectWithName:(NSString *)projectName
            inOrganization:(LVTOrganization *)organization
                     block:(void (^)(LVTProject *project,
                                     NSError *error,
                                     AFHTTPRequestOperation *operation))block
{
    [self getProjectWithName:projectName
       organizationPermalink:organization.permalink
                       block:block];
}


- (void)getProjectWithName:(NSString *)projectName
     organizationPermalink:(NSString *)organizationPermalink
                     block:(void (^)(LVTProject *project,
                                     NSError *error,
                                     AFHTTPRequestOperation *operation))block
{
    NSParameterAssert(projectName);
    NSParameterAssert(organizationPermalink);
    NSParameterAssert(block);

    NSString *projectPath = [self pathForProjectName:projectName
                               organizationPermalink:organizationPermalink];

    projectPath = [projectPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    [self getPath:projectPath
       parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSError *error;
              LVTProject *project = [MTLJSONAdapter modelOfClass:LVTProject.class
                                              fromJSONDictionary:responseObject
                                                           error:&error];
              block(project, error, operation);
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              block(nil, error, operation);
          }];
}


- (void)createProjectWithName:(NSString *)projectName
        organizationPermalink:(NSString *)organizationPermalink
                   completion:(void (^)(LVTProject *project,
                                        NSError *error,
                                        AFHTTPRequestOperation *operation))block
{
    NSParameterAssert(projectName);
    NSParameterAssert(organizationPermalink);
    NSParameterAssert(block);

    NSString *projectPath = [self pathForProjectName:projectName
                               organizationPermalink:organizationPermalink];

    projectPath = [projectPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    [self postPath:projectPath
        parameters:nil
           success:^(AFHTTPRequestOperation *operation, id responseObject) {
               NSError *error;
               LVTProject *project = [MTLJSONAdapter modelOfClass:LVTProject.class
                                               fromJSONDictionary:responseObject
                                                            error:&error];
               block(project, error, operation);
           }
           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               block(nil, error, operation);
           }];

}


- (void)deleteProject:(LVTProject *)project
           completion:(void (^)(BOOL success,
                                NSError *error,
                                AFHTTPRequestOperation *operation))block
{
    NSParameterAssert(project);
    NSParameterAssert(block);

    NSString *projectPath = [self pathForProject:project includeOrganization:YES];
    projectPath = [projectPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    [self deletePath:projectPath
          parameters:nil
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 block(YES, nil, operation);
             }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 block(NO, error, operation);
             }];
}


- (void)moveProject:(LVTProject *)project
      toDestination:(NSString *)destination
         completion:(void (^)(LVTProject *project,
                              NSError *error,
                              AFHTTPRequestOperation *operation))block
{
    NSParameterAssert(project);
    NSParameterAssert(destination);
    NSParameterAssert(block);

    NSString *movePath = [[self pathForProject:project
                           includeOrganization:YES] stringByAppendingPathComponent:@"move"];
    movePath = [movePath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    NSDictionary *params = @{@"to": destination};

    [self postPath:movePath
        parameters:params
           success:^(AFHTTPRequestOperation *operation, id responseObject) {
               NSError *error;
               LVTProject *project = [MTLJSONAdapter modelOfClass:LVTProject.class
                                               fromJSONDictionary:responseObject
                                                            error:&error];
               block(project, error, operation);
           }
           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               block(nil, error, operation);
           }];
}


- (void)updateProject:(LVTProject *)project
           colorLabel:(LVTColorLabel)colorLabel
           completion:(void (^)(BOOL success,
                                NSError *error,
                                AFHTTPRequestOperation *operation))block
{
    NSParameterAssert(project);
    NSParameterAssert(block);

    NSLog(@"updating color %@ \u2192 %@",
          [LVTColorUtils colorNameForLabel:project.colorLabel],
          [LVTColorUtils colorNameForLabel:colorLabel]);

    NSString *colorPath = [[self pathForProject:project
                           includeOrganization:YES] stringByAppendingPathComponent:@"color"];
    colorPath = [colorPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    NSDictionary *params = @{@"color": [LVTColorUtils colorNameForLabel:colorLabel]};

    [self putPath:colorPath
       parameters:params
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              project.colorLabel = colorLabel;
              project.dateUpdated = [NSDate date];
              block(YES, Nil, operation);
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              block(NO, error, operation);
          }];
}


#pragma mark - Folders
- (void)getFolderAtPath:(NSString *)path
             completion:(void (^)(LVTFolder *folder,
                                  NSError *error,
                                  AFHTTPRequestOperation *operation))completion
{
    NSParameterAssert(path);
    NSParameterAssert(completion);

    path = [self sanitizeRequestPath:path];

    [self getPath:path
       parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSError *error;
              LVTFolder *folder = [MTLJSONAdapter modelOfClass:LVTFolder.class
                                            fromJSONDictionary:responseObject
                                                         error:&error];
              completion(folder, error, operation);
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              completion(nil, error, operation);
          }];
}

- (void)getFolderAtPath:(NSString *)path
              inProject:(LVTProject *)project
             completion:(void (^)(LVTFolder *folder,
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


- (void)createFolderAtPath:(NSString *)path
                 inProject:(LVTProject *)project
                completion:(void (^)(LVTFolder *folder,
                                     NSError *error,
                                     AFHTTPRequestOperation *operation))completion
{
    NSParameterAssert(path);
    NSParameterAssert(project);
    NSParameterAssert(completion);

    NSString *folderPath = [self appendPath:path
                                  toProject:project
                        includeOrganization:YES];
    folderPath = [self sanitizeRequestPath:folderPath];

    [self postPath:folderPath
        parameters:nil
           success:^(AFHTTPRequestOperation *operation, id responseObject) {
               NSError *error;
               LVTFolder *folder = [MTLJSONAdapter modelOfClass:LVTFolder.class
                                             fromJSONDictionary:responseObject
                                                          error:&error];
               completion(folder, error, operation);
           }
           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               completion(nil, error, operation);
           }];

}


- (void)deleteFolder:(LVTFolder *)folder
          completion:(void (^)(BOOL success,
                               NSError *error,
                               AFHTTPRequestOperation *operation))completion
{
    NSParameterAssert(folder);
    NSParameterAssert(completion);

    [self deletePath:folder.urlPath
          parameters:nil
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 completion(YES, nil, operation);
             }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 completion(NO, error, operation);
             }];
}


- (void)moveFolder:(LVTFolder *)folder
            toPath:(NSString *)toPath
         inProject:(LVTProject *)project
        completion:(void (^)(LVTFolder *folder,
                             NSError *error,
                             AFHTTPRequestOperation *operation))completion
{
    toPath = [self appendPath:toPath
                    toProject:project
          includeOrganization:NO];

    NSParameterAssert(folder);
    NSParameterAssert(toPath);
    NSParameterAssert(project);
    NSParameterAssert(completion);

    NSString *movePath = [folder.urlPath stringByAppendingPathComponent:@"move"];

    [self postPath:movePath
        parameters:@{@"to": toPath}
           success:^(AFHTTPRequestOperation *operation, id responseObject) {
               NSError *error;
               LVTFolder *folder = [MTLJSONAdapter modelOfClass:LVTFolder.class
                                             fromJSONDictionary:responseObject
                                                          error:&error];
               completion(folder, error, operation);
           }
           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               completion(nil, error, operation);
           }];
}


- (void)updateFolder:(LVTFolder *)folder
          colorLabel:(LVTColorLabel)colorLabel
          completion:(void (^)(BOOL success,
                               NSError *error,
                               AFHTTPRequestOperation *operation))completion
{
    NSParameterAssert(folder);
    NSParameterAssert(completion);

    NSString *colorPath = [folder.urlPath stringByAppendingPathComponent:@"color"];

    NSDictionary *params = @{@"color": [LVTColorUtils colorNameForLabel:colorLabel]};

    [self putPath:colorPath
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
           completion:(void (^)(LVTFile *file,
                                NSError *error,
                                AFHTTPRequestOperation *operation))completion
{
    NSParameterAssert(filePath);
    NSParameterAssert(completion);

    filePath = [self sanitizeRequestPath:filePath];

    [self getPath:filePath
       parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSError *error;
              LVTFile *file = [MTLJSONAdapter modelOfClass:LVTFile.class
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
              inProject:(LVTProject *)project
             completion:(void (^)(LVTFile *file,
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

- (void)uploadLocalFile:(NSURL *)localFileURL
                 toPath:(NSString *)filePath
             completion:(void (^)(LVTFile *file,
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

    NSString *md5 = md5ForFile(localFileURL);
    NSDictionary *params = nil;
    if (md5) {
        params = @{@"md5":md5};
    }

    if (md5) {
        [self putPath:filePath
           parameters:params
              success:^(AFHTTPRequestOperation *operation, id responseObject) {

                  AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:self.serviceProviderIdentifier];

                  LVTAmazonS3Client *s3Client = [LVTAmazonS3Client new];
                  [s3Client postFile:localFileURL
                          parameters:responseObject
                         accessToken:credential.accessToken
                             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                 NSError *error;
                                 LVTFile *file = [MTLJSONAdapter modelOfClass:LVTFile.class
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

#pragma mark - Private Methods
- (NSString *)sanitizeRequestPath:(NSString *)path
{
    if ([[path substringToIndex:1] isEqualToString:@"/"]) {
        path = [path substringFromIndex:1];
    }
    return [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}


- (NSString *)appendPath:(NSString *)path
               toProject:(LVTProject *)project
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

- (NSString *)pathForProject:(LVTProject *)project
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
