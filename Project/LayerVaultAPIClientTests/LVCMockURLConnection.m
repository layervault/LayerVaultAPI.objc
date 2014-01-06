//
//  LVCMockURLConnection.m
//  LayerVault
//
//  Created by Matt Thomas on 7/24/13.
//  Copyright (c) 2013 LayerVault. All rights reserved.
//

#import "LVCMockURLConnection.h"


NSData *LVCMockURLConnectionResponseData;
NSDictionary *LVCMockURLConnectionHeaderFields;
NSInteger LVCMockURLConnectionStatusCode;
NSError *LVCMockURLConnectionError;
NSMutableDictionary *LVCCannedResponsesForPaths;

NSString const *LVCCannedStatusCodeKey = @"LVCCannedStatusCodeKey";
NSString const *LVCCannedHeaderFieldsKey = @"LVCCannedHeaderFieldsKey";
NSString const *LVCCannedBodyDataKey = @"LVCCannedBodyDataKey";


@implementation LVCMockURLConnection

#pragma mark - NSURLProtocol
+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    return YES;
}


+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    return request;
}


- (void)startLoading {
    NSURLRequest *request = [self request];
    id<NSURLProtocolClient> client = [self client];

    if (LVCMockURLConnectionError) {
        [client URLProtocol:self didFailWithError:LVCMockURLConnectionError];
        return;
    }

    NSHTTPURLResponse *response = nil;
    NSDictionary *cannedResponseForPath = [LVCCannedResponsesForPaths objectForKey:self.request.URL.path];
    if (cannedResponseForPath) {
        response = [[NSHTTPURLResponse alloc] initWithURL:request.URL
                                               statusCode:[cannedResponseForPath[LVCCannedStatusCodeKey] integerValue]
                                              HTTPVersion:@"HTTP/1.1"
                                             headerFields:cannedResponseForPath[LVCCannedHeaderFieldsKey]];
    }
    else {
        response = [[NSHTTPURLResponse alloc] initWithURL:[request URL]
                                               statusCode:LVCMockURLConnectionStatusCode
                                              HTTPVersion:@"HTTP/1.1"
                                             headerFields:LVCMockURLConnectionHeaderFields];
    }

    [client URLProtocol:self
     didReceiveResponse:response
     cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    if (cannedResponseForPath) {
        [client URLProtocol:self
                didLoadData:cannedResponseForPath[LVCCannedBodyDataKey]];
    }
    else {
        [client URLProtocol:self
                didLoadData:LVCMockURLConnectionResponseData];
    }
    [client URLProtocolDidFinishLoading:self];
}


- (void)stopLoading {}


#pragma mark - Class Methods
+ (void)setResponseForPath:(NSString *)path
            withStatusCode:(NSInteger)statusCode
              headerFields:(NSDictionary *)headerFields
                  bodyData:(NSData *)bodyData
{
    NSParameterAssert(path);

    if (!LVCCannedResponsesForPaths) {
        LVCCannedResponsesForPaths = @{}.mutableCopy;
    }
    NSMutableDictionary *dict = @{}.mutableCopy;
    if (statusCode > 0) {
        dict[LVCCannedStatusCodeKey] = @(statusCode);
    }
    if (headerFields) {
        dict[LVCCannedHeaderFieldsKey] = headerFields;
    }
    if (bodyData) {
        dict[LVCCannedBodyDataKey] = bodyData;
    }

    if (dict.count > 0) {
        [LVCCannedResponsesForPaths setObject:dict
                                       forKey:path];
    }
}


+ (void)setResponseWithStatusCode:(NSInteger)statusCode
                     headerFields:(NSDictionary *)headerFields
                         bodyData:(NSData *)bodyData {
    LVCMockURLConnectionStatusCode = statusCode;
    LVCMockURLConnectionHeaderFields = [headerFields copy];
    LVCMockURLConnectionResponseData = [bodyData copy];
}


+ (void)setJSONResponseWithStatusCode:(NSInteger)statusCode
                       bodyDictionary:(NSDictionary *)bodyDictionary
{
    [LVCMockURLConnection setJSONResponseWithStatusCode:statusCode
                                             bodyObject:bodyDictionary];
}


+ (void)setJSONResponseWithStatusCode:(NSInteger)statusCode
                            bodyArray:(NSArray *)bodyArray
{
    [LVCMockURLConnection setJSONResponseWithStatusCode:statusCode
                                             bodyObject:bodyArray];
}



+ (void)setError:(NSError *)error {
    LVCMockURLConnectionError = [error copy];
}


+ (NSDictionary *)JSONHeaderFields
{
    return @{@"Content-Type": @"application/json; charset=utf-8"};
}


#pragma mark - Private Class Methods
+ (void)setJSONResponseWithStatusCode:(NSInteger)statusCode
                           bodyObject:(id)bodyObject
{
    LVCMockURLConnectionStatusCode = statusCode;
    LVCMockURLConnectionHeaderFields = [[LVCMockURLConnection JSONHeaderFields] copy];
    NSError *error;
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:bodyObject
                                                       options:0
                                                         error:&error];
    if (!bodyData) {
        NSLog(@"Error serializing: %@", error);
    }
    else {
        LVCMockURLConnectionResponseData = [bodyData copy];
    }
}

@end
