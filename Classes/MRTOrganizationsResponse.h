//
//  MRTOrganizationsResponse.h
//  Pods
//
//  Created by Matt Thomas on 9/18/14.
//
//

#import <Mantle/Mantle.h>
#import "LVCOrganization.h" /// for LCVSyncType

typedef enum : NSUInteger {
    LVCSyncTypeLayerVault,
    LVCSyncTypeDropBox
} LVCSyncType;

@interface MRTOrganizationsResponse : MTLModel <MTLJSONSerializing>
@property (readonly, nonatomic, copy) NSArray *organizationResponses;
@end

@interface MRTOrganizationResponse : MTLModel <MTLJSONSerializing>
@property (readonly, nonatomic, copy) NSString *organizationID;
@property (readonly, nonatomic, copy) NSString *name;
@property (readonly, nonatomic, copy) NSString *slug;
@property (readonly, nonatomic) BOOL isFree;
@property (readonly, nonatomic) NSDate *dateDeleted; /// @note exclude dateDeleted?
@property (readonly, nonatomic) NSDate *dateUpdated;
@property (readonly, nonatomic) NSDate *dateCreated;
@property (readonly, nonatomic) NSDate *dateCancelled; /// @note exclude dateCancelled
@property (readonly, nonatomic, copy) NSURL *url;
@property (readonly, nonatomic) LVCSyncType syncType;/// @note exclude LVCSyncTypeDropbox
@property (readonly, nonatomic, copy) NSArray *projectIDs;
@property (readonly, nonatomic, copy) NSArray *administratorIDs;
@property (readonly, nonatomic, copy) NSArray *editorIDs;
@property (readonly, nonatomic, copy) NSArray *spectatorIDs;
@end
