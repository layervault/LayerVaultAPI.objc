// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to LVMRevision.m instead.

#import "_LVMRevision.h"

const struct LVMRevisionAttributes LVMRevisionAttributes = {
	.assembledFileDataFingerprint = @"assembledFileDataFingerprint",
	.dateCreated = @"dateCreated",
	.dateDeleted = @"dateDeleted",
	.dateUpdated = @"dateUpdated",
	.downloadURL = @"downloadURL",
	.dropboxSyncRevision = @"dropboxSyncRevision",
	.fileDataFingerprint = @"fileDataFingerprint",
	.md5 = @"md5",
	.parentMD5 = @"parentMD5",
	.remoteURL = @"remoteURL",
	.revisionNumber = @"revisionNumber",
	.shortURL = @"shortURL",
	.slug = @"slug",
	.uid = @"uid",
};

const struct LVMRevisionRelationships LVMRevisionRelationships = {
	.file = @"file",
};

@implementation LVMRevisionID
@end

@implementation _LVMRevision

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"LVMRevision" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"LVMRevision";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"LVMRevision" inManagedObjectContext:moc_];
}

- (LVMRevisionID*)objectID {
	return (LVMRevisionID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"dropboxSyncRevisionValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"dropboxSyncRevision"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"revisionNumberValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"revisionNumber"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic assembledFileDataFingerprint;

@dynamic dateCreated;

@dynamic dateDeleted;

@dynamic dateUpdated;

@dynamic downloadURL;

@dynamic dropboxSyncRevision;

- (BOOL)dropboxSyncRevisionValue {
	NSNumber *result = [self dropboxSyncRevision];
	return [result boolValue];
}

- (void)setDropboxSyncRevisionValue:(BOOL)value_ {
	[self setDropboxSyncRevision:@(value_)];
}

- (BOOL)primitiveDropboxSyncRevisionValue {
	NSNumber *result = [self primitiveDropboxSyncRevision];
	return [result boolValue];
}

- (void)setPrimitiveDropboxSyncRevisionValue:(BOOL)value_ {
	[self setPrimitiveDropboxSyncRevision:@(value_)];
}

@dynamic fileDataFingerprint;

@dynamic md5;

@dynamic parentMD5;

@dynamic remoteURL;

@dynamic revisionNumber;

- (int64_t)revisionNumberValue {
	NSNumber *result = [self revisionNumber];
	return [result longLongValue];
}

- (void)setRevisionNumberValue:(int64_t)value_ {
	[self setRevisionNumber:@(value_)];
}

- (int64_t)primitiveRevisionNumberValue {
	NSNumber *result = [self primitiveRevisionNumber];
	return [result longLongValue];
}

- (void)setPrimitiveRevisionNumberValue:(int64_t)value_ {
	[self setPrimitiveRevisionNumber:@(value_)];
}

@dynamic shortURL;

@dynamic slug;

@dynamic uid;

@dynamic file;

@end

