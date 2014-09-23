//
//  MRTProjectsResponse.h
//  Pods
//
//  Created by Matt Thomas on 9/18/14.
//
//

#import <Mantle/Mantle.h>
#import "LVCModelCollection.h"
#import "LVCColorUtils.h"

@interface LVCProjectCollection : MTLModel <LVCModelCollection, MTLJSONSerializing>
@property (readonly, nonatomic, copy) NSArray *projects;
@end

@interface MRTProjectResponse : MTLModel <MTLJSONSerializing>
@property (readonly, nonatomic, copy) NSString *uid;
@property (readonly, nonatomic, copy) NSURL *href;
@property (readonly, nonatomic, copy) NSDate *dateCreated;
@property (readonly, nonatomic, copy) NSDate *dateUpdated;
@property (readonly, nonatomic, copy) NSString *slug;
@property (readonly, nonatomic, copy) NSString *name;
@property (readonly, nonatomic, copy) NSURL *url;
@property (readonly, nonatomic) BOOL isPublic;
@property (readonly, nonatomic) LVCColorLabel colorLabel;

/// @note External Resource IDs
@property (readonly, nonatomic, copy) NSString *organizationID;
@property (readonly, nonatomic, copy) NSArray *folderIDs;
@property (readonly, nonatomic, copy) NSArray *fileIDs;
@property (readonly, nonatomic, copy) NSArray *presentationIDs;
@property (readonly, nonatomic, copy) NSArray *userIDs;
@end
