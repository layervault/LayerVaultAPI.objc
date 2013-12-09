//
//  LVTFolder.h
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 12/4/13.
//  Copyright (c) 2013 codecaffeine. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "LVTNode.h"
#import "LVTColor.h"


@interface LVTFolder : LVTNode <MTLJSONSerializing>

@property (nonatomic) LVTColorLabel colorLabel;
@property (readonly, nonatomic, copy) NSString *path;
@property (readonly, nonatomic, copy) NSString *organizationPermalink;
@property (readonly, nonatomic, copy) NSArray *folders;
@property (readonly, nonatomic, copy) NSArray *files;

@end
