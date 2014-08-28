//
//  LVCAmazonS3Client.m
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 12/11/13.
//  Copyright (c) 2013 LayerVault. All rights reserved.
//

#import "LVCAmazonS3Client.h"
#import "LVCAmazonS3Bucket.h"

#if TARGET_OS_IPHONE
#import <MobileCoreServices/MobileCoreServices.h>
#elif TARGET_OS_MAC
#import <CoreServices/CoreServices.h>
#endif

NSString *LVCAmazonS3ClientErrorDomain = @"LVCAmazonS3ClientErrorDomain";


NSString *mimeForFile(NSURL *fileURL)
{
    CFStringRef uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension,
                                                            (__bridge CFStringRef)fileURL.pathExtension,
                                                            NULL);
    CFStringRef mime = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType);
    CFRelease(uti);
    return mime ? (__bridge_transfer NSString *)mime : @"application/octet-stream";
}

@implementation LVCAmazonS3Client

- (instancetype)init
{
    return [self initWithBaseURL:[LVCAmazonS3Bucket baseURLForLocalTimezone]];
}


- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (self) {
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [self setDefaultHeader:@"Accept" value:@"application/json"];
    }
    return self;
}


- (void)postFile:(NSURL *)fileURL
      parameters:(NSDictionary *)parameters
     accessToken:(NSString *)accessToken
         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSParameterAssert(fileURL);
    NSParameterAssert(parameters);

    AFHTTPRequestOperation *uploadOperation = [self uploadOperationForFile:fileURL
                                                                parameters:parameters
                                                               accessToken:accessToken
                                                                   success:success
                                                                   failure:failure];
    [self enqueueHTTPRequestOperation:uploadOperation];
}

- (AFHTTPRequestOperation *)uploadOperationForFile:(NSURL *)fileURL
                                        parameters:(NSDictionary *)parameters
                                       accessToken:(NSString *)accessToken
                                           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSMutableDictionary *params = parameters.mutableCopy;
    NSString *fileMimeType = mimeForFile(fileURL);
    if (fileMimeType) {
        params[@"Content-Type"] = fileMimeType;
    }

    NSMutableURLRequest *request = [self multipartFormRequestWithMethod:@"POST" path:nil parameters:params constructingBodyWithBlock:^(id <AFMultipartFormData> formData) {
        NSError *error;
        BOOL success = [formData appendPartWithFileURL:fileURL
                                                  name:@"file"
                                              fileName:fileURL.lastPathComponent
                                              mimeType:fileMimeType
                                                 error:&error];
        if (!success) {
            NSLog(@"error: %@", error);
        }
    }];

    AFHTTPRequestOperation *requestOperation = [self HTTPRequestOperationWithRequest:request
                                                                             success:success
                                                                             failure:failure];

    // We need to rewrite our API server redirect with an access_token. This
    // assumes that any request not going to self.baseURL is going to our
    // API service instead.
    [requestOperation setRedirectResponseBlock:^NSURLRequest *(NSURLConnection *connection, NSURLRequest *request, NSURLResponse *redirectResponse) {
        NSString *baseURLString = self.baseURL.absoluteString;
        NSString *requestURLString = request.URL.absoluteString;
        NSUInteger minLength = MIN(baseURLString.length, requestURLString.length);
        requestURLString = [requestURLString substringToIndex:minLength];
        if ([requestURLString isEqualToString:baseURLString]) {
            return request;
        }
        else {
            NSMutableURLRequest *newRequest = request.mutableCopy;
            NSString *urlString = request.URL.absoluteString;
            urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"&access_token=%@", accessToken]];
            newRequest.URL = [NSURL URLWithString:urlString];
            newRequest.HTTPMethod = @"POST";
            return newRequest;
        }
    }];

    return requestOperation;
}

@end
