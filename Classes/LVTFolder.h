//
//  LVTFolder.h
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 12/4/13.
//  Copyright (c) 2013 codecaffeine. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "LVTColor.h"

OBJC_EXPORT NSString *const LVTFolderOrganizationPermalinkJSONKey;

@interface LVTFolder : MTLModel <MTLJSONSerializing>

@property (nonatomic) LVTColorLabel colorLabel;
@property (readonly, nonatomic, copy) NSString *path;
@property (readonly, nonatomic, copy) NSURL *fileURL;
@property (readonly, nonatomic) NSDate *dateUpdated;
@property (readonly, nonatomic) NSDate *dateDeleted;
@property (readonly, nonatomic, copy) NSString *md5;
@property (readonly, nonatomic, copy) NSURL *url;
@property (readonly, nonatomic, copy) NSURL *shortURL;
@property (readonly, nonatomic, copy) NSString *organizationPermalink;
@property (readonly, nonatomic, copy) NSArray *folders;
@property (readonly, nonatomic, copy) NSArray *files;

@end
