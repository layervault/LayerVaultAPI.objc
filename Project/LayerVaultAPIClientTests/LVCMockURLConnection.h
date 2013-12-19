//
//  LVCMockURLConnection.h
//  LayerVault
//
//  Created by Matt Thomas on 7/24/13.
//  Copyright (c) 2013 LayerVault. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  `CAFMockURLConnection` is a `NSURLProtocol` subclass that mocks responses 
 *  used by the NSURL loading system for testing purposes. This is based off of 
 *  information and code from:
 *
 *  - http://nshipster.com/nsurlprotocol/
 *  - http://www.infinite-loop.dk/blog/2011/09/using-nsurlprotocol-for-injecting-test-data/
 */

@interface LVCMockURLConnection : NSURLProtocol

/**
 *  Sets the statusCode, headerFields, and bodyData we will send back to the client
 *
 *  @param statusCode   The HTTP status code to send back
 *  @param headerFields The HTTP header fields to send back
 *  @param bodyData     The HTTP body data to send back
 */
+ (void)setResponseWithStatusCode:(NSInteger)statusCode
                     headerFields:(NSDictionary *)headerFields
                         bodyData:(NSData *)bodyData;


/**
 *	Sets a JSON Dictionary Response with an HTTP Status Code
 *
 *	@param	statusCode      HTTP Status code of response
 *	@param	bodyDictionary	JSON Dictionary Response
 */
+ (void)setJSONResponseWithStatusCode:(NSInteger)statusCode
                       bodyDictionary:(NSDictionary *)bodyDictionary;


/**
 *	Sets a JSON Array Response with an HTTP Status Code
 *
 *	@param	statusCode	HTTP Status code of response
 *	@param	bodyArray	JSON Array Response
 */
+ (void)setJSONResponseWithStatusCode:(NSInteger)statusCode
                            bodyArray:(NSArray *)bodyArray;


/**
 *  Sets the error to return to the client
 *
 *  @param error The error to return to the client
 */
+ (void)setError:(NSError *)error;


/**
 *	The Default JSON Header Fields
 *
 *	@return	Content-Type application/json; charset=utf-8
 */
+ (NSDictionary *)JSONHeaderFields;

@end
