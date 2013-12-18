//
//  LVCFileRevisionFeedback.h
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 12/16/13.
//  Copyright (c) 2013 LayerVault. All rights reserved.
//

#import <Mantle/Mantle.h>

/**
 *  A specific revision of a file on LayerVault
 */
@interface LVCFileRevisionFeedback : MTLModel <MTLJSONSerializing>

@property (readonly, nonatomic) NSNumber *feedbackID;
@property (readonly, nonatomic) NSNumber *previewID;
@property (readonly, nonatomic) NSNumber *signpostID;
@property (readonly, nonatomic) NSNumber *userID;
@property (readonly, nonatomic) NSNumber *top;
@property (readonly, nonatomic) NSNumber *right;
@property (readonly, nonatomic) NSNumber *left;
@property (readonly, nonatomic) NSNumber *bottom;
@property (readonly, nonatomic) NSString *message;
@property (readonly, nonatomic) NSNumber *associatedSignpostID;
@property (readonly, nonatomic) NSDate *dateCreated;

/**
 *  @note origin top left.
 */
@property (readonly, nonatomic) CGRect feedbackFrame;

@end
