//
//  PMKPromise+LVCRetryAdditions.m
//  Pods
//
//  Created by Matt Thomas on 10/10/14.
//
//

#import "PMKPromise+LVCRetryAdditions.h"
#import <PromiseKit/Promise+Until.h>

const NSInteger LVCDefaultAttemptCount = 3;

@implementation PMKPromise (LVCRetryAdditions)

+ (instancetype)lvc_attemptPromise:(id (^)(void))blockReturningPromises {
    return [self lvc_attemptPromise:blockReturningPromises times:LVCDefaultAttemptCount];
}

+ (instancetype)lvc_attemptPromise:(id (^)(void))blockReturningPromises times:(NSInteger)times
{
    if (times < 1) {
        return [self promiseWithValue:[NSError errorWithDomain:@"Cannot run promise < 1 time" code:1234 userInfo:nil]];
    } else {
        __block NSInteger attempts = times;
        return [self until:blockReturningPromises catch:^(NSError *error) {
            id val = (--attempts > 0) ? @YES : error;
            return [self promiseWithValue:val];
        }];
    }
}

@end
