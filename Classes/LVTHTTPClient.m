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
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Mantle/EXTScope.h>
#import "LVTUser.h"
#import "LVTOrganization.h"


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
    return [self initWithBaseURL:[NSURL URLWithString:@"https://api.layervault.com/api/v1/"]
                        clientID:clientID
                          secret:secret];
}


- (void)getMeWithBlock:(void (^)(LVTUser *user, NSError *error, AFHTTPRequestOperation *operation))block
{
    [self getPath:@"me"
       parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSError *error = nil;
              LVTUser *user = [MTLJSONAdapter modelOfClass:LVTUser.class
                                        fromJSONDictionary:responseObject
                                                     error:&error];
              if (block) {
                  block(user, error, operation);
              }
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              if (block) {
                  block(nil, error, operation);
              }
          }];
}


- (void)getOrganizationWithName:(NSString *)orgName
                          block:(void (^)(LVTOrganization *organization, NSError *error, AFHTTPRequestOperation *operation))block
{
    [self getPath:orgName
       parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSError *error = nil;
              LVTOrganization *org = [MTLJSONAdapter modelOfClass:LVTOrganization.class
                                        fromJSONDictionary:responseObject
                                                     error:&error];
              if (block) {
                  block(org, error, operation);
              }
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              if (block) {
                  block(nil, error, operation);
              }
          }];
}


- (void)authenticateWithEmail:(NSString *)email
                     password:(NSString *)password
                   completion:(void (^)(AFOAuthCredential *credential, NSError *error))completion
{
    [self authenticateUsingOAuthWithPath:@"/oauth/token"
                                username:email
                                password:password
                                   scope:nil
                                 success:^(AFOAuthCredential *credential) {
                                     if (completion) {
                                         completion(credential, nil);
                                     }
                                 }
                                 failure:^(NSError *error) {
                                     if (completion) {
                                         completion(nil, error);
                                     }
                                 }];
}


- (RACSignal *)requestAuthorizationWithEmail:(NSString *)email password:(NSString *)password
{
    @weakify(self);
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self)
        [self authenticateWithEmail:email
                           password:password
                         completion:^(AFOAuthCredential *credential, NSError *error) {
                             if (credential) {
                                 [subscriber sendNext:credential];
                             }
                             else {
                                 [subscriber sendError:error];
                             }
                         }];
    }] replayLazily];
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
