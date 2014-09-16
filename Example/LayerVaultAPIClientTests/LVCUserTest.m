//
//  LVCUserTest.m
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 10/14/13.
//  Copyright (c) 2013 LayerVault. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Mantle/Mantle.h>
#import "LVCUser.h"

@interface LVCUserTest : XCTestCase

@end

@implementation LVCUserTest

- (void)testNilJSONNilUser
{
    LVCUser *user = [MTLJSONAdapter modelOfClass:LVCUser.class
                              fromJSONDictionary:nil
                                           error:nil];
    XCTAssertNil(user, @"user should be nil");
}


- (void)testNoEmailReturnsNilUser
{
    LVCUser *user = [MTLJSONAdapter modelOfClass:LVCUser.class
                              fromJSONDictionary:@{}
                                           error:nil];
    XCTAssertNil(user, @"user should be nil");
}

- (void)testValidJSON
{
    NSURL *fileURL = [NSURL fileURLWithPath:@"LayerVaultAPIClientTests/Test Files/Valid User.json"];
    NSData *data = [NSData dataWithContentsOfURL:fileURL];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                         options:0
                                                           error:nil];
    LVCUser *user = [MTLJSONAdapter modelOfClass:LVCUser.class
                              fromJSONDictionary:dict
                                           error:nil];
    XCTAssertNotNil(user);
    XCTAssertEqualObjects(user.firstName, @"Matt");
    XCTAssertEqualObjects(user.lastName, @"Thomas");
    XCTAssertEqualObjects(user.userID, @"11296");
    XCTAssertEqualObjects(user.email, @"matt+test@layervault.com");
    XCTAssertEqual(user.organizationIDs.count, (unsigned long)5);
}


@end
