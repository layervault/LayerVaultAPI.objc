//
//  LVCOrganization.h
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 10/25/13.
//  Copyright (c) 2013 LayerVault. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface LVCOrganization : MTLModel <MTLJSONSerializing>
@property (readonly, nonatomic, copy) NSString *name;
@property (readonly, nonatomic, copy) NSString *permalink;
@property (readonly, nonatomic) NSDate *dateDeleted;
@property (readonly, nonatomic) NSDate *dateUpdated;
@property (readonly, nonatomic, copy) NSURL *url;
@property (readonly, nonatomic, copy) NSArray *projects;
@end
