//
//  LVTFolderTests.m
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 12/5/13.
//  Copyright (c) 2013 codecaffeine. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LVTFolder.h"

@interface LVTFolderTests : XCTestCase
@property (nonatomic, copy) NSDictionary *validJSON;
@end

@implementation LVTFolderTests

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
                       @"organization_permalink": NSNull.null,
                       @"folders": @[],
                       @"files": @[]};
}


- (void)testNilJSONNilFolder
{
    LVTFolder *folder = [MTLJSONAdapter modelOfClass:LVTFolder.class
                                  fromJSONDictionary:nil
                                               error:nil];
    XCTAssertNil(folder, @"folder should be nil");
}


- (void)testEmptyJSONNilFolder
{
    LVTFolder *folder = [MTLJSONAdapter modelOfClass:LVTFolder.class
                                  fromJSONDictionary:@{}
                                               error:nil];
    XCTAssertNil(folder, @"folder should be nil");
}


- (void)testNoNameNilFolder
{
    NSMutableDictionary *noName = self.validJSON.mutableCopy;
    [noName removeObjectForKey:@"name"];
    LVTFolder *folder = [MTLJSONAdapter modelOfClass:LVTFolder.class
                                  fromJSONDictionary:noName
                                               error:nil];
    XCTAssertNil(folder, @"folder should be nil");
}


- (void)testValidJSONValidFolder
{
    LVTFolder *folder = [MTLJSONAdapter modelOfClass:LVTFolder.class
                                  fromJSONDictionary:self.validJSON
                                               error:nil];
    XCTAssertNotNil(folder, @"folder should not be nil");

}


@end
