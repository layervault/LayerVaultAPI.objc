//
//  LVCFileRevisionTests.m
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 12/18/13.
//  Copyright (c) 2013 LayerVault. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <LayerVaultAPI/LVCFile.h>
#import <LayerVaultAPI/LVCFileRevision.h>
#import "LVCMockResponses.h"

@interface LVCFileRevisionTests : XCTestCase
@property (nonatomic, copy) NSDictionary *validJSON;
@end

@implementation LVCFileRevisionTests

- (void)setUp
{
    [super setUp];
    self.validJSON = LVCValidFileRevisionJSON();
}


- (void)testFileExcludedFromEquality
{
    LVCFile *file1 = [MTLJSONAdapter modelOfClass:LVCFile.class
                              fromJSONDictionary:@{@"name": @"oxchitl"}
                                           error:nil];
    XCTAssertNotNil(file1, @"file should not be nil");

    LVCFileRevision *revision1File1 = [MTLJSONAdapter modelOfClass:LVCFileRevision.class
                                                fromJSONDictionary:self.validJSON
                                                             error:nil];
    revision1File1.file = file1;
    XCTAssertNotNil(revision1File1, @"revision1File1 should not be nil");
    XCTAssertNotNil(revision1File1.file, @"should have parentFolder");

    LVCFile *file2 = [MTLJSONAdapter modelOfClass:LVCFile.class
                               fromJSONDictionary:@{@"name": @"sriracha"}
                                            error:nil];
    LVCFileRevision *revision1File2 = [MTLJSONAdapter modelOfClass:LVCFileRevision.class
                                                fromJSONDictionary:self.validJSON
                                                             error:nil];
    revision1File2.file = file2;
    XCTAssertNotNil(revision1File2, @"revision1File2 should not be nil");
    XCTAssertNotNil(revision1File2.file, @"should have file");

    XCTAssertNotEqual(revision1File2, revision1File1, @"different pointers");
    XCTAssertEqualObjects(revision1File2, revision1File1, @"objects equal");
    XCTAssertEqual(revision1File2.hash, revision1File1.hash, @"same hash");
    XCTAssertNotEqualObjects(revision1File2.description,
                             revision1File1.description,
                             @"Different Descriptions");
}


- (void)testURLPath
{
    LVCFile *file = [MTLJSONAdapter modelOfClass:LVCFile.class
                              fromJSONDictionary:@{@"name": @"foo-bar"}
                                           error:nil];
    LVCFileRevision *fileRevision = [MTLJSONAdapter modelOfClass:LVCFileRevision.class
                                              fromJSONDictionary:self.validJSON
                                                           error:nil];
    fileRevision.file = file;
    XCTAssertNotNil(fileRevision, @"fileRevision should not be nil");
    XCTAssertNotNil(fileRevision.file, @"should have file");

    XCTAssertEqualObjects(fileRevision.urlPath, @"foo-bar/4",
                          @"unexpected URL path");
}


@end
