//
//  LVCProject.m
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 10/25/13.
//  Copyright (c) 2013 LayerVault. All rights reserved.
//

#import "LVCProject.h"
#import "LVCFile.h"


@implementation LVCProject

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{@"projectID": @"id",
             @"name": @"name",
             @"slug": @"slug",
             @"url": @"url",
             @"organizationID": @"links.organization",
             @"folderIDs": @"links.folders",
             @"fileIDs": @"links.files",
             @"presentationIDs": @"links.presentations",
             @"userIDs": @"links.users"};
}


+ (NSValueTransformer *)urlJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

@end
