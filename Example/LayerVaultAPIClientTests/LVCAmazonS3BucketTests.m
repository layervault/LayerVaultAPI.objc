//
//  LVCAmazonS3BucketTests.m
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 2/13/14.
//  Copyright (c) 2014 LayerVault. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <LayerVaultAPI/LVCAmazonS3Bucket.h>

@interface LVCAmazonS3BucketTests : XCTestCase

@end

@implementation LVCAmazonS3BucketTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testNilTimezoneReturnOmnivoreScratch
{
    NSURL *url = [LVCAmazonS3Bucket baseURLForTimezone:nil];
    XCTAssertEqualObjects(url, [NSURL URLWithString:@"https://omnivore-scratch.s3.amazonaws.com"]);
}

- (void)testSidnetTimezone
{
    NSURL *url = [LVCAmazonS3Bucket baseURLForTimezone:[NSTimeZone timeZoneWithName:@"Australia/Sydney"]];
    XCTAssertEqualObjects(url, [NSURL URLWithString:@"https://omnivore-scratch-australia.s3.amazonaws.com"]);
}

- (void)testNYCTimezone
{
    NSURL *url = [LVCAmazonS3Bucket baseURLForTimezone:[NSTimeZone timeZoneWithName:@"America/New_York"]];
    XCTAssertEqualObjects(url, [NSURL URLWithString:@"https://omnivore-scratch.s3.amazonaws.com"]);
}


- (void)testDushanbeTimezone
{
    NSURL *url = [LVCAmazonS3Bucket baseURLForTimezone:[NSTimeZone timeZoneWithName:@"Asia/Dushanbe"]];
    XCTAssertEqualObjects(url, [NSURL URLWithString:@"https://omnivore-scratch-singapore.s3.amazonaws.com"]);
}


@end
