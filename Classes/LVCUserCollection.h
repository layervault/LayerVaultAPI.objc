//
//  LVCUserCollection.h
//  Pods
//
//  Created by Matt Thomas on 9/18/14.
//
//

#import <Mantle/Mantle.h>
#import "LVCModelCollection.h"

@interface LVCUserCollection : MTLModel <LVCModelCollection, MTLJSONSerializing>
@property (readonly, nonatomic, copy) NSArray *users;
@end

@interface LVCUserValue : MTLModel <LVCResourceUniquing, MTLJSONSerializing>

@property (readonly, nonatomic, copy) NSString *uid;
@property (readonly, nonatomic, copy) NSURL *href;
@property (readonly, nonatomic, copy) NSDate *dateCreated;
@property (readonly, nonatomic, copy) NSDate *dateUpdated;
@property (readonly, nonatomic, copy) NSString *email;
@property (readonly, nonatomic, copy) NSString *firstName;
@property (readonly, nonatomic, copy) NSString *lastName;
@property (readonly, nonatomic) BOOL hasSeenTour;
@property (readonly, nonatomic) BOOL hasConfiguredAccount;

/// @note External Resource IDs
@property (readonly, nonatomic, copy) NSArray *organizationIDs;

#warning - Not in v2
//@property (readonly, nonatomic, getter = isAdmin) BOOL admin;
@end
