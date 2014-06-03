//
//  LVCFileRevision.h
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 11/18/13.
//  Copyright (c) 2013 LayerVault. All rights reserved.
//

#import <Mantle/Mantle.h>
@class LVCFile;

/**
 *  A specific revision of a file that has been uploaded to LayerVault
 */
@interface LVCFileRevision : MTLModel <MTLJSONSerializing>

/**
 *  Revision number
 */
@property (readonly, nonatomic) NSNumber *revision;

/**
 *  Revision MD5
 */
@property (readonly, nonatomic, copy) NSString *md5;

/**
 *  Download Size
 */
@property (readonly, nonatomic) NSNumber *size;

/**
 *  Date revision was created.
 */
@property (readonly, nonatomic) NSDate *dateCreated;

/**
 *  Date revision was updated
 */
@property (readonly, nonatomic) NSDate *dateUpdated;

/**
 *  URL to view the revision in a browser.
 */
@property (readonly, nonatomic) NSURL *webURL;

/**
 *  URL to download the revision.
 */
@property (readonly, nonatomic) NSURL *downloadURL;

/**
 *  Short URL to view the revision in a browser.
 */
@property (readonly, nonatomic) NSURL *shortenedURL;

/**
 *  Parent file reference
 */
@property (weak, nonatomic) LVCFile *file;

/**
 *  URL path to reference the file on the server.
 */
@property (readonly, nonatomic) NSString *urlPath;

/**
 *  Percent encoded URL path to reference the file on the server.
 */
@property (readonly, nonatomic) NSString *percentEncodedURLPath;

@end
