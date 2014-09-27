// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to LVMUser.h instead.

#import <CoreData/CoreData.h>

extern const struct LVMUserAttributes {
	__unsafe_unretained NSString *email;
	__unsafe_unretained NSString *firstName;
	__unsafe_unretained NSString *hasConfiguredAccount;
	__unsafe_unretained NSString *hasSeenTour;
	__unsafe_unretained NSString *lastName;
	__unsafe_unretained NSString *uid;
} LVMUserAttributes;

extern const struct LVMUserRelationships {
	__unsafe_unretained NSString *organizations;
	__unsafe_unretained NSString *projects;
} LVMUserRelationships;

@class LVMOrganization;
@class LVMProject;

@interface LVMUserID : NSManagedObjectID {}
@end

@interface _LVMUser : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) LVMUserID* objectID;

@property (nonatomic, strong) NSString* email;

//- (BOOL)validateEmail:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* firstName;

//- (BOOL)validateFirstName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* hasConfiguredAccount;

@property (atomic) BOOL hasConfiguredAccountValue;
- (BOOL)hasConfiguredAccountValue;
- (void)setHasConfiguredAccountValue:(BOOL)value_;

//- (BOOL)validateHasConfiguredAccount:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* hasSeenTour;

@property (atomic) BOOL hasSeenTourValue;
- (BOOL)hasSeenTourValue;
- (void)setHasSeenTourValue:(BOOL)value_;

//- (BOOL)validateHasSeenTour:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* lastName;

//- (BOOL)validateLastName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* uid;

//- (BOOL)validateUid:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *organizations;

- (NSMutableSet*)organizationsSet;

@property (nonatomic, strong) NSSet *projects;

- (NSMutableSet*)projectsSet;

@end

@interface _LVMUser (OrganizationsCoreDataGeneratedAccessors)
- (void)addOrganizations:(NSSet*)value_;
- (void)removeOrganizations:(NSSet*)value_;
- (void)addOrganizationsObject:(LVMOrganization*)value_;
- (void)removeOrganizationsObject:(LVMOrganization*)value_;

@end

@interface _LVMUser (ProjectsCoreDataGeneratedAccessors)
- (void)addProjects:(NSSet*)value_;
- (void)removeProjects:(NSSet*)value_;
- (void)addProjectsObject:(LVMProject*)value_;
- (void)removeProjectsObject:(LVMProject*)value_;

@end

@interface _LVMUser (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveEmail;
- (void)setPrimitiveEmail:(NSString*)value;

- (NSString*)primitiveFirstName;
- (void)setPrimitiveFirstName:(NSString*)value;

- (NSNumber*)primitiveHasConfiguredAccount;
- (void)setPrimitiveHasConfiguredAccount:(NSNumber*)value;

- (BOOL)primitiveHasConfiguredAccountValue;
- (void)setPrimitiveHasConfiguredAccountValue:(BOOL)value_;

- (NSNumber*)primitiveHasSeenTour;
- (void)setPrimitiveHasSeenTour:(NSNumber*)value;

- (BOOL)primitiveHasSeenTourValue;
- (void)setPrimitiveHasSeenTourValue:(BOOL)value_;

- (NSString*)primitiveLastName;
- (void)setPrimitiveLastName:(NSString*)value;

- (NSString*)primitiveUid;
- (void)setPrimitiveUid:(NSString*)value;

- (NSMutableSet*)primitiveOrganizations;
- (void)setPrimitiveOrganizations:(NSMutableSet*)value;

- (NSMutableSet*)primitiveProjects;
- (void)setPrimitiveProjects:(NSMutableSet*)value;

@end
