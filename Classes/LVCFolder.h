//
//  LVCFolder.h
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 12/4/13.
//  Copyright (c) 2013 LayerVault. All rights reserved.
//

#import "LVCNode.h"
#import "LVCColorUtils.h"

/**
 *  Representation of a folder on LayerVaule
 */
@interface LVCFolder : LVCNode <MTLJSONSerializing>

/**
 *  Color label corresponds to NSURLLabelNumberKey
 */
@property (nonatomic) LVCColorLabel colorLabel;

/**
 *  The local path of the file
 */
@property (nonatomic, copy) NSString *path;

/**
 *  @note this should be nil
 */
@property (nonatomic, copy) NSString *organizationPermalink;

/**
 *  Subfolders of this folder
 */
@property (nonatomic, copy) NSArray *folders;

/**
 *  Files directly in this folder, but not ones in subfolder
 */
@property (nonatomic, copy) NSArray *files;

@end
