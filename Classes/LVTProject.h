//
//  LVTProject.h
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 10/25/13.
//  Copyright (c) 2013 codecaffeine. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "LVTColor.h"

@interface LVTProject : MTLModel <MTLJSONSerializing>

@property (readonly, nonatomic, copy) NSString *name;
@property (readonly, nonatomic) LVTColorLabel colorLabel;
@property (readonly, nonatomic, copy) NSString *path;
@property (readonly, nonatomic, copy) NSURL *fileURL;
@property (readonly, nonatomic) NSDate *dateUpdated;
@property (readonly, nonatomic) NSDate *dateDeleted;
@property (readonly, nonatomic, copy) NSString *md5;
@property (readonly, nonatomic, copy) NSURL *url;
@property (readonly, nonatomic, copy) NSURL *shortURL;
@property (readonly, nonatomic, copy) NSString *organizationPermalink;
@property (readonly, nonatomic, copy) NSArray *files;

@property (readonly, nonatomic) BOOL partial;
@property (readonly, nonatomic) BOOL synced;

- (instancetype)initWithName:(NSString *)name
       organizationPermalink:(NSString *)organizationPermalink;

@end
