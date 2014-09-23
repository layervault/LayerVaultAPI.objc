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
 *  The nodes name.
 *
 *  @note required
 */
@property (nonatomic, copy) NSString *name;

/**
 *  The URL of the node on the file system
 */
@property (nonatomic, copy) NSURL *fileURL;

/**
 *  The MD5 of the file (nil for non files)
 */
@property (nonatomic, copy) NSString *md5;

/**
 *  Date this node was updated
 */
@property (nonatomic) NSDate *dateUpdated;

/**
 *  Date this node was deleted.
 *  @note will always be nil
 */
@property (nonatomic) NSDate *dateDeleted;

/**
 *  URL on layervault.com for this node
 */
@property (nonatomic, copy) NSURL *url;

/**
 *  Same as URL, but through shortener service
 */
@property (nonatomic, copy) NSURL *shortURL;

/**
 *  Path on the server
 *  @note this is not percent encoded
 */
@property (nonatomic, copy) NSString *urlPath;


/**
 *  Path on the server
 *  @note this IS percent encoded
 */
@property (nonatomic, copy) NSString *percentEncodedURLPath;

/**
 *  The parent folder for this node. Will be nil for the root node (LVCProjects)
 */
@property (weak, nonatomic) LVCFolder *parentFolder;

@end
