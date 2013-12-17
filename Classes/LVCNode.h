//
//  LVCNode.h
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 12/9/13.
//  Copyright (c) 2013 LayerVault. All rights reserved.
//

#import <Mantle/Mantle.h>
@class LVCFolder;

@interface LVCNode : MTLModel <MTLJSONSerializing>

@property (readonly, nonatomic, copy) NSString *name;
@property (readonly, nonatomic, copy) NSURL *fileURL;
@property (readonly, nonatomic, copy) NSString *md5;
@property (nonatomic) NSDate *dateUpdated;
@property (readonly, nonatomic) NSDate *dateDeleted;
@property (readonly, nonatomic, copy) NSURL *url;
@property (readonly, nonatomic, copy) NSURL *shortURL;

@property (readonly, nonatomic, copy) NSString *urlPath;
@property (weak, nonatomic) LVCFolder *parentFolder;

@end
