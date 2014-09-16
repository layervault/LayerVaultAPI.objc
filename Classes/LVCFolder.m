//
//  LVCFolder.m
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 12/4/13.
//  Copyright (c) 2013 LayerVault. All rights reserved.
//

#import "LVCFolder.h"
#import "LVCFile.h"

@implementation LVCFolder

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"folderID": @"id",
             @"name": @"name",
             @"slug": @"slug",
             @"url": @"url",
             @"projectID": @"links.project",
             @"folderIDs": @"links.folders",
             @"fileIDs": @"links.files"};
}

+ (NSValueTransformer *)urlJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

@end
