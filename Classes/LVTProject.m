//
//  LVTProject.m
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 10/25/13.
//  Copyright (c) 2013 codecaffeine. All rights reserved.
//

#import "LVTProject.h"
#import "LVCFile.h"


@implementation LVTProject

- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue
                          isSynced:(BOOL)synced
                             error:(NSError *__autoreleasing *)error
{
    self = [super initWithDictionary:dictionaryValue error:error];
    if (self) {
        _synced = synced;
    }
    return self;
}


- (instancetype)initWithName:(NSString *)name
       organizationPermalink:(NSString *)organizationPermalink
{
    NSParameterAssert(name);
    NSParameterAssert(organizationPermalink);

    NSDictionary *dict = @{@"name": name,
                           @"organizationPermalink": organizationPermalink};

    return [self initWithDictionary:dict isSynced:NO error:nil];
}


- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError *__autoreleasing *)error
{
    return [self initWithDictionary:dictionaryValue isSynced:YES error:error];
}


+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSMutableDictionary *JSONKeyPathsByPropertyKey = [super JSONKeyPathsByPropertyKey].mutableCopy;
    [JSONKeyPathsByPropertyKey addEntriesFromDictionary:@{@"member": @"member"}];
    return JSONKeyPathsByPropertyKey.copy;
}


- (BOOL)partial
{
    return !self.path;
}


- (void)mergeValueForKey:(NSString *)key fromModel:(MTLModel *)model
{
    [super mergeValueForKey:key fromModel:model];
    if ([key isEqualToString:@"files"]) {
        for (LVCFile *file in self.files) {
            file.parentFolder = self;
        }
    }
    else if ([key isEqualToString:@"folders"]) {
        for (LVCFolder *folder in self.folders) {
            folder.parentFolder = self;
        }
    }
}


- (NSString *)urlPath
{
    return [self.organizationPermalink stringByAppendingPathComponent:[super urlPath]];
}


@end
