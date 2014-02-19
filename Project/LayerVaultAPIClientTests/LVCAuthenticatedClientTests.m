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
                                                           secret:@"SECRET"];
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
    XCTAssertTrue(self.client.authenticationState == LVCAuthenticationStateUnauthenticated);
}


- (void)testCredential401LogsUserOut
{
    [LVCMockURLConnection setResponseForPath:@"/api/v1/me"
                              withStatusCode:401
                                headerFields:nil
                                    bodyData:nil];
    [LVCMockURLConnection setResponseForPath:@"/oauth/token"
                              withStatusCode:401
                                headerFields:nil
                                    bodyData:nil];
    [self.client loginWithCredential:self.goodCredential];
    XCTAssertNotNil(self.client.credential);

    __block BOOL completionCalled = NO;
    __block LVCUser *userReturned = nil;
    __block NSError *errorReturned = nil;
    [self.client getMeWithCompletion:^(LVCUser *user,
                                       NSError *error,
                                       AFHTTPRequestOperation *operation) {
        completionCalled = YES;
        userReturned = user;
        errorReturned = error;
    }];
    [LVCAsyncHelper wait:0.1];
    XCTAssertTrue(completionCalled);
    XCTAssertNil(userReturned);
    XCTAssertNotNil(errorReturned);
    XCTAssertNil(self.client.credential);
}


- (void)testCredential500DoesNotLogUserOut
{
    [LVCMockURLConnection setResponseForPath:@"/api/v1/me"
                              withStatusCode:401
                                headerFields:nil
                                    bodyData:nil];
    [LVCMockURLConnection setResponseForPath:@"/oauth/token"
                              withStatusCode:500
                                headerFields:nil
                                    bodyData:nil];
    [self.client loginWithCredential:self.goodCredential];
    XCTAssertNotNil(self.client.credential);

    __block BOOL completionCalled = NO;
    __block LVCUser *userReturned = nil;
    __block NSError *errorReturned = nil;
    [self.client getMeWithCompletion:^(LVCUser *user,
                                       NSError *error,
                                       AFHTTPRequestOperation *operation) {
        completionCalled = YES;
        userReturned = user;
        errorReturned = error;
    }];
    [LVCAsyncHelper wait:0.1];
    XCTAssertTrue(completionCalled);
    XCTAssertNil(userReturned);
    XCTAssertNotNil(errorReturned);
    XCTAssertNotNil(self.client.credential);
}

@end
