//
//  MRTProjectsResponse.h
//  Pods
//
//  Created by Matt Thomas on 9/18/14.
//
//

#import <Mantle/Mantle.h>

@interface MRTProjectsResponse : MTLModel <MTLJSONSerializing>
@property (readonly, nonatomic, copy) NSArray *projectResponses;
@end

@interface MRTProjectResponse : MTLModel <MTLJSONSerializing>
@property (readonly, nonatomic, copy) NSString *projectID;
@property (readonly, nonatomic, copy) NSString *name;
@property (readonly, nonatomic, copy) NSString *slug;
@property (readonly, nonatomic, copy) NSURL *url;
@property (readonly, nonatomic, copy) NSString *organizationID;
@property (readonly, nonatomic, copy) NSArray *folderIDs;
@property (readonly, nonatomic, copy) NSArray *fileIDs;
@property (readonly, nonatomic, copy) NSArray *presentationIDs;
@property (readonly, nonatomic, copy) NSArray *userIDs;
#warning - need color label
//@property (nonatomic) LVCColorLabel colorLabel;
@end
