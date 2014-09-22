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
@property (readonly, nonatomic, copy) NSString *uid;
@property (readonly, nonatomic, copy) NSURL *href;
@property (readonly, nonatomic, copy) NSDate *dateCreated;
@property (readonly, nonatomic, copy) NSDate *dateUpdated;
@property (readonly, nonatomic, copy) NSString *name;
@property (readonly, nonatomic, copy) NSString *slug;
@property (readonly, nonatomic, copy) NSURL *url;
@property (readonly, nonatomic) BOOL isFree;
@property (readonly, nonatomic, copy) NSDate *dateDeleted; /// @note exclude dateDeleted?
@property (readonly, nonatomic, copy) NSDate *dateCancelled; /// @note exclude dateCancelled
@property (readonly, nonatomic) LVCSyncType syncType;/// @note exclude LVCSyncTypeDropbox
@property (readonly, nonatomic) BOOL isTrialingWithoutPayment;
@property (readonly, nonatomic, copy) NSDate *dateTrialEnds;


/// from the JSON
@property (readonly, nonatomic, copy) NSArray *projectIDs;
@property (readonly, nonatomic, copy) NSArray *administratorIDs;
@property (readonly, nonatomic, copy) NSArray *editorIDs;
@property (readonly, nonatomic, copy) NSArray *spectatorIDs;

@property (nonatomic, copy) NSArray *projects;
@end
