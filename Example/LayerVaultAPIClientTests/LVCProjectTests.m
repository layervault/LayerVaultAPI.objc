//
//  LVCProjectTests.m
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 12/2/13.
//  Copyright (c) 2013 LayerVault. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <LayerVaultAPI/LVCProject.h>
#import "LVCProject.h"

@interface LVCProjectTests : XCTestCase
@end

@implementation LVCProjectTests

- (void)testValidJSON
{
    NSURL *fileURL = [NSURL fileURLWithPath:@"LayerVaultAPIClientTests/Test Files/Valid Project.json"];
    NSData *data = [NSData dataWithContentsOfURL:fileURL];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                         options:0
                                                           error:nil];
    LVCProject *project = [MTLJSONAdapter modelOfClass:LVCProject.class fromJSONDictionary:dict error:nil];
    XCTAssertNotNil(project);
    XCTAssertEqualObjects(project.projectID, @"595206");
    XCTAssertEqualObjects(project.url, [NSURL URLWithString:@"https://layervault.com/codecaffeine/awesome~o"]);
    XCTAssertEqualObjects(project.name, @"awesome-o");
    XCTAssertEqualObjects(project.slug, @"awesome~o");
    XCTAssertEqualObjects(project.userIDs, @[@"11296"]);
    XCTAssertEqualObjects(project.organizationID, @"1307");
    XCTAssertEqual(project.folderIDs.count, (unsigned long)5);
    XCTAssertEqual(project.fileIDs.count, (unsigned long)32);
    XCTAssertEqual(project.presentationIDs.count, (unsigned long)0);
}

@end
