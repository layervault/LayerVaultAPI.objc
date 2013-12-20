//
//  LVCLoginViewController.m
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 12/20/13.
//  Copyright (c) 2013 LayerVault. All rights reserved.
//

#import "LVCLoginViewController.h"

@interface LVCLoginViewController ()
@property (weak) IBOutlet NSSecureTextField *passwordField;
@end

@implementation LVCLoginViewController

- (IBAction)loginPressed:(id)sender {
    if (self.loginHander) {
        self.loginHander(self.usernameField.stringValue,
                         self.passwordField.stringValue);
    }
}
@end
