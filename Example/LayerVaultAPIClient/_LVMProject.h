// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to LVMProject.h instead.

#import <CoreData/CoreData.h>
#import "LVMFolder.h"

extern const struct LVMProjectRelationships {
	__unsafe_unretained NSString *organization;
	__unsafe_unretained NSString *user;
} LVMProjectRelationships;

@class LVMOrganization;
@class LVMUser;

@interface LVMProjectID : LVMFolderID {}
@end

@interface _LVMProject : LVMFolder {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) LVMProjectID* objectID;

@property (nonatomic, strong) LVMOrganization *organization;

//- (BOOL)validateOrganization:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) LVMUser *user;

//- (BOOL)validateUser:(id*)value_ error:(NSError**)error_;

@end

@interface _LVMProject (CoreDataGeneratedPrimitiveAccessors)

- (LVMOrganization*)primitiveOrganization;
- (void)setPrimitiveOrganization:(LVMOrganization*)value;

- (LVMUser*)primitiveUser;
- (void)setPrimitiveUser:(LVMUser*)value;

@end
