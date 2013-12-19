//
//  LVCMockResponses.m
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 12/19/13.
//  Copyright (c) 2013 LayerVault. All rights reserved.
//

#import "LVCMockResponses.h"


NSDictionary *LVCValidFileRevisionJSON()
{
    return @{@"revision_number": @(4),
             @"md5": @"DEADBEEF",
             @"created_at": @"2013-11-10T01:23:45Z",
             @"updated_at": @"2013-11-20T20:11:10Z",
             @"full_url": @"https://layervault.com/codecaffeine/awesome-sauce/oxchitl/salsa.png/4",
             @"download_url": @"https://layervault.com/files/download_node/DEADBEEF",
             @"shortened_url": @"http://lyrv.lt/DEADBEEF"};
}

NSDictionary *LVCValidFileJSON()
{
    return @{@"name": @"salsa.png",
             @"local_path": @"~/LayerVault/awesome-sauce/oxchitl/salsa.png",
             @"updated_at": @"2013-11-20T20:11:10Z",
             @"deleted_at": NSNull.null,
             @"md5": @"DEADBEEF",
             @"full_url": @"https://layervault.com/codecaffeine/awesome-sauce/oxchitl/salsa.png",
             @"shortened_url": @"http://lyrv.lt/DEADBEEF",
             @"revisions": @[LVCValidFileRevisionJSON()]};
}

NSDictionary *LVCValidFolderJSON()
{
    return @{@"name": @"oxchitl",
             @"color": NSNull.null,
             @"path": @"awesome-sauce/oxchitl",
             @"local_path": @"~/LayerVault/oxchitl",
             @"updated_at": @"2013-11-20T20:11:10Z",
             @"deleted_at": NSNull.null,
             @"md5": NSNull.null,
             @"full_url": @"https://layervault.com/awesome-sauce/oxchitl",
             @"shortened_url": @"http://lyrv.lt/DEADBEEF",
             @"organization_permalink": @"awesome-sauce",
             @"folders": @[],
             @"files": @[LVCValidFileJSON()]};
}

NSDictionary *LVCValidProjectJSON()
{
    return @{@"name": @"oxchitl",
             @"color": NSNull.null,
             @"path": @"awesome-sauce/oxchitl",
             @"local_path": @"~/LayerVault/oxchitl",
             @"updated_at": @"2013-11-20T20:11:10Z",
             @"deleted_at": NSNull.null,
             @"md5": NSNull.null,
             @"full_url": @"https://layervault.com/awesome-sauce/oxchitl",
             @"shortened_url": @"http://lyrv.lt/DEADBEEF",
             @"organization_permalink": @"awesome-sauce",
             @"member": @NO,
             @"folders": @[LVCValidFolderJSON()],
             @"files": @[]};
}
