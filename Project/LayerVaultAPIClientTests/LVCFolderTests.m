//
//  LVCFolderTests.m
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 12/5/13.
//  Copyright (c) 2013 LayerVault. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LVCFolder.h"

@interface LVCFolderTests : XCTestCase
@property (nonatomic, copy) NSDictionary *validJSON;
@end

@implementation LVCFolderTests

- (void)setUp
{
    [super setUp];
    self.validJSON = @{@"name": @"oxchitl",
                       @"color": NSNull.null,
                       @"path": @"awesome-sauce/oxchitl",
                       @"local_path": @"~/LayerVault/oxchitl",
                       @"updated_at": @"2013-11-20T20:11:10Z",
                       @"deleted_at": NSNull.null,
                       @"md5": NSNull.null,
                       @"full_url": @"https://layervault.com/awesome-sauce/oxchitl",
                       @"shortened_url": @"http://lyrv.lt/DEADBEEF",
                       @"organization_permalink": @"awesome-sauce",
                       @"folders": @[],
                       @"files": @[]};
}


- (void)testNilJSONNilFolder
{
    LVCFolder *folder = [MTLJSONAdapter modelOfClass:LVCFolder.class
                                  fromJSONDictionary:nil
                                               error:nil];
    XCTAssertNil(folder, @"folder should be nil");
}


- (void)testEmptyJSONNilFolder
{
    LVCFolder *folder = [MTLJSONAdapter modelOfClass:LVCFolder.class
                                  fromJSONDictionary:@{}
                                               error:nil];
    XCTAssertNil(folder, @"folder should be nil");
}


- (void)testNoNameNilFolder
{
    NSMutableDictionary *noName = self.validJSON.mutableCopy;
    [noName removeObjectForKey:@"name"];
    LVCFolder *folder = [MTLJSONAdapter modelOfClass:LVCFolder.class
                                  fromJSONDictionary:noName
                                               error:nil];
    XCTAssertNil(folder, @"folder should be nil");
}


- (void)testValidJSONValidFolder
{
    LVCFolder *folder = [MTLJSONAdapter modelOfClass:LVCFolder.class
                                  fromJSONDictionary:self.validJSON
                                               error:nil];
    XCTAssertNotNil(folder, @"folder should not be nil");

}


- (void)testNilColorWhiteLabel
{
    LVCFolder *folder = [MTLJSONAdapter modelOfClass:LVCFolder.class
                                  fromJSONDictionary:self.validJSON
                                               error:nil];
    XCTAssertEqual(folder.colorLabel,
                   LVCColorWhite, @"Should be white color label");
}


- (void)testUnknownColorWhiteLabel
{
    NSMutableDictionary *weirdColor = self.validJSON.mutableCopy;
    weirdColor[@"color"] = @"puce";
    LVCFolder *folder = [MTLJSONAdapter modelOfClass:LVCFolder.class
                                  fromJSONDictionary:weirdColor
                                               error:nil];
    XCTAssertEqual(folder.colorLabel,
                   LVCColorWhite, @"Should be white color label");
}


- (void)testCorrectColorLabel
{
    NSMutableDictionary *greenColor = self.validJSON.mutableCopy;
    greenColor[@"color"] = @"green";
    LVCFolder *folder = [MTLJSONAdapter modelOfClass:LVCFolder.class
                                  fromJSONDictionary:greenColor
                                               error:nil];
    XCTAssertEqual(folder.colorLabel,
                   LVCColorGreen, @"Should be white color label");
}


@end
