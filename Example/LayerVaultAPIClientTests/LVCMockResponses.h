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
OBJC_EXPORT NSNumber *LVCMockFileRevision(void);

// derived attributes
OBJC_EXPORT NSString *LVCMockFullProjPath(void);
OBJC_EXPORT NSString *LVCMockFullProjURLPath(void);
OBJC_EXPORT NSString *LVCMockFullFolderPath(void);
OBJC_EXPORT NSString *LVCMockFullFolderURLPath(void);
OBJC_EXPORT NSString *LVCMockFullFilePath(void);
OBJC_EXPORT NSString *LVCMockFullFileURLPath(void);
OBJC_EXPORT NSString *LVCMockFullFileRevisionURLPath(void);

// derived JSON
OBJC_EXPORT NSDictionary *LVCValidFileRevisionJSON(void);
OBJC_EXPORT NSDictionary *LVCValidFileJSON(void);
OBJC_EXPORT NSDictionary *LVCValidFolderJSON(void);
OBJC_EXPORT NSDictionary *LVCValidProjectJSON(void);
OBJC_EXPORT NSDictionary *LVCValidProjectPartialJSON(void);
OBJC_EXPORT NSDictionary *LVCValidOrganizationJSON(void);
