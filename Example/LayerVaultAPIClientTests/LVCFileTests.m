//
//  LVCFileTests.m
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 12/18/13.
//  Copyright (c) 2013 LayerVault. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <LayerVaultAPI/LVCFile.h>

@interface LVCFileTests : XCTestCase
@end

@implementation LVCFileTests

- (void)testValidJSON
{
    NSURL *fileURL = [NSURL fileURLWithPath:@"LayerVaultAPIClientTests/Test Files/Valid File.json"];
    NSData *data = [NSData dataWithContentsOfURL:fileURL];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                         options:0
                                                           error:nil];
    LVCFile *file = [MTLJSONAdapter modelOfClass:LVCFile.class fromJSONDictionary:dict error:nil];
    XCTAssertNotNil(file);
    XCTAssertEqualObjects(file.fileID, @"817542");
    XCTAssertEqualObjects(file.name, @"IMG_0001.JPG");
    XCTAssertEqualObjects(file.slug, @"img-0001--jpg");
    XCTAssertTrue(file.canEditNode);
    XCTAssertTrue(file.canCommentOnFile);
    XCTAssertEqualObjects(file.folderID, @"812674");
    XCTAssertEqual(file.revisionClusterIDs.count, (unsigned long)0);
    XCTAssertEqual(file.feedbackThreadIDs.count, (unsigned long)0);

#warning - LAZY
    XCTAssertNotNil(file.dateCreated);
    XCTAssertNotNil(file.dateModified);
    XCTAssertNil(file.dateDeleted);
}

@end
