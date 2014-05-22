//
//  LVCOAuthCredentialStorage.m
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 2/5/14.
//  Copyright (c) 2013 LayerVault. All rights reserved.
//

#import "LVCOAuthCredentialStorage.h"

#ifdef _SECURITY_SECITEM_H_

NSString *const LVCOAuthCredentialStorageErrorDomain = @"LVCOAuthCredentialStorageErrorDomain";

static NSDictionary *LVCOAuthCredentialLookup(NSString *serviceName, NSString *account)
{
    return @{(__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
             (__bridge id)kSecAttrService: serviceName,
             (__bridge id)kSecAttrAccount: account};
}

@implementation LVCOAuthCredentialStorage

+ (BOOL)storeCredential:(AFOAuthCredential *)credential
        withServiceName:(NSString *)serviceName
                account:(NSString *)account
                  error:(NSError * __autoreleasing *)error
{
    NSParameterAssert(credential);
    NSParameterAssert(serviceName);
    NSParameterAssert(account);

    // archive data
    NSData *credentialData = [NSKeyedArchiver archivedDataWithRootObject:credential];
    if (!credentialData) {
        if (error) {
            *error = [self unableToArchiveCredentialError];
        }
        return NO;
    }

    AFOAuthCredential *existingCredential = [self credentialWithServiceName:serviceName
                                                                    account:account
                                                                      error:nil];

    NSDictionary *credentialDataDict = @{(__bridge id)kSecValueData: credentialData};
    NSDictionary *lookupDict = LVCOAuthCredentialLookup(serviceName, account);

    OSStatus status;
    if (existingCredential) {
        status = SecItemUpdate((__bridge CFDictionaryRef)(lookupDict),
                               (__bridge CFDictionaryRef)(credentialDataDict));
    }
    else {
        NSMutableDictionary *newKeychainDict = lookupDict.mutableCopy;
        [newKeychainDict addEntriesFromDictionary:credentialDataDict];
        status = SecItemAdd((__bridge CFDictionaryRef)newKeychainDict, NULL);
    }

    if ((status != errSecSuccess) && error) {
        *error = [self keychainErrorWithStatus:status];
    }

    return (status == errSecSuccess);
}

+ (AFOAuthCredential *)credentialWithServiceName:(NSString *)serviceName
                                         account:(NSString *)account
                                           error:(NSError * __autoreleasing *)error
{
    NSParameterAssert(serviceName);
    NSParameterAssert(account);

    NSMutableDictionary *lookupDict = LVCOAuthCredentialLookup(serviceName, account).mutableCopy;
    lookupDict[(__bridge id)kSecReturnData] = (__bridge id)kCFBooleanTrue;
    lookupDict[(__bridge id)kSecMatchLimit] = (__bridge id)kSecMatchLimitOne;

    CFDataRef credentialDataRef = nil;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)lookupDict,
                                          (CFTypeRef *)&credentialDataRef);

    if (status != errSecSuccess) {
        if (error) {
            *error = [self keychainErrorWithStatus:status];
        }
        return nil;
    }

    NSData *credentialData = (__bridge_transfer NSData *)credentialDataRef;
    AFOAuthCredential *credential = [NSKeyedUnarchiver unarchiveObjectWithData:credentialData];

    return credential;
}

+ (BOOL)deleteCredentialWithServiceName:(NSString *)serviceName
                                account:(NSString *)account
                                  error:(NSError * __autoreleasing *)error
{
    NSParameterAssert(serviceName);
    NSParameterAssert(account);

    NSDictionary *lookupDict = LVCOAuthCredentialLookup(serviceName, account);
    OSStatus status = SecItemDelete((__bridge CFDictionaryRef)lookupDict);

    if (status != errSecSuccess && error) {
        *error = [self keychainErrorWithStatus:status];
    }

    return (status == errSecSuccess);
}


#pragma mark - Errors
+ (NSError *)unableToArchiveCredentialError
{
    NSString *localizedDescription = NSLocalizedString(@"Unable to archive credential", nil);
    return [NSError errorWithDomain:LVCOAuthCredentialStorageErrorDomain
                               code:LVCOAuthCredentialStorageErrorUnableToArchiveCredential
                           userInfo:@{NSLocalizedDescriptionKey: localizedDescription}];
}

+ (NSError *)keychainErrorWithStatus:(OSStatus)status
{
    NSString *localizedDescription = NSLocalizedString(@"Unexpected Keychain Status", nil);
    return [NSError errorWithDomain:LVCOAuthCredentialStorageErrorDomain
                               code:LVCOAuthCredentialStorageErrorKeychainStatus
                           userInfo:@{NSLocalizedDescriptionKey: localizedDescription,
                                      @"OSStatus": @(status)}];
}

@end


#endif
