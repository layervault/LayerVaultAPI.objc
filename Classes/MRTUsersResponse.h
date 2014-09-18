//
//  MRTUsersResponse.h
//  Pods
//
//  Created by Matt Thomas on 9/18/14.
//
//

#import <Mantle/Mantle.h>

@interface MRTUsersResponse : MTLModel <MTLJSONSerializing>
@property (readonly, nonatomic, copy) NSArray *userResponses;
@end


@interface MRTUserResponse : MTLModel <MTLJSONSerializing>
/// The unique ID of the user
@property (readonly, nonatomic, copy) NSString *userID;

/// Primary email address for user
@property (readonly, nonatomic, copy) NSString *email;

@property (readonly, nonatomic, copy) NSString *firstName;

@property (readonly, nonatomic, copy) NSString *lastName;

/// List of organization IDs user belongs to
@property (readonly, nonatomic, copy) NSArray *organizationIDs;

/// YES if the user has seen the online tour
@property (readonly, nonatomic) BOOL hasSeenTour;

/// YES if user has configured accout
@property (readonly, nonatomic) BOOL hasConfiguredAccount;

#warning - Not in v2
//@property (readonly, nonatomic, getter = isAdmin) BOOL admin;
@end
