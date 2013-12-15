//
//  LVCOrganizationsViewController.h
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 12/15/13.
//  Copyright (c) 2013 LayerVault. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface LVCOrganizationsViewController : NSViewController <NSOutlineViewDataSource, NSOutlineViewDelegate>
@property (nonatomic, copy) NSArray *organizations;
@end
