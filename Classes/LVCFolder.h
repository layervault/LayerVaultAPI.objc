//
//  LVCFolder.h
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 12/4/13.
//  Copyright (c) 2013 LayerVault. All rights reserved.
//

#import "LVCNode.h"
#import "LVCColorUtils.h"

@interface LVCFolder : LVCNode <MTLJSONSerializing>

@property (nonatomic) LVCColorLabel colorLabel;
@property (readonly, nonatomic, copy) NSString *path;
@property (readonly, nonatomic, copy) NSString *organizationPermalink;
@property (readonly, nonatomic, copy) NSArray *folders;
@property (readonly, nonatomic, copy) NSArray *files;

@end
