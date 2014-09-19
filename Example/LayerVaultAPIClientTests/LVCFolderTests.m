//
//  LVCFolderTests.m
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 12/5/13.
//  Copyright (c) 2013 LayerVault. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <LayerVaultAPI/LVCFolder.h>
#import "LVCMockResponses.h"

@interface LVCFolderTests : XCTestCase
@property (nonatomic, copy) NSDictionary *validJSON;
@end

@implementation LVCFolderTests

- (void)setUp
{
    [super setUp];
    self.validJSON = LVCValidFolderJSON();
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
