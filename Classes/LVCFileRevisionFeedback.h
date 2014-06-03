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

/**
 *  Feedback ID
 */
@property (readonly, nonatomic) NSNumber *feedbackID;

/**
 *  Preview ID
 */
@property (readonly, nonatomic) NSNumber *previewID;

/**
 *  Signpost ID
 */
@property (readonly, nonatomic) NSNumber *signpostID;

/**
 *  User ID
 */
@property (readonly, nonatomic) NSNumber *userID;

/**
 *  Comment box bounding top
 */
@property (readonly, nonatomic) NSNumber *top;

/**
 *  Comment box bounding right
 */
@property (readonly, nonatomic) NSNumber *right;

/**
 *  Comment box bounding left
 */
@property (readonly, nonatomic) NSNumber *left;

/**
 *  Comment box bounding bottom
 */
@property (readonly, nonatomic) NSNumber *bottom;

/**
 *  Comment message
 */
@property (readonly, nonatomic) NSString *message;

/**
 *  Associated Signpost
 */
@property (readonly, nonatomic) NSNumber *associatedSignpostID;

/**
 *  Date feedback was created
 */
@property (readonly, nonatomic) NSDate *dateCreated;

/**
 *  @note origin top left.
 */
@property (readonly, nonatomic) CGRect feedbackFrame;

@end
