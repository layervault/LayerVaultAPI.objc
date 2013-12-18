//
//  LVCFileRevisionFeedbackTests.m
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 12/18/13.
//  Copyright (c) 2013 LayerVault. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <LayerVaultAPI/LVCFileRevisionFeedback.h>

@interface LVCFileRevisionFeedbackTests : XCTestCase

@end

@implementation LVCFileRevisionFeedbackTests

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

- (void)testFrame
{
    NSDictionary *dict = @{@"top": @(10),
                           @"left": @(20),
                           @"bottom": @(30),
                           @"right": @(50)};
    LVCFileRevisionFeedback *feedback = [MTLJSONAdapter modelOfClass:LVCFileRevisionFeedback.class
                                                  fromJSONDictionary:dict
                                                               error:nil];
    XCTAssertEqual(feedback.feedbackFrame,
                   CGRectMake(10.0, 20.0, 30.0, 20.0), @"Size not correct");
}

@end
