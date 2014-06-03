//
//  NSString+PercentEncodingTests.m
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 2/10/14.
//  Copyright (c) 2014 LayerVault. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <LayerVaultAPI/NSString+PercentEncoding.h>

@interface NSString_PercentEncodingTests : XCTestCase

@end

@implementation NSString_PercentEncodingTests

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

- (void)testPercentEncodingReservedCharacters
{
    XCTAssertEqualObjects([@"!#$&'()*+,/:;=?@[]" lv_stringWithFullPercentEncoding],
                          @"%21%23%24%26%27%28%29%2A%2B%2C%2F%3A%3B%3D%3F%40%5B%5D");
}

- (void)testUnreservedCharacters
{
    NSString *unreserved = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_.~";
    XCTAssertEqualObjects([unreserved lv_stringWithFullPercentEncoding], unreserved);
}

- (void)testCommonCharacters
{
    XCTAssertEqualObjects([@" \"%<>\\^`{|}" lv_stringWithFullPercentEncoding],
                          @"%20%22%25%3C%3E%5C%5E%60%7B%7C%7D");
}

- (void)testNewline
{
    XCTAssertEqualObjects([@"\n" lv_stringWithFullPercentEncoding],
                          @"%0A");
}

@end
