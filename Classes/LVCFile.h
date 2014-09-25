//
//  LVCFile.h
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 11/18/13.
//  Copyright (c) 2013 LayerVault. All rights reserved.
//

#import "LVCNode.h"
#import "LVCModelCollection.h"
@class LVCFolder;
@class LVCFileRevision;

/**
 *  FileSync Status Responses
 */
typedef enum : NSUInteger {
    LVCFileSyncStatusError = 0,
    LVCFileSyncStatusUploadOK = 200,
    LVCFileSyncStatusFileSizeMissing = 400,
    LVCFileSyncStatusNewerFileOnServer = 409,
    LVCFileSyncStatusUploadFullFile = 412,
    LVCFileSyncStatusFileTooLarge = 413,
    LVCFileSyncStatusUnsupportedType = 415
} LVCFileSyncStatus;

/**
 *  Returns the MD5 for a file or nil if no file found
 *
 *  @param fileURL data processed by MD5 hashing algorithm
 *
 *  @return MD5 for a file, or nil if no file found
 */
extern NSString *md5ForFileURL(NSURL *fileURL);


/**
 *  LVCFile is a representation of a file on LayerVault.
 */
@interface LVCFile : LVCNode <LVCResourceUniquing, MTLJSONSerializing>

@property (nonatomic, copy) NSString *uid;

/**
 *  Last revision number
 */
@property (nonatomic) NSNumber *revisionNumber;

/**
 *  All the revisions for the file
 */
@property (nonatomic, copy) NSArray *revisions;

/**
 *  URL to download the latest file revision directly
 */
@property (nonatomic) NSURL *downloadURL;

/**
 *  Gets a revision with a specific number, or nil.
 *
 *  @param number Revision Number
 *
 *  @return LVCFileRevision if found, or nil
 */
- (LVCFileRevision *)revisionWithNumber:(NSNumber *)number;

@end
