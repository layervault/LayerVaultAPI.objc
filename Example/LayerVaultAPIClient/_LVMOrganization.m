// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to LVMOrganization.m instead.

#import "_LVMOrganization.h"

const struct LVMOrganizationAttributes LVMOrganizationAttributes = {
	.dateCancelled = @"dateCancelled",
	.dateCreated = @"dateCreated",
	.dateDeleted = @"dateDeleted",
	.dateUpdated = @"dateUpdated",
	.isFree = @"isFree",
	.name = @"name",
	.slug = @"slug",
	.syncType = @"syncType",
	.uid = @"uid",
	.url = @"url",
};

const struct LVMOrganizationRelationships LVMOrganizationRelationships = {
	.projects = @"projects",
	.user = @"user",
};

@implementation LVMOrganizationID
@end

@implementation _LVMOrganization

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"LVMOrganization" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"LVMOrganization";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"LVMOrganization" inManagedObjectContext:moc_];
}

- (LVMOrganizationID*)objectID {
	return (LVMOrganizationID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"isFreeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"isFree"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"syncTypeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"syncType"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic dateCancelled;

@dynamic dateCreated;

@dynamic dateDeleted;

@dynamic dateUpdated;

@dynamic isFree;

- (BOOL)isFreeValue {
	NSNumber *result = [self isFree];
	return [result boolValue];
}

- (void)setIsFreeValue:(BOOL)value_ {
	[self setIsFree:@(value_)];
}

- (BOOL)primitiveIsFreeValue {
	NSNumber *result = [self primitiveIsFree];
	return [result boolValue];
}

- (void)setPrimitiveIsFreeValue:(BOOL)value_ {
	[self setPrimitiveIsFree:@(value_)];
}

@dynamic name;

@dynamic slug;

@dynamic syncType;

- (int16_t)syncTypeValue {
	NSNumber *result = [self syncType];
	return [result shortValue];
}

- (void)setSyncTypeValue:(int16_t)value_ {
	[self setSyncType:@(value_)];
}

- (int16_t)primitiveSyncTypeValue {
	NSNumber *result = [self primitiveSyncType];
	return [result shortValue];
}

- (void)setPrimitiveSyncTypeValue:(int16_t)value_ {
	[self setPrimitiveSyncType:@(value_)];
}

@dynamic uid;

@dynamic url;

@dynamic projects;

- (NSMutableSet*)projectsSet {
	[self willAccessValueForKey:@"projects"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"projects"];

	[self didAccessValueForKey:@"projects"];
	return result;
}

@dynamic user;

@end

