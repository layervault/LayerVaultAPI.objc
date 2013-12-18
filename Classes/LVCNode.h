//
//  LVCNode.h
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 12/9/13.
//  Copyright (c) 2013 LayerVault. All rights reserved.
//

#import <Mantle/Mantle.h>
@class LVCFolder;

/**
 *  Interface shared by LVCProject, LVCFolder, and LVCFile
 */
@interface LVCNode : MTLModel <MTLJSONSerializing>

/**
 *  The nodes name. Cannot be nil
 */
@property (readonly, nonatomic, copy) NSString *name;

/**
 *  The URL of the node on the file system
 */
@property (readonly, nonatomic, copy) NSURL *fileURL;

/**
 *  The MD5 of the file (nil for non files)
 */
@property (readonly, nonatomic, copy) NSString *md5;

/**
 *  Date this node was updated
 */
@property (nonatomic) NSDate *dateUpdated;

/**
 *  Date this node was deleted.
 *  @note will always be nil
 */
@property (readonly, nonatomic) NSDate *dateDeleted;

/**
 *  URL on layervault.com for this node
 */
@property (readonly, nonatomic, copy) NSURL *url;

/**
 *  Same as URL, but through shortener service
 */
@property (readonly, nonatomic, copy) NSURL *shortURL;

/**
 *  Path on the server
 *  @note this is not percent encoded
 */
@property (readonly, nonatomic, copy) NSString *urlPath;

/**
 *  The parent folder for this node. Will be nil for the root node (LVCProjects)
 */
@property (weak, nonatomic) LVCFolder *parentFolder;

@end
