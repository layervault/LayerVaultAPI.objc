//
//  NSValueTransformer+LVCPredefinedTransformerAdditions.h
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 12/17/13.
//  Copyright (c) 2013 LayerVault. All rights reserved.
//

#import <Foundation/Foundation.h>

OBJC_EXPORT NSString *const LVCRFC3339DateTransformerName;

/**
 *  Adds a new transformer to be used in valueTransformerForName:
 *  valueTransformerForName: which can be used to transform an RFC3339 string
 *  into an NSDate object
 */
@interface NSValueTransformer (LVCPredefinedTransformerAdditions)

@end
