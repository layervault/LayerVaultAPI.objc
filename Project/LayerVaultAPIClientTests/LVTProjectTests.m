//
//  LVTProjectTests.m
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 12/2/13.
//  Copyright (c) 2013 codecaffeine. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LVTProject.h"

@interface LVTProjectTests : XCTestCase

@end

@implementation LVTProjectTests

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testNilJSONNilProject
{
    LVTProject *project = [MTLJSONAdapter modelOfClass:LVTProject.class
                                    fromJSONDictionary:nil
                                                 error:nil];
    XCTAssertNil(project, @"user should be nil");
}


@end
