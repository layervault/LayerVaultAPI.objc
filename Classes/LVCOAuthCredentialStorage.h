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

/**
 *  LVCOAuthCredentialStorage is used to store, retrieve, and delete 
 *  AFOAuthCredentials in the system keychain. This is a replacement to the
 *  similar AFOAuthCredential class methods that allow the user to specify
 *  a Service Name and allow better error handling.
 */
@interface LVCOAuthCredentialStorage : NSObject

/**
 *  Stores an AFOAuthCredential in the keychain.
 *
 *  @param credential  AFOAuthCredential to store. Required.
 *  @param serviceName Keychain service name (kSecAttrService). Required.
 *  @param account     Keychain account (kSecAttrAccount). Required.
 *  @param error       Any error that occurred when attempting to store.
 *
 *  @return YES if credential was stored successfully in the keychain, otherwise
 *          NO with the error populated.
 */
+ (BOOL)storeCredential:(AFOAuthCredential *)credential
        withServiceName:(NSString *)serviceName
                account:(NSString *)account
                  error:(NSError * __autoreleasing *)error;

/**
 *  Retrieves a credential from the keychain matching service name & account.
 *
 *  @param serviceName Keychain service name (kSecAttrService). Required.
 *  @param account     Keychain account (kSecAttrAccount). Required.
 *  @param error       Any error that occurred when attempting to match.
 *
 *  @return A matching credential, or nil (with an error) if unable to find one.
 */
+ (AFOAuthCredential *)credentialWithServiceName:(NSString *)serviceName
                                         account:(NSString *)account
                                           error:(NSError * __autoreleasing *)error;

/**
 *  Deletes a credential from the keychain matching service name & account.
 *
 *  @param serviceName Keychain service name (kSecAttrService). Required.
 *  @param account     Keychain account (kSecAttrAccount). Required.
 *  @param error       Any error that occurred when attempting to delete.
 *
 *  @return YES if credential was deleted successfully from the keychain, 
 *          otherwise NO with the error populated.
 */
+ (BOOL)deleteCredentialWithServiceName:(NSString *)serviceName
                                account:(NSString *)account
                                  error:(NSError * __autoreleasing *)error;

@end

/**
 *  @name Error Management
 */
OBJC_EXPORT NSString *const LVCOAuthCredentialStorageErrorDomain;

typedef enum LVCOAuthCredentialStorageErrorCodes : NSUInteger {
    /**
     *  The AFOAuthCredential is unable to be archived.
     */
    LVCOAuthCredentialStorageErrorUnableToArchiveCredential,

    /**
     *  Keychain operation failed. An OSStatus key is provided that corresponds
     *  to the failure reason. See Security/SecBase.h
     */
    LVCOAuthCredentialStorageErrorKeychainStatus

} LVCOAuthCredentialStorageErrorCodes;


#endif
