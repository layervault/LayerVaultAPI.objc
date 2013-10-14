//
//  LVTHTTPClient.m
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 10/13/13.
//  Copyright (c) 2013 codecaffeine. All rights reserved.
//

#import "LVTHTTPClient.h"
#import <Mantle/Mantle.h>
#import "LVTUser.h"

@implementation LVTHTTPClient

- (instancetype)initWithBaseURL:(NSURL *)url token:(NSString *)token
{
    self = [super initWithBaseURL:url];
    if (self) {
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [self setDefaultHeader:@"Accept" value:@"application/json"];
        if ([token length] > 0) {
            [self setDefaultHeader:@"Authorization"
                             value:[NSString stringWithFormat:@"Bearer %@", token]];
        }
    }
    return self;
}


- (instancetype)initWithToken:(NSString *)token
{
    return [self initWithBaseURL:[NSURL URLWithString:@"https://layervault.com/api/v1/"]
                           token:token];
}


- (instancetype)initWithBaseURL:(NSURL *)url
{
    return [self initWithBaseURL:url token:nil];
}


- (void)getMyInfo:(void (^)(LVTUser *user, NSError *error, AFHTTPRequestOperation *operation))myInfoBlock;
{
    [self getPath:@"me"
       parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              if (myInfoBlock) {
                  NSError *error = nil;
                  LVTUser *user = [MTLJSONAdapter modelOfClass:LVTUser.class
                                            fromJSONDictionary:responseObject
                                                         error:&error];
                  myInfoBlock(user, error, operation);
              }
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              if (myInfoBlock) {
                  myInfoBlock(nil, error, operation);
              }
          }];
}

@end
