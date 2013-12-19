//
//  LVCFileTests.m
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 12/18/13.
//  Copyright (c) 2013 LayerVault. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <LayerVaultAPI/LVCFile.h>
#import <LayerVaultAPI/LVCFileRevision.h>
#import "LVCMockResponses.h"

@interface LVCFileTests : XCTestCase
@property (nonatomic, copy) NSDictionary *validJSON;
@end

@implementation LVCFileTests

- (void)setUp
{
    [super setUp];
    self.validJSON = LVCValidFileJSON();
}

- (void)testRevisionHasFile
{
    LVCFile *file = [MTLJSONAdapter modelOfClass:LVCFile.class
                              fromJSONDictionary:self.validJSON
                                           error:nil];
    XCTAssertNotNil(file, @"file should exist");
    XCTAssertEqual(file,
                   [file.revisions[0] file],
                   @"Revision should point to file");
}

- (void)testLookupByRevision
{
    LVCFile *file = [MTLJSONAdapter modelOfClass:LVCFile.class
                              fromJSONDictionary:self.validJSON
                                           error:nil];
    XCTAssertNotNil(file, @"file should exist");
    LVCFileRevision *revision = [file revisionWithNumber:@(4)];
    XCTAssertNotNil(file, @"file should exist");
    XCTAssertEqual(file,
                   revision.file,
                   @"Revision should point to file");
    XCTAssertEqual(revision,
                   file.revisions[0],
                   @"Should be the same");
}

@end
