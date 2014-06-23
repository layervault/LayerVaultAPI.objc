//
//  NSDateFormatter+RFC3339Tests.m
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 12/18/13.
//  Copyright (c) 2013 LayerVault. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <LayerVaultAPI/NSDateFormatter+RFC3339.h>
#import "LVCAsyncHelper.h"

@interface NSDateFormatter_RFC3339Tests : XCTestCase
@property (nonatomic) NSString *rfc3339Epoch;
@end

@implementation NSDateFormatter_RFC3339Tests

- (void)setUp
{
    [super setUp];
    self.rfc3339Epoch = @"1970-01-01T00:00:00Z";
}

- (void)testNotNil
{
    NSDateFormatter *dateFormatter = [NSDateFormatter lvc_rfc3339DateFormatter];
    XCTAssertNotNil(dateFormatter, @"should not be nil");
}

- (void)testFormatsRFC3339DateString
{
    NSDateFormatter *dateFormatter = [NSDateFormatter lvc_rfc3339DateFormatter];
    NSDate *date = [dateFormatter dateFromString:self.rfc3339Epoch];
    XCTAssertNotNil(date, @"date should not be nil");
    XCTAssertEqualObjects(date,
                          [NSDate dateWithTimeIntervalSince1970:0],
                          @"dates should be equal");
}

- (void)testFormatsFromDate
{
    NSDateFormatter *dateFormatter = [NSDateFormatter lvc_rfc3339DateFormatter];
    NSString *rfc3339Epoch = [dateFormatter stringFromDate:
                              [NSDate dateWithTimeIntervalSince1970:0]];
    XCTAssertNotNil(rfc3339Epoch, @"string should not be nil");
    XCTAssertEqualObjects(rfc3339Epoch,
                          self.rfc3339Epoch,
                          @"string should be equal");
}

- (void)testSameQueueSameFormatter
{
    NSDateFormatter *dateFormatter1 = [NSDateFormatter lvc_rfc3339DateFormatter];
    NSDateFormatter *dateFormatter2 = [NSDateFormatter lvc_rfc3339DateFormatter];
    XCTAssertEqualObjects(dateFormatter1, dateFormatter2);
}

- (void)testDifferentQueueDifferentFormatter
{
    NSDateFormatter *dateFormatter1 = [NSDateFormatter lvc_rfc3339DateFormatter];
    __block NSDateFormatter *dateFormatter2 = nil;

    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:[NSBlockOperation blockOperationWithBlock:^{
        dateFormatter2 = [NSDateFormatter lvc_rfc3339DateFormatter];
    }]];

    [LVCAsyncHelper wait:0.1];

    XCTAssertNotEqualObjects(dateFormatter1, dateFormatter2);
}


@end
