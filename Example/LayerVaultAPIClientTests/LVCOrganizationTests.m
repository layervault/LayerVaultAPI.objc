//
//  LVCOrganizationTests.m
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 9/16/14.
//  Copyright (c) 2014 LayerVault. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>
#import "LVCOrganization.h"

@interface LVCOrganizationTests : XCTestCase

@end

@implementation LVCOrganizationTests

- (void)testValidJSON
{
    NSURL *fileURL = [NSURL fileURLWithPath:@"LayerVaultAPIClientTests/Test Files/Valid Org.json"];
    NSData *data = [NSData dataWithContentsOfURL:fileURL];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                         options:0
                                                           error:nil];
    LVCOrganization *org = [MTLJSONAdapter modelOfClass:LVCOrganization.class fromJSONDictionary:dict error:nil];
    XCTAssertNotNil(org);
    XCTAssertEqualObjects(org.organizationID, @"1307");
    XCTAssertEqualObjects(org.url, [NSURL URLWithString:@"https://layervault.com/codecaffeine"]);
    XCTAssertEqualObjects(org.name, @"CodeCaffeine");
    XCTAssertEqualObjects(org.slug, @"codecaffeine");
    XCTAssertTrue(org.isFree);
    XCTAssertNil(org.dateDeleted);
    XCTAssertNil(org.dateCancelled);
    XCTAssertEqual(org.syncType, LVCSyncTypeLayerVault);
    XCTAssertEqual(org.projectIDs.count, (unsigned long)20);

    XCTAssertEqual(org.administratorIDs.count, (unsigned long)1);
    XCTAssertEqual(org.editorIDs.count, (unsigned long)3);
    XCTAssertEqual(org.spectatorIDs.count, (unsigned long)0);

#warning - LAZY
    XCTAssertNotNil(org.dateCreated);
    XCTAssertNotNil(org.dateUpdated);
}

@end
