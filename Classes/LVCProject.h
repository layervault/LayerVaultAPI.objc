//
//  LVCProject.h
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 10/25/13.
//  Copyright (c) 2013 LayerVault. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "LVCFolder.h"
#import "LVCModelCollection.h"

/**
 *  LVCProject is a root level folder. All files and folder must be contained
 *  in a project.
 */
@interface LVCProject : LVCFolder <LVCResourceUniquing, MTLJSONSerializing>

@property (nonatomic, copy) NSString *uid;

/**
 *  YES if user has joined the project, NO if they have not
 */
@property (nonatomic) BOOL member;

/**
 *  @note Some calls do not return the files and folders of a project, just the
 *        project information. In these situation, partial will be YES, 
 *        otherwise NO.
 */
@property (nonatomic) BOOL partial;

/**
 *  @note Projects created with initWithName:organizatonPermalink: that have 
 *        not been uploaded to the server will return NO for this property
 */
@property (nonatomic) BOOL synced;

/**
 *  Create a new project object without uploading it to the server.
 *
 *  @param name                  Name of organization. Cannot be nil
 *  @param organizationPermalink Permalink for the organization of new project
 *
 *  @return A new LVCProject with synced property set to NO
 */
- (instancetype)initWithName:(NSString *)name
       organizationPermalink:(NSString *)organizationPermalink;

@end
