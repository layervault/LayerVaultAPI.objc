//
//  NSURLRequest+OAuth2.h
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 2/24/14.
//  Copyright (c) 2014 LayerVault. All rights reserved.
//

#import <Foundation/Foundation.h>

OBJC_EXPORT NSString *const LVCBearerTokenPrefix;

@interface NSURLRequest (OAuth2)

- (NSString *)lvc_bearerToken;

@end
