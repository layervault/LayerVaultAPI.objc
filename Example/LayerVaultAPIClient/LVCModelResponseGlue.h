//
//  LVCModelResponseGlue.h
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 9/21/14.
//  Copyright (c) 2014 LayerVault. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LVMRevision;
@class LVCRevisionValue;

@interface LVCModelResponseGlue : NSObject

+ (LVMRevision *)revisionFromRevisionResponse:(LVCRevisionValue *)revision
                       inManagedObjectContext:(NSManagedObjectContext *)context;

@end
