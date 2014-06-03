//
//  NSValueTransformer+LVCPredefinedTransformerAdditionsTests.m
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 12/18/13.
//  Copyright (c) 2013 LayerVault. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <LayerVaultAPI/NSValueTransformer+LVCPredefinedTransformerAdditions.h>

@interface NSValueTransformer_LVCPredefinedTransformerAdditionsTests : XCTestCase
@property (nonatomic) NSString *rfc3339Epoch;
@end

@implementation NSValueTransformer_LVCPredefinedTransformerAdditionsTests

- (void)setUp
{
    [super setUp];
    self.rfc3339Epoch = @"1970-01-01T00:00:00Z";
}

- (void)testTransformerFromNameNotNil
{
    NSValueTransformer *transformer =
    [NSValueTransformer valueTransformerForName:LVCRFC3339DateTransformerName];
    XCTAssertNotNil(transformer, @"transformer should not be nil");
}


- (void)testTransformStringToDate
{
    NSValueTransformer *transformer =
    [NSValueTransformer valueTransformerForName:LVCRFC3339DateTransformerName];
    NSDate *date = [transformer transformedValue:self.rfc3339Epoch];
    XCTAssertNotNil(date, @"date should not be nil");
    XCTAssertEqualObjects(date,
                          [NSDate dateWithTimeIntervalSince1970:0],
                          @"dates should be equal");
}

- (void)testTransformDateToString
{
    NSValueTransformer *transformer =
    [NSValueTransformer valueTransformerForName:LVCRFC3339DateTransformerName];
    NSString *rfc3339Epoch = [transformer reverseTransformedValue:[NSDate dateWithTimeIntervalSince1970:0]];
    XCTAssertNotNil(rfc3339Epoch, @"date should not be nil");
    XCTAssertEqualObjects(rfc3339Epoch,
                          self.rfc3339Epoch,
                          @"dates should be equal");
}


@end
