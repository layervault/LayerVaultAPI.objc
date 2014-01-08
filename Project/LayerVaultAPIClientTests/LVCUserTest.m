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


- (void)testNoAdminMakesAdminFalse
{
    LVCUser *user = [MTLJSONAdapter modelOfClass:LVCUser.class
                              fromJSONDictionary:@{@"email": @"foo@bar.com"}
                                           error:nil];
    XCTAssertNotNil(user, @"user shouldn't be nil");
    XCTAssertFalse(user.admin, @"Should not be admin");
}


- (void)testNoEmailReturnsNilUser
{
    LVCUser *user = [MTLJSONAdapter modelOfClass:LVCUser.class
                              fromJSONDictionary:@{}
                                           error:nil];
    XCTAssertNil(user, @"user should be nil");
}

- (void)testNoIDGivesUserIDOfZero
{
    LVCUser *user = [MTLJSONAdapter modelOfClass:LVCUser.class
                              fromJSONDictionary:@{@"email": @"foo@bar.com"}
                                           error:nil];
    XCTAssertNotNil(user, @"user shouldn't be nil");
    XCTAssertEqual((NSUInteger)user.userID, (NSUInteger)0, @"User ID should be zero");
}


- (void)testIDCorrect
{
    NSUInteger num = 123456789;
    LVCUser *user = [MTLJSONAdapter modelOfClass:LVCUser.class
                              fromJSONDictionary:@{@"email": @"foo@bar.com",
                                                   @"id": @(num)}
                                           error:nil];
    XCTAssertNotNil(user, @"user shouldn't be nil");
    XCTAssertEqual((NSUInteger)user.userID, (NSUInteger)num, @"User ID should match");
}


@end
