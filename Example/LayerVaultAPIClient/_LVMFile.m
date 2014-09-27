// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to LVMFile.m instead.

#import "_LVMFile.h"

const struct LVMFileAttributes LVMFileAttributes = {
	.canCommentOnFile = @"canCommentOnFile",
	.canEditNode = @"canEditNode",
	.dateCreated = @"dateCreated",
	.dateDeleted = @"dateDeleted",
	.dateModified = @"dateModified",
	.name = @"name",
	.slug = @"slug",
	.uid = @"uid",
};

const struct LVMFileRelationships LVMFileRelationships = {
	.folder = @"folder",
	.latestRevision = @"latestRevision",
};

@implementation LVMFileID
@end

@implementation _LVMFile

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"LVMFile" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"LVMFile";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"LVMFile" inManagedObjectContext:moc_];
}

- (LVMFileID*)objectID {
	return (LVMFileID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"canCommentOnFileValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"canCommentOnFile"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"canEditNodeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"canEditNode"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic canCommentOnFile;

- (BOOL)canCommentOnFileValue {
	NSNumber *result = [self canCommentOnFile];
	return [result boolValue];
}

- (void)setCanCommentOnFileValue:(BOOL)value_ {
	[self setCanCommentOnFile:@(value_)];
}

- (BOOL)primitiveCanCommentOnFileValue {
	NSNumber *result = [self primitiveCanCommentOnFile];
	return [result boolValue];
}

- (void)setPrimitiveCanCommentOnFileValue:(BOOL)value_ {
	[self setPrimitiveCanCommentOnFile:@(value_)];
}

@dynamic canEditNode;

- (BOOL)canEditNodeValue {
	NSNumber *result = [self canEditNode];
	return [result boolValue];
}

- (void)setCanEditNodeValue:(BOOL)value_ {
	[self setCanEditNode:@(value_)];
}

- (BOOL)primitiveCanEditNodeValue {
	NSNumber *result = [self primitiveCanEditNode];
	return [result boolValue];
}

- (void)setPrimitiveCanEditNodeValue:(BOOL)value_ {
	[self setPrimitiveCanEditNode:@(value_)];
}

@dynamic dateCreated;

@dynamic dateDeleted;

@dynamic dateModified;

@dynamic name;

@dynamic slug;

@dynamic uid;

@dynamic folder;

@dynamic latestRevision;

@end

