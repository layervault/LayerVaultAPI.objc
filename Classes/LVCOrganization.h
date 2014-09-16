//
//  LVCOrganization.h
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 10/25/13.
//  Copyright (c) 2013 LayerVault. All rights reserved.
//

#import <Mantle/Mantle.h>

typedef enum : NSUInteger {
    LVCSyncTypeLayerVault,
    LVCSyncTypeDropBox
} LVCSyncType;

typedef enum : NSUInteger {
    LVCUserRoleSpectator,
    LVCUserRoleEditor,
    LVCUserRoleAdministrator
} LVCUserRole;

/**
 *  LVCOrganization is a representation of an organization on LayerVault.
 */
@interface LVCOrganization : MTLModel <MTLJSONSerializing>

@property (readonly, nonatomic, copy) NSString *organizationID;

@property (readonly, nonatomic, copy) NSString *name;

@property (readonly, nonatomic, copy) NSString *slug;

@property (readonly, nonatomic) BOOL isFree;

/// @note should be nil
@property (readonly, nonatomic) NSDate *dateDeleted;

@property (readonly, nonatomic) NSDate *dateUpdated;

@property (readonly, nonatomic) NSDate *dateCreated;

@property (readonly, nonatomic) NSDate *dateCancelled;

@property (readonly, nonatomic, copy) NSURL *url;

@property (readonly, nonatomic) LVCSyncType syncType;

@property (readonly, nonatomic, copy) NSArray *projectIDs;

/// TODO: translate these into userRole
//@property (readonly, nonatomic) LVCUserRole userRole;

@property (readonly, nonatomic, copy) NSArray *administratorIDs;
@property (readonly, nonatomic, copy) NSArray *editorIDs;
@property (readonly, nonatomic, copy) NSArray *spectatorIDs;

@end
