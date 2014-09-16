//
//  LVCProject.h
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 10/25/13.
//  Copyright (c) 2013 LayerVault. All rights reserved.
//

#import <Mantle/Mantle.h>

/**
 *  LVCProject is a root level folder. All files and folder must be contained
 *  in a project.
 */
@interface LVCProject : MTLModel <MTLJSONSerializing>

@property (readonly, nonatomic, copy) NSString *projectID;

@property (readonly, nonatomic, copy) NSString *name;

@property (readonly, nonatomic, copy) NSString *slug;

@property (readonly, nonatomic, copy) NSURL *url;

@property (readonly, nonatomic, copy) NSString *organizationID;

@property (readonly, nonatomic, copy) NSArray *folderIDs;

@property (readonly, nonatomic, copy) NSArray *fileIDs;

@property (readonly, nonatomic, copy) NSArray *presentationIDs;

@property (readonly, nonatomic, copy) NSArray *userIDs;

/// FIXME: member is based on if the userID is included in the userIDs array
//@property (readonly, nonatomic) BOOL member;

@end
