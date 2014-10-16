//
//  NSError+LVCNetworkErrors.h
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 10/15/14.
//  Copyright (c) 2014 LayerVault. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (LVCNetworkErrors)

- (NSHTTPURLResponse *)lvc_httpURLRespose;

- (BOOL)lvc_failedWithHTTPStatusCode:(NSInteger)httpStatusCode;

@end
