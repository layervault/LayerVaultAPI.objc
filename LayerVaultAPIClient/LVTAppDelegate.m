//
//  LVTAppDelegate.m
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 10/13/13.
//  Copyright (c) 2013 codecaffeine. All rights reserved.
//

#import "LVTAppDelegate.h"
#import "LVTHTTPClient.h"

@interface LVTAppDelegate ()
@property (nonatomic) LVTHTTPClient *client;
@end

@implementation LVTAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.client = [LVTHTTPClient new];

    [self.client
     getMyInfoWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSLog(@"operation: %@", operation);
         NSLog(@"responseObject: %@", responseObject);
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"operation: %@", operation);
         NSLog(@"error: %@", error);
     }];
}

@end
