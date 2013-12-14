//
//  LVCProjectTests.m
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 12/2/13.
//  Copyright (c) 2013 LayerVault. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LVCProject.h"

@interface LVCProjectTests : XCTestCase
@property (nonatomic, copy) NSDictionary *validJSON;
@end

@implementation LVCProjectTests

- (void)setUp
{
    [super setUp];
    self.validJSON = @{@"name": @"Mockups",
                       @"color": NSNull.null,
                       @"path": @"CodeCaffeine/awesome-o/Mockups",
                       @"local_path": @"~/LayerVault/awesome-o/Mockups",
                       @"updated_at": @"2013-11-20T20:11:10Z",
                       @"deleted_at": NSNull.null,
                       @"md5": NSNull.null,
                       @"full_url": @"https://layervault.com/codecaffeine/awesome-o/Mockups",
                       @"shortened_url": @"http://lyrv.lt/tLCF7qO9vE",
                       @"organization_permalink": @"layervault-test",
                       @"member": @NO,
                       @"folders": @[],
                       @"files": @[]};
}


- (void)testNilJSONNilProject
{
    LVCProject *project = [MTLJSONAdapter modelOfClass:LVCProject.class
                                    fromJSONDictionary:nil
                                                 error:nil];
    XCTAssertNil(project, @"user should be nil");
}


- (void)testProjectIsFolderSubclass
{
    LVCProject *project = [MTLJSONAdapter modelOfClass:LVCProject.class
                                    fromJSONDictionary:self.validJSON
                                                 error:nil];
    XCTAssertTrue([project isKindOfClass:LVCFolder.class], @"a project is a folder");
}


- (void)testValidJSON
{
    LVCProject *project = [MTLJSONAdapter modelOfClass:LVCProject.class
                                    fromJSONDictionary:self.validJSON
                                                 error:nil];
    XCTAssertNotNil(project, @"Project should not be nil");
}


@end
