//
//  NSURLRequest+OAuth2.m
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 2/24/14.
//  Copyright (c) 2014 LayerVault. All rights reserved.
//

#import "NSURLRequest+OAuth2.h"

NSString *const LVCBearerTokenPrefix = @"Bearer ";

@implementation NSURLRequest (OAuth2)

- (NSString *)lvc_bearerToken
{
    NSString *authorizationHeader = self.allHTTPHeaderFields[@"Authorization"];
    if ([authorizationHeader hasPrefix:LVCBearerTokenPrefix]) {
        return [authorizationHeader stringByReplacingOccurrencesOfString:LVCBearerTokenPrefix
                                                withString:@""];
    }
    return nil;
}

@end
