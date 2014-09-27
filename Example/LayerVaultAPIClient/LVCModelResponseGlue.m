//
//  LVCModelResponseGlue.m
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 9/21/14.
//  Copyright (c) 2014 LayerVault. All rights reserved.
//

#import "LVCModelResponseGlue.h"
#import "LVMRevision.h"
#import <LayerVaultAPI/LVCRevisionCollection.h>

@implementation LVCModelResponseGlue

+ (LVMRevision *)revisionFromRevisionResponse:(LVCRevisionValue *)revisionValue
                       inManagedObjectContext:(NSManagedObjectContext *)context
{
    LVMRevision *revision = [LVMRevision insertInManagedObjectContext:context];
    revision.uid = revisionValue.uid;
    revision.slug = revisionValue.slug;
    revision.revisionNumberValue = revisionValue.revisionNumber;
    revision.shortURL = [revisionValue.shortURL absoluteString];
    revision.dateCreated = revisionValue.dateCreated;
    revision.dateDeleted = revisionValue.dateDeleted;
    revision.dateUpdated = revisionValue.dateUpdated;
    revision.parentMD5 = revisionValue.parentMD5;
    revision.md5 = revisionValue.md5;
    revision.assembledFileDataFingerprint = revisionValue.assembledFileDataFingerprint;
    revision.fileDataFingerprint = revisionValue.fileDataFingerprint;
    revision.remoteURL = [revisionValue.remoteURL absoluteString];
    revision.downloadURL = [revisionValue.downloadURL absoluteString];
    revision.dropboxSyncRevisionValue = revisionValue.dropboxSyncRevision;
    return revision;
}

@end
