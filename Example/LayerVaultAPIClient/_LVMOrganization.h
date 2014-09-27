// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to LVMOrganization.h instead.

#import <CoreData/CoreData.h>

extern const struct LVMOrganizationAttributes {
	__unsafe_unretained NSString *dateCancelled;
	__unsafe_unretained NSString *dateCreated;
	__unsafe_unretained NSString *dateDeleted;
	__unsafe_unretained NSString *dateUpdated;
	__unsafe_unretained NSString *isFree;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *slug;
	__unsafe_unretained NSString *syncType;
	__unsafe_unretained NSString *uid;
	__unsafe_unretained NSString *url;
} LVMOrganizationAttributes;

extern const struct LVMOrganizationRelationships {
	__unsafe_unretained NSString *projects;
	__unsafe_unretained NSString *user;
} LVMOrganizationRelationships;

@class LVMProject;
@class LVMUser;

@interface LVMOrganizationID : NSManagedObjectID {}
@end

@interface _LVMOrganization : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) LVMOrganizationID* objectID;

@property (nonatomic, strong) NSDate* dateCancelled;

//- (BOOL)validateDateCancelled:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate* dateCreated;

//- (BOOL)validateDateCreated:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate* dateDeleted;

//- (BOOL)validateDateDeleted:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate* dateUpdated;

//- (BOOL)validateDateUpdated:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* isFree;

@property (atomic) BOOL isFreeValue;
- (BOOL)isFreeValue;
- (void)setIsFreeValue:(BOOL)value_;

//- (BOOL)validateIsFree:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* slug;

//- (BOOL)validateSlug:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* syncType;

@property (atomic) int16_t syncTypeValue;
- (int16_t)syncTypeValue;
- (void)setSyncTypeValue:(int16_t)value_;

//- (BOOL)validateSyncType:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* uid;

//- (BOOL)validateUid:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* url;

//- (BOOL)validateUrl:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *projects;

- (NSMutableSet*)projectsSet;

@property (nonatomic, strong) LVMUser *user;

//- (BOOL)validateUser:(id*)value_ error:(NSError**)error_;

@end

@interface _LVMOrganization (ProjectsCoreDataGeneratedAccessors)
- (void)addProjects:(NSSet*)value_;
- (void)removeProjects:(NSSet*)value_;
- (void)addProjectsObject:(LVMProject*)value_;
- (void)removeProjectsObject:(LVMProject*)value_;

@end

@interface _LVMOrganization (CoreDataGeneratedPrimitiveAccessors)

- (NSDate*)primitiveDateCancelled;
- (void)setPrimitiveDateCancelled:(NSDate*)value;

- (NSDate*)primitiveDateCreated;
- (void)setPrimitiveDateCreated:(NSDate*)value;

- (NSDate*)primitiveDateDeleted;
- (void)setPrimitiveDateDeleted:(NSDate*)value;

- (NSDate*)primitiveDateUpdated;
- (void)setPrimitiveDateUpdated:(NSDate*)value;

- (NSNumber*)primitiveIsFree;
- (void)setPrimitiveIsFree:(NSNumber*)value;

- (BOOL)primitiveIsFreeValue;
- (void)setPrimitiveIsFreeValue:(BOOL)value_;

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;

- (NSString*)primitiveSlug;
- (void)setPrimitiveSlug:(NSString*)value;

- (NSNumber*)primitiveSyncType;
- (void)setPrimitiveSyncType:(NSNumber*)value;

- (int16_t)primitiveSyncTypeValue;
- (void)setPrimitiveSyncTypeValue:(int16_t)value_;

- (NSString*)primitiveUid;
- (void)setPrimitiveUid:(NSString*)value;

- (NSString*)primitiveUrl;
- (void)setPrimitiveUrl:(NSString*)value;

- (NSMutableSet*)primitiveProjects;
- (void)setPrimitiveProjects:(NSMutableSet*)value;

- (LVMUser*)primitiveUser;
- (void)setPrimitiveUser:(LVMUser*)value;

@end
