//
//  LVTUser.h
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 10/13/13.
//  Copyright (c) 2013 codecaffeine. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface LVTUser : MTLModel <MTLJSONSerializing>
@property (readonly, nonatomic, copy) NSString *email;
@property (readonly, nonatomic, copy) NSString *firstName;
@property (readonly, nonatomic, copy) NSString *lastName;
@property (readonly, nonatomic, getter = isAdmin) BOOL admin;
@end
