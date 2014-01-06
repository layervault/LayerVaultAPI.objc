//
//  LVCAuthenticatedClientTests.m
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 1/6/14.
//  Copyright (c) 2014 LayerVault. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <LayerVaultAPI/LayerVaultAPI.h>
#import "LVCAsyncHelper.h"
#import "LVCMockURLConnection.h"
#import "LVCMockResponses.h"

@interface LVCAuthenticatedClientTests : XCTestCase
@property (nonatomic) LVCAuthenticatedClient *client;
@property (nonatomic) AFOAuthCredential *goodCredential;
@property (nonatomic) AFOAuthCredential *expiredCredential;
@end

@implementation LVCAuthenticatedClientTests

- (void)setUp
{
    [super setUp];
    [NSURLProtocol registerClass:[LVCMockURLConnection class]];
    self.client = [[LVCAuthenticatedClient alloc] initWithBaseURL:LVCHTTPClient.defaultBaseURL
                                                         clientID:@"CLIENT_ID"
                                                           secret:@"SECRET"
                                                   saveToKeychain:NO];
    self.goodCredential = [[AFOAuthCredential alloc] initWithOAuthToken:@"FEEDFACE"
                                                              tokenType:@"bearer"];
    self.expiredCredential = [[AFOAuthCredential alloc] initWithOAuthToken:@"8BADF00D"
                                                                 tokenType:@"bearer"];
    [self.expiredCredential setRefreshToken:@"ABAD1DEA"
                                 expiration:[NSDate distantPast]];
}

- (void)tearDown
{
    [NSURLProtocol unregisterClass:[LVCMockURLConnection class]];
    [super tearDown];
}


- (void)testNoCredentialNotAuthenticated
{
    XCTAssertTrue(self.client.authenticationState == LVCAuthenticationStateUnauthenticated, @"should not be authenticated");
}


- (void)testClientWithGoodCredentialReturning400NoUser
{
    [LVCMockURLConnection setResponseWithStatusCode:400
                                       headerFields:nil
                                           bodyData:nil];
    XCTAssertFalse(self.goodCredential.expired, @"should not be expired");

    __block BOOL callbackCalled = NO;
    __block LVCUser *userReturned = nil;
    __block NSError *errorReturned = nil;
    self.client.authenticationCallback = ^(LVCUser *user, NSError *error) {
        callbackCalled = YES;
        userReturned = user;
        errorReturned = error;
    };
    XCTAssertNotNil(self.goodCredential, @"Gah");
    [self.client loginWithCredential:self.goodCredential];
    [LVCAsyncHelper wait:0.1];
    XCTAssertTrue(callbackCalled, @"callback should have been called");
    XCTAssertNil(userReturned, @"user should be nil");
    XCTAssertNotNil(errorReturned, @"error should return");
}


@end
