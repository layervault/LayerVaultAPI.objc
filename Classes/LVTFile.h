//
//  LVTFile.h
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 11/18/13.
//  Copyright (c) 2013 codecaffeine. All rights reserved.
//

#import "LVTNode.h"
@class LVTFolder;

typedef enum : NSUInteger {
    LVTFileSyncStatusError = 0,
    LVTFileSyncStatusUploadPatch = 200,
    LVTFileSyncStatusUpToDate = 409,
    LVTFileSyncStatusFileSizeMissing = 400,
    LVTFileSyncStatusFileTooLarge = 413,
    LVTFileSyncStatusUploadFullFile = 412,
} LVTFileSyncStatus;


@interface LVTFile : LVTNode <MTLJSONSerializing>

@property (readonly, nonatomic) NSNumber *revisionNumber;
@property (readonly, nonatomic, copy) NSArray *revisions;
@property (readonly, nonatomic) NSDate *dateModified;
@property (readonly, nonatomic) NSURL *downloadURL;

@end
