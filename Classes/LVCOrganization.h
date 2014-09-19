//
//  LVCOrganization.h
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 10/25/13.
//  Copyright (c) 2013 LayerVault. All rights reserved.
//

#import <Mantle/Mantle.h>

/**
 *  LVCOrganization is a representation of an organization on LayerVault.
 */
@interface LVCOrganization : MTLModel <MTLJSONSerializing>

/**
 *  Organization name
 */
@property (readonly, nonatomic, copy) NSString *name;

/**
 *  The user’s role for this organization.
 */
@property (readonly, nonatomic, copy) NSString *userRole;

/**
 *  @note permalink should be used in all URL calls for the organization
 */
@property (readonly, nonatomic, copy) NSString *permalink;

/**
 *  @note should be nil
 */
@property (readonly, nonatomic) NSDate *dateDeleted;

/**
 *  Date a file in the organization was last updated
 */
@property (readonly, nonatomic) NSDate *dateUpdated;

/**
 *  Website URL of the organization
 */
@property (readonly, nonatomic, copy) NSURL *url;

/**
 *  Describes the sync type for this org.
 */
@property (readonly, nonatomic, copy) NSString *syncType;

/**
 *  Array of all LVCProjects in the organization
 */
@property (readonly, nonatomic, copy) NSArray *projects;

@end
