//
//  NSDateFormatter+RFC3339.m
//  Pods
//
//  Created by Matt Thomas on 12/17/13.
//
//

#import "NSDateFormatter+RFC3339.h"

@implementation NSDateFormatter (RFC3339)

+ (NSDateFormatter *)lvc_rfc3339DateFormatter
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
    return dateFormatter;
}

@end
