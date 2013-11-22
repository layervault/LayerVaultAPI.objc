//
//  LVTFile.h
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 11/18/13.
//  Copyright (c) 2013 codecaffeine. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface LVTFile : MTLModel <MTLJSONSerializing>

@property (readonly, nonatomic) NSDate *dateDeleted;
@property (readonly, nonatomic) NSURL *downloadURL;
@property (readonly, nonatomic) NSURL *webURL;
@property (readonly, nonatomic, copy) NSString *localPath;
@property (readonly, nonatomic, copy) NSString *md5;
@property (readonly, nonatomic) NSDate *dateModified;
@property (readonly, nonatomic) NSNumber *revisionNumber;
@property (readonly, nonatomic, copy) NSArray *revisions;
@property (readonly, nonatomic) NSURL *shortenedURL;
@property (readonly, nonatomic) NSDate *dateUpdated;

//"deleted_at": null,
//"download_url": "https://layervault.com/files/download_node/V7x1XZnMTV",
//"full_url": "https://layervault.com/layervault/Designer%20News/Illustrations/PageBreaks.ai",
//"local_path": "~/LayerVault/Designer News/Illustrations/PageBreaks.ai",
//"md5": "b1c0ee28cd5e91fe36fa55e37467edb3",
//"modified_at": "2013-10-05T00:22:31Z",
//"revision_number": 10,
//"revisions": [
//              {
//                  "created_at": "2013-10-05T00:09:16Z",
//                  "download_url": "https://layervault.com/files/download_node/d3G8PLyj0Z",
//                  "full_url": "https://layervault.com/layervault/Designer%20News/Illustrations/PageBreaks.ai/1",
//                  "md5": "e309c39f50f6ad7469beb52bbdae11d0",
//                  "revision_number": 1,
//                  "shortened_url": "http://lyrv.lt/d3G8PLyj0Z",
//                  "updated_at": "2013-10-18T18:40:12Z"
//              },
//              ...
//              ],
//"shortened_url": "http://lyrv.lt/Jm3nbPXCc7",
//"updated_at": "2013-10-18T18:40:12Z"

@end
