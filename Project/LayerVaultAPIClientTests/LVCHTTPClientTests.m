//
//  LVCHTTPClientTests.m
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 12/19/13.
//  Copyright (c) 2013 LayerVault. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <LayerVaultAPI/LayerVaultAPI.h>
#import "LVCAsyncHelper.h"
#import "LVCMockURLConnection.h"
#import "LVCMockResponses.h"

@interface LVCHTTPClientTests : XCTestCase
@property (nonatomic) LVCHTTPClient *client;
@end

@implementation LVCHTTPClientTests

- (void)setUp
{
    [super setUp];
    [NSURLProtocol registerClass:[LVCMockURLConnection class]];
    self.client = [[LVCHTTPClient alloc] initWithClientID:@"CLIENT ID"
                                                   secret:@"CLIENT SECRET"];
}

- (void)tearDown
{
    [NSURLProtocol unregisterClass:[LVCMockURLConnection class]];
    [super tearDown];
}

- (void)testValidProjectFromPartialGoodJSON
{
    [LVCMockURLConnection setJSONResponseWithStatusCode:200
                                         bodyDictionary:LVCValidProjectPartialJSON()];

    __block LVCProject *returnedProject = nil;
    __block NSError *returnedError = nil;
    [self.client getProjectWithName:LVCMockProjectName
              organizationPermalink:LVCMockOrgPermalink
                         completion:^(LVCProject *project,
                                      NSError *error,
                                      AFHTTPRequestOperation *operation) {
                             returnedProject = project;
                             returnedError = nil;
                         }];
    [LVCAsyncHelper wait:0.1];
    XCTAssertNotNil(returnedProject, @"should have returned an project");
    XCTAssertNil(returnedError, @"should not have returned an error");


    [LVCMockURLConnection setJSONResponseWithStatusCode:200
                                         bodyDictionary:LVCValidProjectJSON()];
    __block LVCProject *returnedProject2 = nil;
    returnedError = nil;
    [self.client getProjectFromPartial:returnedProject
                            completion:^(LVCProject *project,
                                         NSError *error,
                                         AFHTTPRequestOperation *operation) {
                                returnedProject2 = project;
                                returnedError = error;
                            }];
    [LVCAsyncHelper wait:0.1];
    XCTAssertNotNil(returnedProject2, @"should have returned an project");
    // Partial projects don't equal full project
    XCTAssertNotEqualObjects(returnedProject, returnedProject2, @"should be equal objects");
    XCTAssertNil(returnedError, @"should not have returned an error");
}

- (void)testNilProjectFromPartialBadJSON
{
    [LVCMockURLConnection setJSONResponseWithStatusCode:200
                                         bodyDictionary:@{@"foo": @"bar"}];

    __block LVCProject *returnedProject = nil;
    [self.client getProjectWithName:LVCMockProjectName
              organizationPermalink:LVCMockOrgPermalink
                         completion:^(LVCProject *project,
                                      NSError *error,
                                      AFHTTPRequestOperation *operation) {
                             returnedProject = project;
                         }];
    [LVCAsyncHelper wait:0.1];
    XCTAssertNil(returnedProject, @"should not have returned an project");

    LVCProject *project = [MTLJSONAdapter modelOfClass:LVCProject.class
                                    fromJSONDictionary:LVCValidProjectPartialJSON()
                                                 error:nil];
    [self.client getProjectFromPartial:project
                            completion:^(LVCProject *project,
                                         NSError *error,
                                         AFHTTPRequestOperation *operation) {
                                returnedProject = project;
                            }];
    [LVCAsyncHelper wait:0.1];
    XCTAssertNil(returnedProject, @"should not have returned an project");
}


- (void)testNilProjectFromPartialBadResponse
{
    [LVCMockURLConnection setResponseWithStatusCode:400
                                       headerFields:nil
                                           bodyData:nil];

    __block LVCProject *returnedProject = nil;
    [self.client getProjectWithName:LVCMockProjectName
              organizationPermalink:LVCMockOrgPermalink
                         completion:^(LVCProject *project,
                                      NSError *error,
                                      AFHTTPRequestOperation *operation) {
                             returnedProject = project;
                         }];
    [LVCAsyncHelper wait:0.1];
    XCTAssertNil(returnedProject, @"should not have returned an project");

    LVCProject *project = [MTLJSONAdapter modelOfClass:LVCProject.class
                                    fromJSONDictionary:LVCValidProjectPartialJSON()
                                                 error:nil];
    [self.client getProjectFromPartial:project
                            completion:^(LVCProject *project,
                                         NSError *error,
                                         AFHTTPRequestOperation *operation) {
                                returnedProject = project;
                            }];
    [LVCAsyncHelper wait:0.1];
    XCTAssertNil(returnedProject, @"should not have returned an project");
}


- (void)testMoveFileNewName
{
    [LVCMockURLConnection setResponseWithStatusCode:200
                                       headerFields:nil
                                           bodyData:nil];

    __block AFHTTPRequestOperation *returnedOp = nil;
    [self.client moveFileAtPath:@"foo/bar/file.jpg"
                         toPath:@"bar/rename.jpg"
                     completion:^(BOOL success,
                                  NSError *error,
                                  AFHTTPRequestOperation *operation) {
                         returnedOp = operation;
                     }];
    [LVCAsyncHelper wait:0.1];
    XCTAssertNotNil(returnedOp, @"should have returned an operation");
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:returnedOp.request.HTTPBody
                                                         options:0
                                                           error:nil];
    XCTAssertEqualObjects(dict[@"to"], @"bar", @"to should be bar");
    XCTAssertEqualObjects(dict[@"new_file_name"], @"rename.jpg", @"to should be rename.jpg");
}

- (void)testMoveFileSameNameNewPath
{
    [LVCMockURLConnection setResponseWithStatusCode:200
                                       headerFields:nil
                                           bodyData:nil];

    __block AFHTTPRequestOperation *returnedOp = nil;
    [self.client moveFileAtPath:@"foo/bar/file.jpg"
                         toPath:@"baz/file.jpg"
                     completion:^(BOOL success,
                                  NSError *error,
                                  AFHTTPRequestOperation *operation) {
                         returnedOp = operation;
                     }];
    [LVCAsyncHelper wait:0.1];
    XCTAssertNotNil(returnedOp, @"should have returned an operation");
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:returnedOp.request.HTTPBody
                                                         options:0
                                                           error:nil];
    XCTAssertEqualObjects(dict[@"to"], @"baz", @"to should be baz");
    XCTAssertNil(dict[@"new_file_name"], @"to should be nil");
}


- (void)testMoveFileSameNameRootOrg
{
    [LVCMockURLConnection setResponseWithStatusCode:200
                                       headerFields:nil
                                           bodyData:nil];

    __block AFHTTPRequestOperation *returnedOp = nil;
    [self.client moveFileAtPath:@"foo/bar/file.jpg"
                         toPath:@"file.jpg"
                     completion:^(BOOL success,
                                  NSError *error,
                                  AFHTTPRequestOperation *operation) {
                         returnedOp = operation;
                     }];
    [LVCAsyncHelper wait:0.1];
    XCTAssertNotNil(returnedOp, @"should have returned an operation");
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:returnedOp.request.HTTPBody
                                                         options:0
                                                           error:nil];
    XCTAssertEqualObjects(dict[@"to"], @"", @"to should be empty string");
    XCTAssertNil(dict[@"new_file_name"], @"to should be nil");
}

@end
