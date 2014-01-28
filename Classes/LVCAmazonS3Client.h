//
//  LVCAmazonS3Client.h
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 12/11/13.
//  Copyright (c) 2013 LayerVault. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

OBJC_EXPORT NSString *LVCAmazonS3ClientErrorDomain;
enum
{
    LVCAmazonS3ClientErrorNoFileData = 1
};


OBJC_EXPORT NSString *mimeForFile(NSURL *fileURL);

/**
 *  LVCAmazonS3Client is the main interface for uploading images to the AmazonS3
 *  service.
 */
@interface LVCAmazonS3Client : AFHTTPClient

/**
 *  Post a file to the LayerVault S3 bucket.
 *
 *  @param fileURL     The local URL of the file to upload
 *  @param parameters  Parameter AmazonS3 needs to upload
 *  @param accessToken Access token used to redirect back to LayerVault
 *  @param success     Callback when the operation succeeds. Response object 
 *                     should contain JSON dictionary to create an LVCFile 
 *                     object
 *  @param failure     Callback when the operation fails with an error.
 */
- (void)postFile:(NSURL *)fileURL
      parameters:(NSDictionary *)parameters
     accessToken:(NSString *)accessToken
         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
