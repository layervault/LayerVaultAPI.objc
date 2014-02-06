//
//  LVCOAuthCredentialStorage.h
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 2/5/14.
//  Copyright (c) 2013 LayerVault. All rights reserved.
//

#ifdef _SECURITY_SECITEM_H_

#import <Foundation/Foundation.h>
#import <Security/SecItem.h>
#import <AFOAuth2Client/AFOAuth2Client.h>

OBJC_EXPORT NSString *const LVCOAuthCredentialStorageErrorDomain;

typedef enum LVCOAuthCredentialStorageErrorCodes : NSUInteger {
    LVCOAuthCredentialStorageErrorUnableToArchiveCredential,
    LVCOAuthCredentialStorageErrorKeychainStatus
} LVCOAuthCredentialStorageErrorCodes;

@interface LVCOAuthCredentialStorage : NSObject

+ (BOOL)storeCredential:(AFOAuthCredential *)credential
        withServiceName:(NSString *)serviceName
                account:(NSString *)account
                  error:(NSError * __autoreleasing *)error;

+ (AFOAuthCredential *)credentialWithServiceName:(NSString *)serviceName
                                         account:(NSString *)account
                                           error:(NSError * __autoreleasing *)error;

+ (BOOL)deleteCredentialWithServiceName:(NSString *)serviceName
                                account:(NSString *)account
                                  error:(NSError * __autoreleasing *)error;

@end

#endif
