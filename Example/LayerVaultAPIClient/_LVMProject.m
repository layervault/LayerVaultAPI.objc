// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to LVMProject.m instead.

#import "_LVMProject.h"

const struct LVMProjectRelationships LVMProjectRelationships = {
	.organization = @"organization",
	.user = @"user",
};

@implementation LVMProjectID
@end

@implementation _LVMProject

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"LVMProject" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"LVMProject";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"LVMProject" inManagedObjectContext:moc_];
}

- (LVMProjectID*)objectID {
	return (LVMProjectID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic organization;

@dynamic user;

@end

