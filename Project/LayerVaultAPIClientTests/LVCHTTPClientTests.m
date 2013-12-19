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

- (void)testValidProjectFromPartialGoodJSON
{
    [LVCMockURLConnection setJSONResponseWithStatusCode:200
                                         bodyDictionary:LVCValidProjectJSON()];

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
    XCTAssertEqualObjects(returnedProject, returnedProject2, @"should be equal objects");
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
                                    fromJSONDictionary:LVCValidProjectJSON()
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
                                    fromJSONDictionary:LVCValidProjectJSON()
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


@end
