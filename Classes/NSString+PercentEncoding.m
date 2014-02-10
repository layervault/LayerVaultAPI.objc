//
//  NSString+PercentEncoding.m
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 2/10/14.
//  Copyright (c) 2013 LayerVault. All rights reserved.
//

#import "NSString+PercentEncoding.h"

@implementation NSString (PercentEncoding)

- (NSString *)lv_stringWithFullPercentEncoding
{
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                 (CFStringRef)self,
                                                                                 NULL,
                                                                                 CFSTR("!#$&'()*+,/:;=?@[]"),
                                                                                 kCFStringEncodingUTF8));
}

@end
