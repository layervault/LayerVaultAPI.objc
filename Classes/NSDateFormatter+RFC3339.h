//
//  NSDateFormatter+RFC3339.h
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 12/17/13.
//  Copyright (c) 2013 LayerVault. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDateFormatter (RFC3339)

/**
 *  @return NSDateFormatter conforming to RFC 3339 using UTC time
 *          http://www.ietf.org/rfc/rfc3339.txt
 */
+ (NSDateFormatter *)lvc_rfc3339DateFormatter;

@end
