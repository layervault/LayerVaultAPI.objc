//
//  NSMutableURLRequest+OAuth2Tests.m
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 2/24/14.
//  Copyright (c) 2014 LayerVault. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <LayerVaultAPI/LayerVaultAPI.h>

@interface NSMutableURLRequest_OAuth2Tests : XCTestCase
@end

@implementation NSMutableURLRequest_OAuth2Tests

- (void)testSettingTokenSucceed
{
    NSString *token = @"AMANAPLANACANALPANAMA";
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://layervault.com"]];
    [req lvc_setBearerToken:token];
    XCTAssertEqualObjects(req.allHTTPHeaderFields[@"Authorization"],
                          [LVCBearerTokenPrefix stringByAppendingString:token]);
}

- (void)testSettingBlankTokenNilAuthorizationHeader
{
    NSString *token = @"";
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://layervault.com"]];
    [req lvc_setBearerToken:token];
    XCTAssertNil(req.allHTTPHeaderFields[@"Authorization"]);
}

- (void)testSettingNilTokenNilAuthorizationHeader
{
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://layervault.com"]];
    [req lvc_setBearerToken:nil];
    XCTAssertNil(req.allHTTPHeaderFields[@"Authorization"]);
}

@end
