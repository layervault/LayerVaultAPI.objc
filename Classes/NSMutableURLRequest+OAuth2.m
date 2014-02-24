//
//  NSMutableURLRequest+OAuth2.m
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 2/24/14.
//  Copyright (c) 2014 LayerVault. All rights reserved.
//

#import "NSMutableURLRequest+OAuth2.h"
#import "NSURLRequest+OAuth2.h"

@implementation NSMutableURLRequest (OAuth2)

- (void)lvc_setBearerToken:(NSString *)token
{
    if (token.length > 0) {
        NSString *bearer = [LVCBearerTokenPrefix stringByAppendingString:token];
        [self setValue:bearer forHTTPHeaderField:@"Authorization"];
    }
}

@end
