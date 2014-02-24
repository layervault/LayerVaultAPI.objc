//
//  NSURLRequest+OAuth2Tests.m
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 2/24/14.
//  Copyright (c) 2014 LayerVault. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <LayerVaultAPI/LayerVaultAPI.h>

@interface NSURLRequest_OAuth2Tests : XCTestCase
@end

@implementation NSURLRequest_OAuth2Tests

- (void)testReturnsToken
{
    NSString *token = @"fje73ghf73jfh373";
    NSString *bearerHeader = [LVCBearerTokenPrefix stringByAppendingString:token];
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://layervult.com"]];
    [req setValue:bearerHeader forHTTPHeaderField:@"Authorization"];
    XCTAssertEqualObjects(token, [req lvc_bearerToken]);
}

- (void)testNoBearerByDefault
{
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://layervult.com"]];
    XCTAssertNil([req lvc_bearerToken]);
}

- (void)testLowerCaseBearerReturnsNil
{
    NSString *token = @"fje73ghf73jfh373";
    NSString *bearerHeader = [@"bearer" stringByAppendingString:token];
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://layervult.com"]];
    [req setValue:bearerHeader forHTTPHeaderField:@"Authorization"];
    XCTAssertNil([req lvc_bearerToken]);
    XCTAssertFalse([token isEqualToString:[req lvc_bearerToken]]);
}

- (void)testLowerCaseAuthReturnsToken
{
    NSString *token = @"fje73ghf73jfh373";
    NSString *bearerHeader = [LVCBearerTokenPrefix stringByAppendingString:token];
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://layervult.com"]];
    [req setValue:bearerHeader forHTTPHeaderField:@"authorization"];
    XCTAssertEqualObjects(token, [req lvc_bearerToken]);
}

- (void)testBadAuthReturnsNil
{
    NSString *token = @"fje73ghf73jfh373";
    NSString *bearerHeader = [LVCBearerTokenPrefix stringByAppendingString:token];
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://layervult.com"]];
    [req setValue:bearerHeader forHTTPHeaderField:@"Auuthorization"];
    XCTAssertNil([req lvc_bearerToken]);
    XCTAssertFalse([token isEqualToString:[req lvc_bearerToken]]);
}

@end
