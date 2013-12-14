//
//  LVCFile.h
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 11/18/13.
//  Copyright (c) 2013 codecaffeine. All rights reserved.
//

#import "LVTNode.h"
@class LVTFolder;

typedef enum : NSUInteger {
    LVCFileSyncStatusError = 0,
    LVCFileSyncStatusUploadPatch = 200,
    LVCFileSyncStatusUpToDate = 409,
    LVCFileSyncStatusFileSizeMissing = 400,
    LVCFileSyncStatusFileTooLarge = 413,
    LVCFileSyncStatusUploadFullFile = 412,
} LVCFileSyncStatus;


@interface LVCFile : LVTNode <MTLJSONSerializing>

@property (readonly, nonatomic) NSNumber *revisionNumber;
@property (readonly, nonatomic, copy) NSArray *revisions;
@property (readonly, nonatomic) NSDate *dateModified;
@property (readonly, nonatomic) NSURL *downloadURL;

@end
