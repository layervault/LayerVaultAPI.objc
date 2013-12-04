//
//  LVTHTTPClient.m
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 10/13/13.
//  Copyright (c) 2013 codecaffeine. All rights reserved.
//

#import "LVTHTTPClient.h"
#import <Mantle/Mantle.h>
#import <AFNetworking/AFJSONRequestOperation.h>
#import "LVTUser.h"
#import "LVTOrganization.h"
#import "LVTProject.h"


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

    [self deletePath:[self pathForProject:project]
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

    NSString *movePath = [[self pathForProject:project] stringByAppendingString:@"/move"];
    // warning: stringByAddingPercentEscapesUsingEncoding: can return nil
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

    [self putPath:[[self pathForProject:project] stringByAppendingString:@"/color"]
       parameters:@{@"color": [LVTColorUtils colorNameForLabel:colorLabel]}
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              project.colorLabel = colorLabel;
              block(YES, Nil, operation);
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              block(NO, error, operation);
          }];
}


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


#pragma mark - Private Methods
- (NSString *)pathForProject:(LVTProject *)project
{
    return [self pathForProjectName:project.name
              organizationPermalink:project.organizationPermalink];
}

- (NSString *)pathForProjectName:(NSString *)projectName
                organizationPermalink:(NSString *)organizationPermalink
{
    return [NSString stringWithFormat:@"%@/%@",
            [organizationPermalink stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
            [projectName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
}

@end
