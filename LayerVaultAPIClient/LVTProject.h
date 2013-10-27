//
//  LVTProject.h
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 10/25/13.
//  Copyright (c) 2013 codecaffeine. All rights reserved.
//

#import "MTLModel.h"

@interface LVTProject : MTLModel
@property (readonly, nonatomic, copy) NSURL *url;
@property (readonly, nonatomic, copy) NSURL *fileURL;
@property (readonly, nonatomic, copy) NSString *md5;
@property (readonly, nonatomic, copy) NSString *organizationPermalink;
@property (readonly, nonatomic, copy) NSString *path;
@property (readonly, nonatomic, copy) NSURL *shortURL;
@property (readonly, nonatomic, copy) NSNumber *treeFolderID;
@property (readonly, nonatomic) NSDate *dateUpdated;
@property (readonly, nonatomic, copy) NSString *color;
@property (readonly, nonatomic) NSDate *dateDeleted;
@end
