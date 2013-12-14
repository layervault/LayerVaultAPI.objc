//
//  LVCProject.h
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 10/25/13.
//  Copyright (c) 2013 LayerVault. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "LVCFolder.h"

@interface LVCProject : LVCFolder <MTLJSONSerializing>

@property (readonly, nonatomic) BOOL member;

@property (readonly, nonatomic) BOOL partial;
@property (readonly, nonatomic) BOOL synced;

- (instancetype)initWithName:(NSString *)name
       organizationPermalink:(NSString *)organizationPermalink;

@end
