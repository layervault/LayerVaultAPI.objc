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

@property (readonly, nonatomic, copy) NSString *email;

@property (readonly, nonatomic, copy) NSString *firstName;

@property (readonly, nonatomic, copy) NSString *lastName;

@property (readonly, nonatomic, copy) NSArray *organizationIDs;

@property (readonly, nonatomic) BOOL hasSeenTour;

@property (readonly, nonatomic) BOOL hasConfiguredAccount;

@property (readonly, nonatomic, copy) NSString *uid;

@property (readonly, nonatomic, copy) NSURL *href;

@property (readonly, nonatomic, copy) NSDate *dateCreated;

@property (readonly, nonatomic, copy) NSDate *dateUpdated;

#warning - Not in v2
//@property (readonly, nonatomic, getter = isAdmin) BOOL admin;

@end
