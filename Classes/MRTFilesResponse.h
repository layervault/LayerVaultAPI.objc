//
//  MRTFilesResponse.h
//  Pods
//
//  Created by Matt Thomas on 9/18/14.
//
//

#import <Mantle/Mantle.h>

@interface MRTFilesResponse : MTLModel <MTLJSONSerializing>
@property (nonatomic, readonly, copy) NSArray *fileResponses;
@end

@interface MRTFileResponse : MTLModel <MTLJSONSerializing>
@property (readonly, nonatomic, copy) NSString *fileID;
@property (readonly, nonatomic, copy) NSString *name;
@property (readonly, nonatomic, copy) NSString *slug;
@property (readonly, nonatomic, copy) NSString *lastRevisionID;
@property (readonly, nonatomic) BOOL canEditNode;
@property (readonly, nonatomic) BOOL canCommentOnFile;
@property (readonly, nonatomic, copy) NSString *folderID;
@property (readonly, nonatomic, copy) NSArray *revisionClusterIDs;
@property (readonly, nonatomic, copy) NSArray *feedbackThreadIDs;
@property (readonly, nonatomic, copy) NSDate *dateCreated;
@property (readonly, nonatomic, copy) NSDate *dateModified;
@property (readonly, nonatomic, copy) NSDate *dateDeleted;
@end
