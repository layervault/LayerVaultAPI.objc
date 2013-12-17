//
//  LVCFileRevision.h
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 11/18/13.
//  Copyright (c) 2013 LayerVault. All rights reserved.
//

#import <Mantle/Mantle.h>
@class LVCFile;

@interface LVCFileRevision : MTLModel <MTLJSONSerializing>

@property (readonly, nonatomic) NSNumber *revision;
@property (readonly, nonatomic, copy) NSString *md5;
@property (readonly, nonatomic) NSDate *dateCreated;
@property (readonly, nonatomic) NSDate *dateUpdated;
@property (readonly, nonatomic) NSURL *webURL;
@property (readonly, nonatomic) NSURL *downloadURL;
@property (readonly, nonatomic) NSURL *shortenedURL;

@property (weak, nonatomic) LVCFile *file;
@property (readonly, nonatomic) NSString *urlPath;

@end
