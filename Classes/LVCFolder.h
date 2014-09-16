//
//  LVCFolder.h
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 12/4/13.
//  Copyright (c) 2013 LayerVault. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface LVCFolder : MTLModel <MTLJSONSerializing>

@property (readonly, nonatomic, copy) NSString *folderID;

@property (readonly, nonatomic, copy) NSString *name;

@property (readonly, nonatomic, copy) NSString *slug;

@property (readonly, nonatomic, copy) NSURL *url;

@property (readonly, nonatomic, copy) NSString *projectID;

@property (readonly, nonatomic, copy) NSArray *folderIDs;

@property (readonly, nonatomic, copy) NSArray *fileIDs;

#warning - need color label
//@property (nonatomic) LVCColorLabel colorLabel;

@end
