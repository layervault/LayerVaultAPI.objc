//
//  LVCProjectTests.m
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 12/2/13.
//  Copyright (c) 2013 LayerVault. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <LayerVaultAPI/LVCProject.h>
#import "LVCMockResponses.h"

@interface LVCProjectTests : XCTestCase
@property (nonatomic, copy) NSDictionary *validJSON;
@end

@implementation LVCProjectTests

- (void)setUp
{
    [super setUp];
    self.validJSON = LVCValidProjectJSON();
}


- (void)testNilJSONNilProject
{
    LVCProject *project = [MTLJSONAdapter modelOfClass:LVCProject.class
                                    fromJSONDictionary:nil
                                                 error:nil];
    XCTAssertNil(project, @"user should be nil");
}

- (void)testNilNameNilProject
{
    NSMutableDictionary *dictLessName = self.validJSON.mutableCopy;
    [dictLessName removeObjectForKey:@"name"];

    LVCProject *project = [MTLJSONAdapter modelOfClass:LVCProject.class
                                    fromJSONDictionary:dictLessName
                                                 error:nil];
    XCTAssertNil(project, @"user should be nil");
}

- (void)testProjectIsFolderSubclass
{
    LVCProject *project = [MTLJSONAdapter modelOfClass:LVCProject.class
                                    fromJSONDictionary:self.validJSON
                                                 error:nil];
    XCTAssertTrue([project isKindOfClass:LVCFolder.class], @"a project is a folder");
}


- (void)testValidJSON
{
    LVCProject *project = [MTLJSONAdapter modelOfClass:LVCProject.class
                                    fromJSONDictionary:self.validJSON
                                                 error:nil];
    XCTAssertNotNil(project, @"Project should not be nil");
}


- (void)testInitWithNameReturnsNOSynced
{
    LVCProject *project = [[LVCProject alloc] initWithName:@"foo"
                                     organizationPermalink:@"bar"];
    XCTAssertNotNil(project, @"project should not be nil");
    XCTAssertFalse(project.synced, @"Project should not be synced");
}


- (void)testInitFromDictReturnsYESSynced
{
    LVCProject *project = [MTLJSONAdapter modelOfClass:LVCProject.class
                                    fromJSONDictionary:self.validJSON
                                                 error:nil];
    XCTAssertTrue(project.synced, @"Project should be synced");
}


- (void)testNoPathIsPartialPathIsNotPartial
{
    NSMutableDictionary *dictLesspath = self.validJSON.mutableCopy;
    [dictLesspath removeObjectForKey:@"path"];

    LVCProject *project = [MTLJSONAdapter modelOfClass:LVCProject.class
                                    fromJSONDictionary:dictLesspath
                                                 error:nil];
    XCTAssertTrue(project.partial, @"project should be partial");

    LVCProject *project2 = [MTLJSONAdapter modelOfClass:LVCProject.class
                                    fromJSONDictionary:self.validJSON
                                                 error:nil];
    XCTAssertNotNil(project2, @"project should not be nil");
    XCTAssertFalse(project2.partial, @"project should not be partial");
}


- (void)testPermalinkPartOfURLPath
{
    LVCProject *project = [MTLJSONAdapter modelOfClass:LVCProject.class
                                    fromJSONDictionary:self.validJSON
                                                 error:nil];
    XCTAssertEqualObjects(project.urlPath,
                          LVCMockFullProjURLPath(),
                          @"unexpected urlPath");
}


@end
