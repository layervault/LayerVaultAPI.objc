//
//  LVTFileRevision.h
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 11/18/13.
//  Copyright (c) 2013 codecaffeine. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface LVTFileRevision : MTLModel <MTLJSONSerializing>
@property (readonly, nonatomic) NSNumber *revision;
@property (readonly, nonatomic) NSString *md5;
@property (readonly, nonatomic) NSDate *dateCreated;
@property (readonly, nonatomic) NSDate *dateUpdated;
@property (readonly, nonatomic) NSURL *webURL;
@property (readonly, nonatomic) NSURL *downloadURL;
@property (readonly, nonatomic) NSURL *shortenedURL;


//"created_at": "2013-10-05T00:09:16Z",
//"download_url": "https://layervault.com/files/download_node/d3G8PLyj0Z",
//"full_url": "https://layervault.com/layervault/Designer%20News/Illustrations/PageBreaks.ai/1",
//"md5": "e309c39f50f6ad7469beb52bbdae11d0",
//"revision_number": 1,
//"shortened_url": "http://lyrv.lt/d3G8PLyj0Z",
//"updated_at": "2013-10-18T18:40:12Z"


@end
