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
    
    NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:[request URL]
                                                              statusCode:LVCMockURLConnectionStatusCode
                                                             HTTPVersion:@"HTTP/1.1"
                                                            headerFields:LVCMockURLConnectionHeaderFields];
    [client URLProtocol:self
     didReceiveResponse:response
     cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    [client URLProtocol:self
            didLoadData:LVCMockURLConnectionResponseData];
    [client URLProtocolDidFinishLoading:self];
}


- (void)stopLoading {}


#pragma mark - Class Methods
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
                                                       options:nil
                                                         error:&error];
    if (!bodyData) {
        NSLog(@"Error serializing: %@", error);
    }
    else {
        LVCMockURLConnectionResponseData = [bodyData copy];
    }
}

@end
