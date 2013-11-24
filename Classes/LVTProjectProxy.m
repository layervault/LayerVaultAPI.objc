//
//  MTLProjectProxy.m
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 11/23/13.
//  Copyright (c) 2013 codecaffeine. All rights reserved.
//

#import "LVTProjectProxy.h"
#import "LVTProject.h"

@interface LVTProjectProxy ()
@property (readonly, nonatomic) LVTProject *dummy;
@end

@implementation LVTProjectProxy

- (instancetype)initWithName:(NSString *)name
       organizationPermalink:(NSString *)organizationPermalink
{
    NSParameterAssert(name);
    NSParameterAssert(organizationPermalink);
    if (self) {
        _name = [name copy];
        _organizationPermalink = [organizationPermalink copy];
        _dummy = [LVTProject new];
    }
    return self;
}


- (void)forwardInvocation:(NSInvocation *)invocation;
{
    if (self.futureProject) {
        [invocation invokeWithTarget:self.futureProject];
    }
#ifdef DEBUG
    else {
        NSLog(@"%@ ignoring %@", NSStringFromClass(self.class), NSStringFromSelector(invocation.selector));
    }
#endif
}


- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    LVTProject *proj = self.futureProject ?: self.dummy;
    return [proj methodSignatureForSelector:aSelector];
}

@end
