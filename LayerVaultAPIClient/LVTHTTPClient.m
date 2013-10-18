//
//  LVTHTTPClient.m
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 10/13/13.
//  Copyright (c) 2013 codecaffeine. All rights reserved.
//

#import "LVTHTTPClient.h"
#import <Mantle/Mantle.h>
#import <AFNetworking/AFJSONRequestOperation.h>
#import "LVTUser.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Mantle/EXTScope.h>


@interface LVTHTTPClient ()
@property (nonatomic, copy) LVTUser *user;
@end


@implementation LVTHTTPClient

- (instancetype)initWithBaseURL:(NSURL *)url clientID:(NSString *)clientID secret:(NSString *)secret
{
    self = [super initWithBaseURL:url clientID:clientID secret:secret];
    if (self) {
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [self setDefaultHeader:@"Accept" value:@"application/json"];
    }
    return self;
}


- (instancetype)initWithClientID:(NSString *)clientID secret:(NSString *)secret
{
    return [self initWithBaseURL:[NSURL URLWithString:@"https://layervault.com/api/v1/"]
                        clientID:clientID
                          secret:secret];
}

- (void)authenticateWithBlock:(void (^)(LVTUser *user, NSError *error, AFHTTPRequestOperation *operation))myInfoBlock;
{
    [self getPath:@"me"
       parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSError *error = nil;
              LVTUser *user = [MTLJSONAdapter modelOfClass:LVTUser.class
                                        fromJSONDictionary:responseObject
                                                     error:&error];
              self.user = user;
              if (myInfoBlock) {
                  myInfoBlock(user, error, operation);
              }
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              self.user = nil;
              if (myInfoBlock) {
                  myInfoBlock(nil, error, operation);
              }
          }];
}


- (RACSignal *)fetchUserInfo
{
    @weakify(self);
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);

        if (self.user) {
            [subscriber sendCompleted];
        }
        else {
            [self getPath:@"me"
               parameters:nil
                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                      NSError *error = nil;
                      LVTUser *user = [MTLJSONAdapter modelOfClass:LVTUser.class
                                                fromJSONDictionary:responseObject
                                                             error:&error];
                      self.user = user;
                      [subscriber sendNext:user];
                  }
                  failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      self.user = nil;
                      [subscriber sendError:error];
                  }];
        }

        return nil;
    }];

    return [signal replayLazily];
}


@end
