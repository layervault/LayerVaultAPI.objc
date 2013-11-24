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


- (instancetype)initWithPartialProject:(LVTProject *)project
{
    NSParameterAssert(project);
    return [self initWithName:project.name organizationPermalink:project.organizationPermalink];
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


+ (NSValueTransformer *)valueTransformerForProxyProjects
{
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^NSArray *(NSArray *array) {
        NSValueTransformer *transformer = [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:LVTProject.class];

        // NOTE: organizations don't return fully-realized projects, only enough
        // information to load the project later.
        NSArray *partialProjects = [transformer transformedValue:array];
        NSMutableArray *proxyProjects = @[].mutableCopy;
        for (LVTProject *partialProject in partialProjects) {
            LVTProjectProxy *proxyProject = [[LVTProjectProxy alloc] initWithPartialProject:partialProject];
            [proxyProjects addObject:proxyProject];
        }
        return proxyProjects;
    } reverseBlock:^NSArray *(NSArray *array) {
        NSMutableArray *fullProjects = @[].mutableCopy;
        for (LVTProjectProxy *proxy in array) {
            NSAssert([proxy isKindOfClass:LVTProjectProxy.class],
                     @"Proxy should be LVTProjectProxy but is %@", NSStringFromClass(proxy.class));
            if (proxy.futureProject) {
                [fullProjects addObject:[MTLJSONAdapter JSONDictionaryFromModel:proxy.futureProject]];
            }
        }
        return fullProjects;
    }];
}

@end
