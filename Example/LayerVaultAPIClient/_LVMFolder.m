// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to LVMFolder.m instead.

#import "_LVMFolder.h"

const struct LVMFolderAttributes LVMFolderAttributes = {
	.name = @"name",
	.slug = @"slug",
	.uid = @"uid",
	.url = @"url",
};

const struct LVMFolderRelationships LVMFolderRelationships = {
	.files = @"files",
	.folders = @"folders",
	.parentFolder = @"parentFolder",
};

@implementation LVMFolderID
@end

@implementation _LVMFolder

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"LVMFolder" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"LVMFolder";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"LVMFolder" inManagedObjectContext:moc_];
}

- (LVMFolderID*)objectID {
	return (LVMFolderID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic name;

@dynamic slug;

@dynamic uid;

@dynamic url;

@dynamic files;

- (NSMutableSet*)filesSet {
	[self willAccessValueForKey:@"files"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"files"];

	[self didAccessValueForKey:@"files"];
	return result;
}

@dynamic folders;

- (NSMutableSet*)foldersSet {
	[self willAccessValueForKey:@"folders"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"folders"];

	[self didAccessValueForKey:@"folders"];
	return result;
}

@dynamic parentFolder;

@end

