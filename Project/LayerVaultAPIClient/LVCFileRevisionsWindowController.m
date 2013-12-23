//
//  LVCFileRevisionsWindowController.m
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 12/23/13.
//  Copyright (c) 2013 LayerVault. All rights reserved.
//

#import "LVCFileRevisionsWindowController.h"
#import <LayerVaultAPI/LayerVaultAPI.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <AFNetworking/AFNetworking.h>

@interface LVCFileRevisionsWindowController ()
@property (copy) NSArray *revisions;
@end

@implementation LVCFileRevisionsWindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        [RACObserve(self, file) subscribeNext:^(LVCFile *file) {
            self.revisions = @[];
            self.window.title = file.name;
            [self loadPreviews];
        }];
        [RACObserve(self, client) subscribeNext:^(id x) {
            [self loadPreviews];
        }];
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (void)loadPreviews {
    if (self.client && self.file) {
        for (LVCFileRevision *revision in self.file.revisions) {
            [self.client getPreviewURLsForRevision:revision
                                             width:200
                                            height:200
                                        completion:^(NSArray *urls,
                                                     NSError *error,
                                                     AFHTTPRequestOperation *operation) {
                if (urls.count > 0) {
                    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:urls[0]];
                    AFImageRequestOperation *imageRequestOp = [AFImageRequestOperation imageRequestOperationWithRequest:imageRequest success:^(NSImage *image) {
                        NSMutableArray *revs = self.revisions.mutableCopy;
                        [revs addObject:@{@"revision": revision.revision,
                                          @"image": image}];
                        NSSortDescriptor *sortRev = [NSSortDescriptor sortDescriptorWithKey:@"revision"
                                                                                       ascending:YES];
                        self.revisions = [revs sortedArrayUsingDescriptors:@[sortRev]];
                    }];
                    [imageRequestOp start];
                }}];
        }
    }
}

@end
