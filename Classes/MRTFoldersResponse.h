//
//  MRTFoldersResponse.h
//  Pods
//
//  Created by Matt Thomas on 9/18/14.
//
//

#import <Mantle/Mantle.h>

@interface MRTFoldersResponse : MTLModel <MTLJSONSerializing>
@property (nonatomic, readonly, copy) NSArray *folderResponses;
@end

@interface MRTFolderResponse : MTLModel <MTLJSONSerializing>
@property (readonly, nonatomic, copy) NSString *uid;
@property (readonly, nonatomic, copy) NSString *name;
@property (readonly, nonatomic, copy) NSString *slug;
@property (readonly, nonatomic, copy) NSURL *url;
@property (readonly, nonatomic, copy) NSString *projectID;
@property (readonly, nonatomic, copy) NSString *parentFolderID;
@property (readonly, nonatomic, copy) NSArray *folderIDs;
@property (readonly, nonatomic, copy) NSArray *fileIDs;

@end

