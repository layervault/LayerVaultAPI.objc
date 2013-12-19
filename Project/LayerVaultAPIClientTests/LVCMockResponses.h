//
//  LVCMockResponses.h
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 12/19/13.
//  Copyright (c) 2013 LayerVault. All rights reserved.
//

#import <Foundation/Foundation.h>

// main attributes
OBJC_EXPORT NSString *const LVCMockMD5;
OBJC_EXPORT NSString *const LVCMockShortenedURL;
OBJC_EXPORT NSString *const LVCMockOrgName;
OBJC_EXPORT NSString *const LVCMockOrgPermalink;
OBJC_EXPORT NSString *const LVCMockProjectName;
OBJC_EXPORT NSString *const LVCMockFolderName;
OBJC_EXPORT NSString *const LVCMockFileName;
OBJC_EXPORT NSNumber *LVCMockFileRevision();

// derived attributes
OBJC_EXPORT NSString *LVCMockFullProjPath();
OBJC_EXPORT NSString *LVCMockFullProjURLPath();
OBJC_EXPORT NSString *LVCMockFullFolderPath();
OBJC_EXPORT NSString *LVCMockFullFolderURLPath();
OBJC_EXPORT NSString *LVCMockFullFilePath();
OBJC_EXPORT NSString *LVCMockFullFileURLPath();
OBJC_EXPORT NSString *LVCMockFullFileRevisionURLPath();

// derived JSON
OBJC_EXPORT NSDictionary *LVCValidFileRevisionJSON();
OBJC_EXPORT NSDictionary *LVCValidFileJSON();
OBJC_EXPORT NSDictionary *LVCValidFolderJSON();
OBJC_EXPORT NSDictionary *LVCValidProjectJSON();
OBJC_EXPORT NSDictionary *LVCValidOrganizationJSON();
