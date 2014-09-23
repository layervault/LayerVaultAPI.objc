//
//  LVCFolderCollection.h
//  Pods
//
//  Created by Matt Thomas on 9/18/14.
//
//

#import <Mantle/Mantle.h>
#import "LVCModelCollection.h"

@interface LVCFolderCollection : MTLModel <LVCModelCollection, MTLJSONSerializing>
@property (nonatomic, readonly, copy) NSArray *folders;
@end

@interface LVCFolderValue : MTLModel <MTLJSONSerializing>
@property (readonly, nonatomic, copy) NSString *uid;
@property (readonly, nonatomic, copy) NSURL *href;
@property (readonly, nonatomic, copy) NSDate *dateCreated;
@property (readonly, nonatomic, copy) NSDate *dateUpdated;
@property (readonly, nonatomic, copy) NSString *slug;
@property (readonly, nonatomic, copy) NSString *name;
@property (readonly, nonatomic, copy) NSURL *url;

/// @note External Resource IDs
@property (readonly, nonatomic, copy) NSString *projectID;
@property (readonly, nonatomic, copy) NSString *parentFolderID;
@property (readonly, nonatomic, copy) NSArray *folderIDs;
@property (readonly, nonatomic, copy) NSArray *fileIDs;
@end

