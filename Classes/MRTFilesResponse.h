//
//  MRTFilesResponse.h
//  Pods
//
//  Created by Matt Thomas on 9/18/14.
//
//

#import <Mantle/Mantle.h>
@class MRTRevisionResponse;

@interface MRTFilesResponse : MTLModel <MTLJSONSerializing>
@property (nonatomic, readonly, copy) NSArray *fileResponses;
@end

@interface MRTFileResponse : MTLModel <MTLJSONSerializing>
@property (readonly, nonatomic, copy) NSString *uid;
@property (readonly, nonatomic, copy) NSURL *href;
@property (readonly, nonatomic, copy) NSDate *dateCreated;
@property (readonly, nonatomic, copy) NSDate *dateUpdated;
@property (readonly, nonatomic, copy) NSString *slug;
@property (readonly, nonatomic, copy) NSString *name;
@property (readonly, nonatomic, copy) NSURL *url;
@property (readonly, nonatomic) BOOL canEditNode;
@property (readonly, nonatomic) BOOL canCommentOnFile;
@property (readonly, nonatomic, copy) NSDate *dateDeleted;
@property (readonly, nonatomic) NSInteger revisionCount;

/// @note External Resource IDs
@property (readonly, nonatomic, copy) NSString *lastRevisionID;
@property (readonly, nonatomic, copy) NSString *lastPreviewID;
@property (readonly, nonatomic, copy) NSString *projectID;
@property (readonly, nonatomic, copy) NSString *folderID;
@property (readonly, nonatomic, copy) NSArray *revisionClusterIDs;
@property (readonly, nonatomic, copy) NSArray *feedbackThreadIDs;
@end
