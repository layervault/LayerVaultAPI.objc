//
//  LVTAppDelegate.m
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 10/13/13.
//  Copyright (c) 2013 codecaffeine. All rights reserved.
//

#import "LVTAppDelegate.h"
#import "LVTHTTPClient.h"
#import "LVTUser.h"

@interface LVTAppDelegate ()
@property (nonatomic) LVTHTTPClient *client;
@end

@implementation LVTAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.client = [LVTHTTPClient new];

    [self.client getMyInfo:^(LVTUser *user, NSError *error, AFHTTPRequestOperation *operation) {
        NSLog(@"user: %@", user);
        NSLog(@"error: %@", error);
        NSLog(@"operation: %@", operation);
    }];
}

@end
