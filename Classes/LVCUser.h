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
@property (readonly, nonatomic) NSUInteger userID;

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
 *  Whether the user is an admin of the site or not.
 */
@property (readonly, nonatomic, getter = isAdmin) BOOL admin;

/**
 *  All organizations the user belongs to
 */
@property (readonly, nonatomic, copy) NSArray *organizations;

/**
 *  All projects the user has access to
 *  @note They may or may not be a member of these projects
 */
@property (readonly, nonatomic, copy) NSArray *projects;
@end
