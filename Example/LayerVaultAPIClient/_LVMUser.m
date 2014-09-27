// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to LVMUser.m instead.

#import "_LVMUser.h"

const struct LVMUserAttributes LVMUserAttributes = {
	.email = @"email",
	.firstName = @"firstName",
	.hasConfiguredAccount = @"hasConfiguredAccount",
	.hasSeenTour = @"hasSeenTour",
	.lastName = @"lastName",
	.uid = @"uid",
};

const struct LVMUserRelationships LVMUserRelationships = {
	.organizations = @"organizations",
	.projects = @"projects",
};

@implementation LVMUserID
@end

@implementation _LVMUser

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"LVMUser" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"LVMUser";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"LVMUser" inManagedObjectContext:moc_];
}

- (LVMUserID*)objectID {
	return (LVMUserID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"hasConfiguredAccountValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"hasConfiguredAccount"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"hasSeenTourValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"hasSeenTour"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic email;

@dynamic firstName;

@dynamic hasConfiguredAccount;

- (BOOL)hasConfiguredAccountValue {
	NSNumber *result = [self hasConfiguredAccount];
	return [result boolValue];
}

- (void)setHasConfiguredAccountValue:(BOOL)value_ {
	[self setHasConfiguredAccount:@(value_)];
}

- (BOOL)primitiveHasConfiguredAccountValue {
	NSNumber *result = [self primitiveHasConfiguredAccount];
	return [result boolValue];
}

- (void)setPrimitiveHasConfiguredAccountValue:(BOOL)value_ {
	[self setPrimitiveHasConfiguredAccount:@(value_)];
}

@dynamic hasSeenTour;

- (BOOL)hasSeenTourValue {
	NSNumber *result = [self hasSeenTour];
	return [result boolValue];
}

- (void)setHasSeenTourValue:(BOOL)value_ {
	[self setHasSeenTour:@(value_)];
}

- (BOOL)primitiveHasSeenTourValue {
	NSNumber *result = [self primitiveHasSeenTour];
	return [result boolValue];
}

- (void)setPrimitiveHasSeenTourValue:(BOOL)value_ {
	[self setPrimitiveHasSeenTour:@(value_)];
}

@dynamic lastName;

@dynamic uid;

@dynamic organizations;

- (NSMutableSet*)organizationsSet {
	[self willAccessValueForKey:@"organizations"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"organizations"];

	[self didAccessValueForKey:@"organizations"];
	return result;
}

@dynamic projects;

- (NSMutableSet*)projectsSet {
	[self willAccessValueForKey:@"projects"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"projects"];

	[self didAccessValueForKey:@"projects"];
	return result;
}

@end

