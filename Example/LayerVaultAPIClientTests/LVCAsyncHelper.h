//
//  LVCAsyncHelper.h
//  LayerVault
//
//  Created by Matt Thomas on 7/25/13.
//  Copyright (c) 2013 LayerVault. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LVCAsyncHelper : NSObject

/**
 Runs the main run for a desired amount of time. Effectively pausing exection 
 which is helpful for testing async operations.
 
 @param wait - How long to pause execution.
 */
+ (void)wait:(NSTimeInterval)wait;

@end
