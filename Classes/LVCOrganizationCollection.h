//
//  LVCOrganizationCollection.h
//  Pods
//
//  Created by Matt Thomas on 9/18/14.
//
//

#import <Mantle/Mantle.h>
#import "LVCModelCollection.h"
#import "LVCOrganization.h" /// for LCVSyncType

typedef enum : NSUInteger {
    LVCSyncTypeLayerVault,
    LVCSyncTypeDropBox
} LVCSyncType;

@interface LVCOrganizationCollection : MTLModel <LVCModelCollection, MTLJSONSerializing>
@property (readonly, nonatomic, copy) NSArray *organizations;
@property (nonatomic, copy) NSDate *currentServerTime;
@end

@interface LVCOrganizationValue : MTLModel <LVCResourceUniquing, MTLJSONSerializing>
@property (readonly, nonatomic, copy) NSString *uid;
@property (readonly, nonatomic, copy) NSURL *href;
@property (readonly, nonatomic, copy) NSDate *dateCreated;
@property (readonly, nonatomic, copy) NSDate *dateUpdated;
@property (readonly, nonatomic, copy) NSString *slug;
@property (readonly, nonatomic, copy) NSString *name;
@property (readonly, nonatomic, copy) NSURL *url;
@property (readonly, nonatomic) BOOL isFree;
@property (readonly, nonatomic, copy) NSDate *dateDeleted; /// @note Organization Deleted but account still valid. Organization data destroyed.
@property (readonly, nonatomic, copy) NSDate *dateCancelled; /// @note Account cancelled but organization data still persists. If they re-activate their account again, they can get their data back.
@property (readonly, nonatomic) LVCSyncType syncType; /// @note this response _should_ exclude LVCSyncTypeDropbox
@property (readonly, nonatomic) BOOL isTrialingWithoutPayment;
@property (readonly, nonatomic, copy) NSDate *dateTrialEnds;

/// @note External Resource IDs
@property (readonly, nonatomic, copy) NSArray *projectIDs;
@property (readonly, nonatomic, copy) NSArray *administratorIDs;
@property (readonly, nonatomic, copy) NSArray *editorIDs;
@property (readonly, nonatomic, copy) NSArray *spectatorIDs;
@end
