//
//  LVCAmazonS3Client.m
//  Pods
//
//  Created by Matt Thomas on 12/11/13.
//
//

#import "LVCAmazonS3Client.h"

NSString *LVCAmazonS3ClientErrorDomain = @"LVCAmazonS3ClientErrorDomain";


static NSString *mimeForFile(NSURL *fileURL)
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
    NSURL *url = [NSURL URLWithString:@"https://omnivore-scratch.s3.amazonaws.com"];
    return [self initWithBaseURL:url];
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

    NSString *fileMimeType = mimeForFile(fileURL);
    NSMutableDictionary *params = parameters.mutableCopy;
    params[@"Content-Type"] = fileMimeType;

    NSMutableURLRequest *fileRequest = [NSMutableURLRequest requestWithURL:fileURL];
    [fileRequest setCachePolicy:NSURLCacheStorageNotAllowed];

    NSURLResponse *response = nil;
    NSError *fileError = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:fileRequest
                                         returningResponse:&response
                                                     error:&fileError];
    if (data) {
        NSMutableURLRequest *request = [self multipartFormRequestWithMethod:@"POST" path:nil parameters:params constructingBodyWithBlock:^(id <AFMultipartFormData> formData) {
            [formData appendPartWithFileData:data
                                        name:@"file"
                                    fileName:fileURL.lastPathComponent
                                    mimeType:fileMimeType];
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

        [self enqueueHTTPRequestOperation:requestOperation];
    }
    else {
        if (failure) {
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey: NSLocalizedString(@"Cannot Upload File", nil),
                                       NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"No Data Return From File", nil),
                                       NSLocalizedRecoveryOptionsErrorKey: NSLocalizedString(@"Make sure the file exists", nil),
                                       @"fileRequest": fileRequest,
                                       @"response": response};
            NSError *error = [NSError errorWithDomain:LVCAmazonS3ClientErrorDomain
                                                 code:LVCAmazonS3ClientErrorNoFileData
                                             userInfo:userInfo];
            failure(nil, error);
        }
    }
}

@end
