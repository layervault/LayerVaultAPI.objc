//
//  LVCRevisionCollection.h
//  Pods
//
//  Created by Matt Thomas on 9/18/14.
//
//

#import <Mantle/Mantle.h>
#import "LVCModelCollection.h"

@interface LVCRevisionCollection : MTLModel <LVCModelCollection, MTLJSONSerializing>
@property (nonatomic, readonly, copy) NSArray *revisions;
@end

@interface LVCRevisionValue : MTLModel <MTLJSONSerializing>
@property (readonly, nonatomic, copy) NSString *uid;
@property (readonly, nonatomic, copy) NSURL *href;
@property (readonly, nonatomic, copy) NSDate *dateCreated;
@property (readonly, nonatomic, copy) NSDate *dateUpdated;
@property (nonatomic, readonly, copy) NSString *slug;
@property (nonatomic, readonly) NSInteger revisionNumber;
@property (nonatomic, readonly, copy) NSURL *shortURL;
@property (nonatomic, readonly, copy) NSDate *dateDeleted;
@property (nonatomic, readonly, copy) NSString *parentMD5;
@property (nonatomic, readonly, copy) NSString *md5;
@property (nonatomic, readonly, copy) NSString *assembledFileDataFingerprint;
@property (nonatomic, readonly, copy) NSString *fileDataFingerprint;
@property (nonatomic, readonly, copy) NSURL *remoteURL; /// @note eh?
@property (nonatomic, readonly, copy) NSURL *downloadURL;
@property (nonatomic, readonly) BOOL dropboxSyncRevision; /// @note false

/// @note External Resource IDs
@property (nonatomic, readonly, copy) NSArray *previewIDs;
@property (nonatomic, readonly, copy) NSString *userID;
@property (nonatomic, readonly, copy) NSString *metadataID;
@end
