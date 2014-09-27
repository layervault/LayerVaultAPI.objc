// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to LVMRevision.h instead.

#import <CoreData/CoreData.h>

extern const struct LVMRevisionAttributes {
	__unsafe_unretained NSString *assembledFileDataFingerprint;
	__unsafe_unretained NSString *dateCreated;
	__unsafe_unretained NSString *dateDeleted;
	__unsafe_unretained NSString *dateUpdated;
	__unsafe_unretained NSString *downloadURL;
	__unsafe_unretained NSString *dropboxSyncRevision;
	__unsafe_unretained NSString *fileDataFingerprint;
	__unsafe_unretained NSString *md5;
	__unsafe_unretained NSString *parentMD5;
	__unsafe_unretained NSString *remoteURL;
	__unsafe_unretained NSString *revisionNumber;
	__unsafe_unretained NSString *shortURL;
	__unsafe_unretained NSString *slug;
	__unsafe_unretained NSString *uid;
} LVMRevisionAttributes;

extern const struct LVMRevisionRelationships {
	__unsafe_unretained NSString *file;
} LVMRevisionRelationships;

@class LVMFile;

@interface LVMRevisionID : NSManagedObjectID {}
@end

@interface _LVMRevision : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) LVMRevisionID* objectID;

@property (nonatomic, strong) NSString* assembledFileDataFingerprint;

//- (BOOL)validateAssembledFileDataFingerprint:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate* dateCreated;

//- (BOOL)validateDateCreated:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate* dateDeleted;

//- (BOOL)validateDateDeleted:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate* dateUpdated;

//- (BOOL)validateDateUpdated:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* downloadURL;

//- (BOOL)validateDownloadURL:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* dropboxSyncRevision;

@property (atomic) BOOL dropboxSyncRevisionValue;
- (BOOL)dropboxSyncRevisionValue;
- (void)setDropboxSyncRevisionValue:(BOOL)value_;

//- (BOOL)validateDropboxSyncRevision:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* fileDataFingerprint;

//- (BOOL)validateFileDataFingerprint:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* md5;

//- (BOOL)validateMd5:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* parentMD5;

//- (BOOL)validateParentMD5:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* remoteURL;

//- (BOOL)validateRemoteURL:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* revisionNumber;

@property (atomic) int64_t revisionNumberValue;
- (int64_t)revisionNumberValue;
- (void)setRevisionNumberValue:(int64_t)value_;

//- (BOOL)validateRevisionNumber:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* shortURL;

//- (BOOL)validateShortURL:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* slug;

//- (BOOL)validateSlug:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* uid;

//- (BOOL)validateUid:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) LVMFile *file;

//- (BOOL)validateFile:(id*)value_ error:(NSError**)error_;

@end

@interface _LVMRevision (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveAssembledFileDataFingerprint;
- (void)setPrimitiveAssembledFileDataFingerprint:(NSString*)value;

- (NSDate*)primitiveDateCreated;
- (void)setPrimitiveDateCreated:(NSDate*)value;

- (NSDate*)primitiveDateDeleted;
- (void)setPrimitiveDateDeleted:(NSDate*)value;

- (NSDate*)primitiveDateUpdated;
- (void)setPrimitiveDateUpdated:(NSDate*)value;

- (NSString*)primitiveDownloadURL;
- (void)setPrimitiveDownloadURL:(NSString*)value;

- (NSNumber*)primitiveDropboxSyncRevision;
- (void)setPrimitiveDropboxSyncRevision:(NSNumber*)value;

- (BOOL)primitiveDropboxSyncRevisionValue;
- (void)setPrimitiveDropboxSyncRevisionValue:(BOOL)value_;

- (NSString*)primitiveFileDataFingerprint;
- (void)setPrimitiveFileDataFingerprint:(NSString*)value;

- (NSString*)primitiveMd5;
- (void)setPrimitiveMd5:(NSString*)value;

- (NSString*)primitiveParentMD5;
- (void)setPrimitiveParentMD5:(NSString*)value;

- (NSString*)primitiveRemoteURL;
- (void)setPrimitiveRemoteURL:(NSString*)value;

- (NSNumber*)primitiveRevisionNumber;
- (void)setPrimitiveRevisionNumber:(NSNumber*)value;

- (int64_t)primitiveRevisionNumberValue;
- (void)setPrimitiveRevisionNumberValue:(int64_t)value_;

- (NSString*)primitiveShortURL;
- (void)setPrimitiveShortURL:(NSString*)value;

- (NSString*)primitiveSlug;
- (void)setPrimitiveSlug:(NSString*)value;

- (NSString*)primitiveUid;
- (void)setPrimitiveUid:(NSString*)value;

- (LVMFile*)primitiveFile;
- (void)setPrimitiveFile:(LVMFile*)value;

@end
