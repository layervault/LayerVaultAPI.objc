//
//  LVCFile.h
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 11/18/13.
//  Copyright (c) 2013 LayerVault. All rights reserved.
//

#import <Mantle/Mantle.h>

/**
 *  LVCFile is a representation of a file on LayerVault.
 */
@interface LVCFile : MTLModel <MTLJSONSerializing>

@property (readonly, nonatomic, copy) NSString *fileID;

@property (readonly, nonatomic, copy) NSString *name;

@property (readonly, nonatomic, copy) NSString *slug;

@property (readonly, nonatomic) BOOL canEditNode;

@property (readonly, nonatomic) BOOL canCommentOnFile;

@property (readonly, nonatomic, copy) NSString *folderID;

@property (readonly, nonatomic, copy) NSArray *revisionClusterIDs;

@property (readonly, nonatomic, copy) NSArray *feedbackThreadIDs;

@property (readonly, nonatomic, copy) NSDate *dateCreated;

@property (readonly, nonatomic, copy) NSDate *dateModified;

@property (readonly, nonatomic, copy) NSDate *dateDeleted;

#warning - Revisions?
//@property (readonly, nonatomic, copy) NSArray *revisionIDs;

#warning - Download URL?
//@property (readonly, nonatomic) NSURL *downloadURL;

@end
