//
//  NSError+LVCNetworkErrors.m
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 10/15/14.
//  Copyright (c) 2014 LayerVault. All rights reserved.
//

#import "NSError+LVCNetworkErrors.h"
#import <AFNetworking/AFNetworking.h>

@implementation NSError (LVCNetworkErrors)

- (NSHTTPURLResponse *)lvc_httpURLRespose
{
    NSHTTPURLResponse *response = nil;

    if ([self.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] isKindOfClass:[NSHTTPURLResponse class]]) {
        response = self.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
    }

    return response;
}

- (BOOL)lvc_failedWithHTTPStatusCode:(NSInteger)httpStatusCode
{
    return self.lvc_httpURLRespose.statusCode == httpStatusCode;
}

@end
