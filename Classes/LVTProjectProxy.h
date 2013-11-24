//
//  MTLProjectProxy.h
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 11/23/13.
//  Copyright (c) 2013 codecaffeine. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LVTProject;

@interface LVTProjectProxy : NSProxy

@property (readonly, copy) NSString *name;
@property (readonly, copy) NSString *organizationPermalink;
@property (nonatomic) LVTProject *futureProject;

- (instancetype)initWithName:(NSString *)name
       organizationPermalink:(NSString *)organizationPermalink;

@end
