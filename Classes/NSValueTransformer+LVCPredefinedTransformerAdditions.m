//
//  NSValueTransformer+LVCPredefinedTransformerAdditions.m
//  Pods
//
//  Created by Matt Thomas on 12/17/13.
//
//

#import "NSValueTransformer+LVCPredefinedTransformerAdditions.h"
#import <Mantle/MTLValueTransformer.h>
#import "NSValueTransformer+LVCPredefinedTransformerAdditions.h"
#import "NSDateFormatter+RFC3339.h"

NSString *const LVCRFC3339DateTransformerName = @"LVCRFC3339DateTransformerName";

@implementation NSValueTransformer (LVCPredefinedTransformerAdditions)

+ (void)load
{
    @autoreleasepool {
		MTLValueTransformer *rfc3339DateTransformer =
        [MTLValueTransformer
         reversibleTransformerWithForwardBlock:^NSDate *(NSString *string) {
             return [[NSDateFormatter lvc_rfc3339DateFormatter] dateFromString:string];
         } reverseBlock:^NSString *(NSDate *date) {
             return [[NSDateFormatter lvc_rfc3339DateFormatter] stringFromDate:date];
         }];

		[NSValueTransformer setValueTransformer:rfc3339DateTransformer
                                        forName:LVCRFC3339DateTransformerName];
	}
}


@end
