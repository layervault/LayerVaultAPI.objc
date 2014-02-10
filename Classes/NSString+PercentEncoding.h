//
//  NSString+PercentEncoding.h
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 2/10/14.
//  Copyright (c) 2013 LayerVault. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (PercentEncoding)

/**
 *  This will return the string with all reserved characters percent encoded. 
 *  Useful for filenames that contain characters which would otherwise not
 *  be percent encoded like "Say What?.png"
 *
 *  @return the string with all reserved characters percent encoded
 */
- (NSString *)lv_stringWithFullPercentEncoding;

@end
