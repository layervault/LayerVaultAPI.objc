//
//  LVTFile.h
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 11/18/13.
//  Copyright (c) 2013 codecaffeine. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface LVTFile : MTLModel <MTLJSONSerializing>

@property (readonly, nonatomic, copy) NSString *localPath;
@property (readonly, nonatomic, copy) NSString *md5;
@property (readonly, nonatomic) NSNumber *revisionNumber;
@property (readonly, nonatomic, copy) NSArray *revisions;
@property (readonly, nonatomic) NSDate *dateDeleted;
@property (readonly, nonatomic) NSDate *dateModified;
@property (readonly, nonatomic) NSDate *dateUpdated;
@property (readonly, nonatomic) NSURL *downloadURL;
@property (readonly, nonatomic) NSURL *webURL;
@property (readonly, nonatomic) NSURL *shortenedURL;

@end
