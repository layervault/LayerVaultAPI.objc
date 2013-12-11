//
//  LVAmazonS3Client.h
//  Pods
//
//  Created by Matt Thomas on 12/11/13.
//
//

#import <AFNetworking/AFNetworking.h>

OBJC_EXPORT NSString *LVTAmazonS3ClientErrorDomain;
enum
{
    LVTAmazonS3ClientErrorNoFileData = 1
};

@interface LVTAmazonS3Client : AFHTTPClient

- (void)postFile:(NSURL *)fileURL
      parameters:(NSDictionary *)parameters
     accessToken:(NSString *)accessToken
         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
