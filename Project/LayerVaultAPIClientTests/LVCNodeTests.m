//
//  LVCNodeTests.m
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 12/18/13.
//  Copyright (c) 2013 LayerVault. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <LayerVaultAPI/LVCFolder.h>

@interface LVCNodeTests : XCTestCase
@property (nonatomic, copy) NSDictionary *validJSON;
@end

@implementation LVCNodeTests

- (void)setUp
{
    [super setUp];
    self.validJSON = @{@"name": @"Mockups",
                       @"local_path": @"~/LayerVault/awesome-o/Mockups",
                       @"updated_at": @"2013-11-20T20:11:10Z",
                       @"deleted_at": NSNull.null,
                       @"md5": NSNull.null,
                       @"full_url": @"https://layervault.com/codecaffeine/awesome-o/Mockups",
                       @"shortened_url": @"http://lyrv.lt/tLCF7qO9vE"};
}


- (void)testParentFolderExcludedFromEquality
{
    NSDictionary *folderJSON = @{@"name": @"parentFolder"};
    LVCFolder *parentFolder = [MTLJSONAdapter modelOfClass:LVCFolder.class
                                        fromJSONDictionary:folderJSON
                                                     error:nil];
    XCTAssertNotNil(parentFolder, @"parent folder should not be nil");

    LVCNode *nodeWithFolder = [MTLJSONAdapter modelOfClass:LVCNode.class
                                        fromJSONDictionary:self.validJSON
                                                     error:nil];
    nodeWithFolder.parentFolder = parentFolder;
    XCTAssertNotNil(nodeWithFolder, @"nodeWithFolder should not be nil");
    XCTAssertNotNil(nodeWithFolder.parentFolder, @"should have parentFolder");

    LVCNode *nodeWithoutFolder = [MTLJSONAdapter modelOfClass:LVCNode.class
                                           fromJSONDictionary:self.validJSON
                                                        error:nil];
    XCTAssertNotNil(nodeWithoutFolder, @"nodeWithFolder should not be nil");
    XCTAssertNil(nodeWithoutFolder.parentFolder, @"should not have parent folder");

    XCTAssertNotEqual(nodeWithoutFolder, nodeWithFolder, @"different pointers");
    XCTAssertEqualObjects(nodeWithoutFolder, nodeWithFolder, @"objects equal");
    XCTAssertEqual(nodeWithoutFolder.hash, nodeWithFolder.hash, @"same hash");
    XCTAssertNotEqualObjects(nodeWithoutFolder.description,
                             nodeWithFolder.description,
                             @"Different Descriptions");
}


- (void)testParentFolderPartOfURLPath
{
    NSDictionary *folderJSON = @{@"name": @"foo-bar"};
    LVCFolder *parentFolder = [MTLJSONAdapter modelOfClass:LVCFolder.class
                                        fromJSONDictionary:folderJSON
                                                     error:nil];
    LVCNode *node = [MTLJSONAdapter modelOfClass:LVCNode.class
                              fromJSONDictionary:self.validJSON
                                           error:nil];
    node.parentFolder = parentFolder;
    XCTAssertNotNil(node, @"nodeWithFolder should not be nil");
    XCTAssertNotNil(node.parentFolder, @"should have parentFolder");

    XCTAssertEqualObjects(node.urlPath, @"foo-bar/Mockups",
                          @"unexpected URL path");
}

- (void)testURLPathWithNoParentFolder
{
    LVCNode *node = [MTLJSONAdapter modelOfClass:LVCNode.class
                              fromJSONDictionary:self.validJSON
                                           error:nil];
    XCTAssertNotNil(node, @"nodeWithFolder should not be nil");
    XCTAssertNil(node.parentFolder, @"should not have parentFolder");

    XCTAssertEqualObjects(node.urlPath, @"Mockups", @"unexpected URL path");
}


@end
