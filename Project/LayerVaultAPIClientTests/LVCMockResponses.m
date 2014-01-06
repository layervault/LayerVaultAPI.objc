//
//  LVCMockResponses.m
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 12/19/13.
//  Copyright (c) 2013 LayerVault. All rights reserved.
//

#import "LVCMockResponses.h"

NSString *const LVCMockMD5 = @"DEADBEEF";
NSString *const LVCMockShortenedURL = @"http://lyrv.lt/DEADBEEF";
NSString *const LVCMockOrgName = @"Awesome Sauce";
NSString *const LVCMockOrgPermalink = @"awesome-sauce";
NSString *const LVCMockProjectName = @"Very Hot";
NSString *const LVCMockFolderName = @"oxchitl";
NSString *const LVCMockFileName = @"salsa.png";

NSNumber *LVCMockFileRevision() {
    return @(4);
}

NSString *LVCMockFullProjPath() {
    return [LVCMockOrgName stringByAppendingPathComponent:LVCMockProjectName];
}

NSString *LVCMockFullProjURLPath() {
    return [LVCMockOrgPermalink stringByAppendingPathComponent:LVCMockProjectName];
}

NSString *LVCMockFullFolderPath() {
    return [LVCMockFullProjPath() stringByAppendingPathComponent:LVCMockFolderName];
}

NSString *LVCMockFullFolderURLPath() {
    return [LVCMockFullProjURLPath() stringByAppendingPathComponent:LVCMockFolderName];
}

NSString *LVCMockFullFilePath() {
    return [LVCMockFullFolderPath() stringByAppendingPathComponent:LVCMockFileName];
}

NSString *LVCMockFullFileURLPath() {
    return [LVCMockFullFolderURLPath() stringByAppendingPathComponent:LVCMockFileName];
}

NSString *LVCMockFullFileRevisionURLPath() {
    return [LVCMockFullFileURLPath() stringByAppendingPathComponent:LVCMockFileRevision().stringValue];
}


NSDictionary *LVCValidFileRevisionJSON() {
    NSString *urlPath = [[NSString stringWithFormat:@"https://layervault.com/%@", LVCMockFullFileRevisionURLPath()] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return @{@"revision_number": LVCMockFileRevision(),
             @"md5": LVCMockMD5,
             @"created_at": @"2013-11-10T01:23:45Z",
             @"updated_at": @"2013-11-20T20:11:10Z",
             @"full_url": urlPath,
             @"download_url": @"https://layervault.com/files/download_node/DEADBEEF",
             @"shortened_url": LVCMockShortenedURL};
}

NSDictionary *LVCValidFileJSON() {
    NSString *localPath = [NSString stringWithFormat:@"~/LayerVault/%@", LVCMockFullFilePath()];
    NSString *urlPath = [[NSString stringWithFormat:@"https://layervault.com/%@", LVCMockFullFileURLPath()] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return @{@"name": LVCMockFileName,
             @"local_path": localPath,
             @"updated_at": @"2013-11-20T20:11:10Z",
             @"deleted_at": NSNull.null,
             @"md5": LVCMockMD5,
             @"full_url": urlPath,
             @"shortened_url": LVCMockShortenedURL,
             @"revisions": @[LVCValidFileRevisionJSON()]};
}

NSDictionary *LVCValidFolderJSON() {
    NSString *localPath = [NSString stringWithFormat:@"~/LayerVault/%@", LVCMockFullFolderPath()];
    NSString *urlPath = [[NSString stringWithFormat:@"https://layervault.com/%@", LVCMockFullFolderURLPath()] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return @{@"name": LVCMockFolderName,
             @"color": NSNull.null,
             @"path": LVCMockFullFolderPath(),
             @"local_path": localPath,
             @"updated_at": @"2013-11-20T20:11:10Z",
             @"deleted_at": NSNull.null,
             @"md5": NSNull.null,
             @"full_url": urlPath,
             @"shortened_url": LVCMockShortenedURL,
             @"organization_permalink": LVCMockOrgPermalink,
             @"folders": @[],
             @"files": @[LVCValidFileJSON()]};
}

NSDictionary *LVCValidProjectJSON() {
    NSString *localPath = [NSString stringWithFormat:@"~/LayerVault/%@", LVCMockFullProjPath()];
    NSString *urlPath = [[NSString stringWithFormat:@"https://layervault.com/%@", LVCMockFullProjURLPath()] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return @{@"name": LVCMockProjectName,
             @"color": NSNull.null,
             @"path": LVCMockFullProjPath(),
             @"local_path": localPath,
             @"updated_at": @"2013-11-20T20:11:10Z",
             @"deleted_at": NSNull.null,
             @"md5": NSNull.null,
             @"full_url": urlPath,
             @"shortened_url": LVCMockShortenedURL,
             @"organization_permalink": LVCMockOrgPermalink,
             @"member": @YES,
             @"folders": @[LVCValidFolderJSON()],
             @"files": @[]};
}

NSDictionary *LVCValidProjectPartialJSON() {
    NSMutableDictionary *partialDict = LVCValidProjectJSON().mutableCopy;
    [partialDict removeObjectForKey:@"path"];
    return partialDict.copy;
}

NSDictionary *LVCValidOrganizationJSON() {
    return @{@"name": LVCMockOrgName,
             @"permalink": LVCMockOrgPermalink,
             @"deleted_at": @"3013-02-26T16:53:38Z",
             @"updated_at": @"2013-12-17T18:26:42Z",
             @"full_url": [NSString stringWithFormat:@"https://layervault.com/%@", LVCMockOrgPermalink],
             @"sync_type": @"layervault",
             @"projects": @[]
             };
}

