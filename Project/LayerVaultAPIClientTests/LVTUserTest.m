//
//  LVTUserTest.m
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 10/14/13.
//  Copyright (c) 2013 codecaffeine. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Mantle/Mantle.h>
#import "LVCUser.h"

@interface LVTUserTest : XCTestCase

@end

@implementation LVTUserTest

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

@end
