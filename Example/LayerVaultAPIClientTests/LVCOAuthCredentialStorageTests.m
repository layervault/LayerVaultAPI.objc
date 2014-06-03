//
//  LVCOAuthCredentialStorageTests.m
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 2/6/14.
//  Copyright (c) 2014 LayerVault. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <AFOAuth2Client/AFOAuth2Client.h>
#import <LayerVaultAPI/LVCOAuthCredentialStorage.h>

static NSString *randomHex(void)
{
    u_int32_t baseInt = arc4random() % 16777216;
    return [NSString stringWithFormat:@"%06X", baseInt];
}

@interface LVCOAuthCredentialStorageTests : XCTestCase

@end

@implementation LVCOAuthCredentialStorageTests

- (void)testRetrievingWithNilServiceNameThrows
{
    XCTAssertThrows([LVCOAuthCredentialStorage credentialWithServiceName:nil
                                                                 account:@"foo"
                                                                   error:nil]);
}

- (void)testRetrievingWithNilAccountThrows
{
    XCTAssertThrows([LVCOAuthCredentialStorage credentialWithServiceName:@"foo"
                                                                 account:nil
                                                                   error:nil]);
}


- (void)testRetrievingNonexistantCredentialReturnsNilWithError
{
    NSError *retrieveError = nil;
    AFOAuthCredential *cred = [LVCOAuthCredentialStorage credentialWithServiceName:@"foo"
                                                                           account:@"bar"
                                                                             error:&retrieveError];
    XCTAssertNil(cred);
    XCTAssertNotNil(retrieveError);
}


- (void)testStoringNilCredentialThrows
{
    XCTAssertThrows([LVCOAuthCredentialStorage storeCredential:nil
                                              withServiceName:@"FOO"
                                                      account:@"BAR"
                                                        error:nil]);
}


- (void)testStoringNilServiceNameThrows
{
    AFOAuthCredential *cred = [AFOAuthCredential credentialWithOAuthToken:@"ASDF"
                                                                tokenType:@"Bearer"];
    XCTAssertThrows([LVCOAuthCredentialStorage storeCredential:cred
                                               withServiceName:nil
                                                       account:@"BAR"
                                                         error:nil]);
}


- (void)testStoringNilAccountFailsWithError
{
    AFOAuthCredential *cred = [AFOAuthCredential credentialWithOAuthToken:@"ASDF"
                                                                tokenType:@"Bearer"];
    XCTAssertThrows([LVCOAuthCredentialStorage storeCredential:cred
                                               withServiceName:@"FOO"
                                                       account:nil
                                                         error:nil]);
}


- (void)testDeletingWithNilServiceNameThrows
{
    XCTAssertThrows([LVCOAuthCredentialStorage deleteCredentialWithServiceName:nil
                                                                       account:@"foo"
                                                                         error:nil]);
}

- (void)testDeletingWithNilAccountThrows
{
    XCTAssertThrows([LVCOAuthCredentialStorage deleteCredentialWithServiceName:@"foo"
                                                                       account:nil
                                                                         error:nil]);
}


- (void)testDeletingNonexistantCredentialFailsWithError
{
    NSError *deleteError = nil;
    BOOL success = [LVCOAuthCredentialStorage deleteCredentialWithServiceName:@"foo"
                                                                      account:@"bar"
                                                                        error:&deleteError];
    XCTAssertFalse(success);
    XCTAssertNotNil(deleteError);
}


- (void)testSavingRetrivingDeletingCredentialWithCustomServiceName
{
    NSString *serviceName = [NSString stringWithFormat:@"LVCOAuthCredentialStorageTests:%@", randomHex()];
    NSString *account = randomHex();
    NSLog(@">>> serviceName: %@\taccount: %@", serviceName, account);

    NSString *oAuthToken = randomHex();
    NSString *tokenType = @"Bearer";
    NSString *refreshToken = randomHex();

    AFOAuthCredential *cred = [AFOAuthCredential credentialWithOAuthToken:oAuthToken
                                                                tokenType:tokenType];
    [cred setRefreshToken:refreshToken
               expiration:[NSDate date]];

    NSError *saveError = nil;
    BOOL saveSuccess = [LVCOAuthCredentialStorage storeCredential:cred
                                                  withServiceName:serviceName
                                                          account:account
                                                            error:nil];
    XCTAssertTrue(saveSuccess);
    XCTAssertNil(saveError);

    NSError *retrieveError = nil;
    AFOAuthCredential *rCred = [LVCOAuthCredentialStorage credentialWithServiceName:serviceName
                                                                            account:account
                                                                              error:&retrieveError];
    XCTAssertNotNil(rCred);
    XCTAssertNil(retrieveError);
    XCTAssertEqualObjects(cred.accessToken, rCred.accessToken);
    XCTAssertEqualObjects(cred.tokenType, rCred.tokenType);
    XCTAssertEqualObjects(cred.refreshToken, rCred.refreshToken);
    XCTAssertEqual(cred.isExpired, rCred.isExpired);

    NSError *deleteError = nil;
    BOOL deleteSuccess = [LVCOAuthCredentialStorage deleteCredentialWithServiceName:serviceName
                                                                            account:account
                                                                              error:&deleteError];
    XCTAssertTrue(deleteSuccess);
    XCTAssertNil(deleteError);
}


@end
