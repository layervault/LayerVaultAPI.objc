//
//  PMKPromise+LVCRetryAdditions.h
//  Pods
//
//  Created by Matt Thomas on 10/10/14.
//
//

#import <PromiseKit/PromiseKit.h>

OBJC_EXPORT const NSInteger LVCDefaultAttemptCount;

@interface PMKPromise (LVCRetryAdditions)

+ (instancetype)lvc_attemptPromise:(id (^)(void))blockReturningPromises times:(NSInteger)times;

+ (instancetype)lvc_attemptPromise:(id (^)(void))blockReturningPromises;

@end
