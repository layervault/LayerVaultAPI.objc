//
//  LVCUser.h
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 10/13/13.
//  Copyright (c) 2013 LayerVault. All rights reserved.
//

#import <Mantle/Mantle.h>

/**
 *  User is a representation of an user on LayerVault.
 */
@interface LVCUser : MTLModel <MTLJSONSerializing>

/**
 *  The numeric ID of the user
 */
@property (readonly, nonatomic, copy) NSString *userID;

/**
 *  The email address of the user
 */
@property (readonly, nonatomic, copy) NSString *email;

/**
 *  The first name of the user
 */
@property (readonly, nonatomic, copy) NSString *firstName;

/**
 *  The last name of the user
 */
@property (readonly, nonatomic, copy) NSString *lastName;

/**
 *  All organizations the user belongs to
 */
@property (readonly, nonatomic, copy) NSArray *organizationIDs;

#warning - Not in v2
//@property (readonly, nonatomic, getter = isAdmin) BOOL admin;
@end
