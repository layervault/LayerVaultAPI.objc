//
//  LVCColorUtilsTests.m
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 12/18/13.
//  Copyright (c) 2013 LayerVault. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <LayerVaultAPI/LVCColorUtils.h>

@interface LVCColorUtilsTests : XCTestCase

@end

@implementation LVCColorUtilsTests

- (void)testUnknownColorLabelIsNSWhite
{
    NSColor *color = [LVCColorUtils colorForLabel:NSUIntegerMax];
    XCTAssertEqualObjects(color, [NSColor whiteColor], @"should be white");
}

- (void)testUnknownColorLabelIsDefault
{
    NSString *color = [LVCColorUtils colorNameForLabel:NSUIntegerMax];
    XCTAssertEqualObjects(color, @"white",
                          @"should be white");
}

- (void)testRedStringGivesRedColorLabel
{
    LVCColorLabel label = [LVCColorUtils colorLabelForName:@"red"];
    XCTAssertEqual(label, LVCColorRed, @"colors should be the same");
}


- (void)testUnknownStringGivesWhiteColorLabel
{
    LVCColorLabel label = [LVCColorUtils colorLabelForName:@"foobar"];
    XCTAssertEqual(label, LVCColorWhite, @"unknown string should give white");
}

@end
