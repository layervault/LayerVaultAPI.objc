//
//  LVCFolderTests.m
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 12/5/13.
//  Copyright (c) 2013 LayerVault. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <LayerVaultAPI/LVCFolder.h>

@interface LVCFolderTests : XCTestCase
@end

@implementation LVCFolderTests

- (void)testValidJSON
{
    NSURL *fileURL = [NSURL fileURLWithPath:@"LayerVaultAPIClientTests/Test Files/Valid Folder.json"];
    NSData *data = [NSData dataWithContentsOfURL:fileURL];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                         options:0
                                                           error:nil];
    LVCFolder *folder = [MTLJSONAdapter modelOfClass:LVCFolder.class fromJSONDictionary:dict error:nil];
    XCTAssertNotNil(folder);
    XCTAssertEqualObjects(folder.projectID, @"595206");
    XCTAssertEqualObjects(folder.url, [NSURL URLWithString:@"https://layervault.com/codecaffeine/awesome~o/an-awesome"]);
    XCTAssertEqualObjects(folder.name, @"an awesome");
    XCTAssertEqualObjects(folder.slug, @"an-awesome");
    XCTAssertEqualObjects(folder.projectID, @"595206");
    XCTAssertEqual(folder.folderIDs.count, (unsigned long)0);
    XCTAssertEqual(folder.fileIDs.count, (unsigned long)1);
}

@end
