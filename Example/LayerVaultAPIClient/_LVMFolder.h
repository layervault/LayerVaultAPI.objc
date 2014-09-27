// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to LVMFolder.h instead.

#import <CoreData/CoreData.h>

extern const struct LVMFolderAttributes {
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *slug;
	__unsafe_unretained NSString *uid;
	__unsafe_unretained NSString *url;
} LVMFolderAttributes;

extern const struct LVMFolderRelationships {
	__unsafe_unretained NSString *files;
	__unsafe_unretained NSString *folders;
	__unsafe_unretained NSString *parentFolder;
} LVMFolderRelationships;

@class LVMFile;
@class LVMFolder;
@class LVMFolder;

@interface LVMFolderID : NSManagedObjectID {}
@end

@interface _LVMFolder : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) LVMFolderID* objectID;

@property (nonatomic, strong) NSString* name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* slug;

//- (BOOL)validateSlug:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* uid;

//- (BOOL)validateUid:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* url;

//- (BOOL)validateUrl:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *files;

- (NSMutableSet*)filesSet;

@property (nonatomic, strong) NSSet *folders;

- (NSMutableSet*)foldersSet;

@property (nonatomic, strong) LVMFolder *parentFolder;

//- (BOOL)validateParentFolder:(id*)value_ error:(NSError**)error_;

@end

@interface _LVMFolder (FilesCoreDataGeneratedAccessors)
- (void)addFiles:(NSSet*)value_;
- (void)removeFiles:(NSSet*)value_;
- (void)addFilesObject:(LVMFile*)value_;
- (void)removeFilesObject:(LVMFile*)value_;

@end

@interface _LVMFolder (FoldersCoreDataGeneratedAccessors)
- (void)addFolders:(NSSet*)value_;
- (void)removeFolders:(NSSet*)value_;
- (void)addFoldersObject:(LVMFolder*)value_;
- (void)removeFoldersObject:(LVMFolder*)value_;

@end

@interface _LVMFolder (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;

- (NSString*)primitiveSlug;
- (void)setPrimitiveSlug:(NSString*)value;

- (NSString*)primitiveUid;
- (void)setPrimitiveUid:(NSString*)value;

- (NSString*)primitiveUrl;
- (void)setPrimitiveUrl:(NSString*)value;

- (NSMutableSet*)primitiveFiles;
- (void)setPrimitiveFiles:(NSMutableSet*)value;

- (NSMutableSet*)primitiveFolders;
- (void)setPrimitiveFolders:(NSMutableSet*)value;

- (LVMFolder*)primitiveParentFolder;
- (void)setPrimitiveParentFolder:(LVMFolder*)value;

@end
