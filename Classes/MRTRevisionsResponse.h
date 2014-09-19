//
//  MRTRevisionsResponse.h
//  Pods
//
//  Created by Matt Thomas on 9/18/14.
//
//

#import <Mantle/Mantle.h>

@interface MRTRevisionsResponse : MTLModel <MTLJSONSerializing>
@property (nonatomic, readonly, copy) NSArray *requestResponses;
@end

@interface MRTRevisionResponse : MTLModel <MTLJSONSerializing>
@property (nonatomic, readonly, copy) NSString *revisionID;
@property (nonatomic, readonly, copy) NSArray *previewIDs;
@property (nonatomic, readonly, copy) NSString *userID;
@property (nonatomic, readonly, copy) NSString *metadataID;
@property (nonatomic, readonly, copy) NSString *slug;
@property (nonatomic, readonly) NSInteger revisionNumber;
@property (nonatomic, readonly, copy) NSURL *shortURL;
@property (nonatomic, readonly, copy) NSDate *dateCreated;
@property (nonatomic, readonly, copy) NSDate *dateDeleted;
@property (nonatomic, readonly, copy) NSDate *dateUpdated;
@property (nonatomic, readonly, copy) NSString *parentMD5;
@property (nonatomic, readonly, copy) NSString *md5;
@property (nonatomic, readonly, copy) NSString *assembledFileDataFingerprint;
@property (nonatomic, readonly, copy) NSString *fileDataFingerprint;
@property (nonatomic, readonly, copy) NSURL *remoteURL; /// @note eh?
@property (nonatomic, readonly, copy) NSURL *downloadURL;
@property (nonatomic, readonly) BOOL dropboxSyncRevision; /// @note false
@end
