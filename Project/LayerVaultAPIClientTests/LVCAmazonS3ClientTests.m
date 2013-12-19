//
//  LVCAmazonS3ClientTests.m
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 12/19/13.
//  Copyright (c) 2013 LayerVault. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <LayerVaultAPI/LVCAmazonS3Client.h>
#import "LVCAsyncHelper.h"
#import "LVCMockURLConnection.h"

@interface LVCAmazonS3ClientTests : XCTestCase
@property (nonatomic) LVCAmazonS3Client *client;
@end

@implementation LVCAmazonS3ClientTests

- (void)setUp
{
    [super setUp];
    [NSURLProtocol registerClass:[LVCMockURLConnection class]];
    self.client = [[LVCAmazonS3Client alloc] init];
}

- (void)testSuccessCalledOn200
{
    [LVCMockURLConnection setResponseWithStatusCode:200
                                       headerFields:nil
                                           bodyData:nil];

    __block BOOL done = NO;
    __block BOOL successCalled = NO;
    __block BOOL failureCalled = NO;
    [self.client postFile:[NSURL fileURLWithPath:@"/foo"]
               parameters:@{}
              accessToken:nil
                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                      successCalled = YES;
                      done = YES;
                  }
                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      failureCalled = YES;
                      done = YES;
                  }];

    [LVCAsyncHelper wait:0.2];
    XCTAssertTrue(done, @"done should have been called");
    XCTAssertTrue(successCalled, @"success should have been called");
    XCTAssertFalse(failureCalled, @"failure should have been called");
}

- (void)testFailureCalledOn400
{
    [LVCMockURLConnection setResponseWithStatusCode:400
                                       headerFields:nil
                                           bodyData:nil];

    __block BOOL done = NO;
    __block BOOL successCalled = NO;
    __block BOOL failureCalled = NO;
    [self.client postFile:[NSURL fileURLWithPath:@"/foo"]
               parameters:@{}
              accessToken:nil
                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                      successCalled = YES;
                      done = YES;
                  }
                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      failureCalled = YES;
                      done = YES;
                  }];

    [LVCAsyncHelper wait:0.2];
    XCTAssertTrue(done, @"done should have been called");
    XCTAssertFalse(successCalled, @"success should have been called");
    XCTAssertTrue(failureCalled, @"failure should have been called");
}


@end
