//
//  LVCUserCollection.h
//  Pods
//
//  Created by Matt Thomas on 9/18/14.
//
//

#import <Mantle/Mantle.h>

@protocol LVCModelCollection <NSObject>
+ (NSString *)collectionKey;
+ (Class)modelClass;
- (NSArray *)allModels;
@end

@protocol LVCResourceUniquing <NSObject>
@property (nonatomic, readonly, copy) NSString *uid;
@end
