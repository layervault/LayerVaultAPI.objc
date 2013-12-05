//
//  LVTProject.m
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 10/25/13.
//  Copyright (c) 2013 codecaffeine. All rights reserved.
//

#import "LVTProject.h"


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
    return JSONKeyPathsByPropertyKey;
}


- (BOOL)partial
{
    return !self.path;
}


@end
