//
//  NSMutableURLRequest+OAuth2.h
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 2/24/14.
//  Copyright (c) 2014 LayerVault. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableURLRequest (OAuth2)

- (void)lvc_setBearerToken:(NSString *)token;

@end
