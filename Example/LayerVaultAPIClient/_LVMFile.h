// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to LVMFile.h instead.

#import <CoreData/CoreData.h>

extern const struct LVMFileAttributes {
	__unsafe_unretained NSString *canCommentOnFile;
	__unsafe_unretained NSString *canEditNode;
	__unsafe_unretained NSString *dateCreated;
	__unsafe_unretained NSString *dateDeleted;
	__unsafe_unretained NSString *dateModified;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *slug;
	__unsafe_unretained NSString *uid;
} LVMFileAttributes;

extern const struct LVMFileRelationships {
	__unsafe_unretained NSString *folder;
	__unsafe_unretained NSString *latestRevision;
} LVMFileRelationships;

@class LVMFolder;
@class LVMRevision;

@interface LVMFileID : NSManagedObjectID {}
@end

@interface _LVMFile : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) LVMFileID* objectID;

@property (nonatomic, strong) NSNumber* canCommentOnFile;

@property (atomic) BOOL canCommentOnFileValue;
- (BOOL)canCommentOnFileValue;
- (void)setCanCommentOnFileValue:(BOOL)value_;

//- (BOOL)validateCanCommentOnFile:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* canEditNode;

@property (atomic) BOOL canEditNodeValue;
- (BOOL)canEditNodeValue;
- (void)setCanEditNodeValue:(BOOL)value_;

//- (BOOL)validateCanEditNode:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate* dateCreated;

//- (BOOL)validateDateCreated:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate* dateDeleted;

//- (BOOL)validateDateDeleted:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate* dateModified;

//- (BOOL)validateDateModified:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* slug;

//- (BOOL)validateSlug:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* uid;

//- (BOOL)validateUid:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) LVMFolder *folder;

//- (BOOL)validateFolder:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) LVMRevision *latestRevision;

//- (BOOL)validateLatestRevision:(id*)value_ error:(NSError**)error_;

@end

@interface _LVMFile (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber*)primitiveCanCommentOnFile;
- (void)setPrimitiveCanCommentOnFile:(NSNumber*)value;

- (BOOL)primitiveCanCommentOnFileValue;
- (void)setPrimitiveCanCommentOnFileValue:(BOOL)value_;

- (NSNumber*)primitiveCanEditNode;
- (void)setPrimitiveCanEditNode:(NSNumber*)value;

- (BOOL)primitiveCanEditNodeValue;
- (void)setPrimitiveCanEditNodeValue:(BOOL)value_;

- (NSDate*)primitiveDateCreated;
- (void)setPrimitiveDateCreated:(NSDate*)value;

- (NSDate*)primitiveDateDeleted;
- (void)setPrimitiveDateDeleted:(NSDate*)value;

- (NSDate*)primitiveDateModified;
- (void)setPrimitiveDateModified:(NSDate*)value;

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;

- (NSString*)primitiveSlug;
- (void)setPrimitiveSlug:(NSString*)value;

- (NSString*)primitiveUid;
- (void)setPrimitiveUid:(NSString*)value;

- (LVMFolder*)primitiveFolder;
- (void)setPrimitiveFolder:(LVMFolder*)value;

- (LVMRevision*)primitiveLatestRevision;
- (void)setPrimitiveLatestRevision:(LVMRevision*)value;

@end
