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
@end
