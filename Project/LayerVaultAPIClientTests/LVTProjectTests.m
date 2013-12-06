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
@property (nonatomic, copy) NSDictionary *validJSON;
@end

@implementation LVTProjectTests

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
    LVTProject *project = [MTLJSONAdapter modelOfClass:LVTProject.class
                                    fromJSONDictionary:nil
                                                 error:nil];
    XCTAssertNil(project, @"user should be nil");
}


- (void)testProjectIsFolderSubclass
{
    LVTProject *project = [MTLJSONAdapter modelOfClass:LVTProject.class
                                    fromJSONDictionary:self.validJSON
                                                 error:nil];
    XCTAssertTrue([project isKindOfClass:LVTFolder.class], @"a project is a folder");
}


- (void)testValidJSON
{
    LVTProject *project = [MTLJSONAdapter modelOfClass:LVTProject.class
                                    fromJSONDictionary:self.validJSON
                                                 error:nil];
    XCTAssertNotNil(project, @"Project should not be nil");
}


@end
