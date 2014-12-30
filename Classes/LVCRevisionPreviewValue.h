//
//  LVCFileRevisionPreview.h
//  Pods
//
//  Created by Matt Thomas on 12/30/14.
//
//

#import "MTLModel.h"
#import "LVCModelCollection.h"

@interface LVCRevisionPreviewCollection : MTLModel <LVCModelCollection, MTLJSONSerializing>
@property (nonatomic, readonly, copy) NSArray *previews;
@end

typedef enum : NSUInteger {
    LVCRevisionPreviewStateFailed,
    LVCRevisionPreviewStateBlank,
    LVCRevisionPreviewStatePending,
    LVCRevisionPreviewStateDeleted,
    LVCRevisionPreviewStateDisplayableCode,
    LVCRevisionPreviewStateRenderable
} LVCRevisionPreviewState;

@interface LVCRevisionPreviewValue : MTLModel <LVCResourceUniquing, MTLJSONSerializing>
@property (readonly, nonatomic, copy) NSString *uid;
@property (readonly, nonatomic, copy) NSURL *href;
@property (readonly, nonatomic, copy) NSDate *dateCreated;
@property (readonly, nonatomic, copy) NSDate *dateUpdated;
@property (readonly, nonatomic) LVCRevisionPreviewState state;

/// @note External Resource IDs
@property (readonly, nonatomic, copy) NSString *revisionID;
@end
