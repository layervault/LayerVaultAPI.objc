//
//  LVCFile.h
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 11/18/13.
//  Copyright (c) 2013 LayerVault. All rights reserved.
//

#import "LVCNode.h"
@class LVCFolder;

typedef enum : NSUInteger {
    LVCFileSyncStatusError = 0,
    LVCFileSyncStatusUploadOK = 200,
    LVCFileSyncStatusUpToDate = 409,
    LVCFileSyncStatusFileSizeMissing = 400,
    LVCFileSyncStatusFileTooLarge = 413,
    LVCFileSyncStatusUploadFullFile = 412,
} LVCFileSyncStatus;

extern NSString *md5ForFileURL(NSURL *fileURL);

@interface LVCFile : LVCNode <MTLJSONSerializing>

@property (readonly, nonatomic) NSNumber *revisionNumber;
@property (readonly, nonatomic, copy) NSArray *revisions;
@property (readonly, nonatomic) NSDate *dateModified;
@property (readonly, nonatomic) NSURL *downloadURL;

- (void)updateMD5FromLocalFile;

@end
