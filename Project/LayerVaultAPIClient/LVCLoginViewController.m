//
//  LVCLoginViewController.m
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 12/20/13.
//  Copyright (c) 2013 LayerVault. All rights reserved.
//

#import "LVCLoginViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

NSString *const LVCLoginViewControllerEmailRegEx =
@"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
@"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
@"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
@"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
@"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
@"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
@"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";


@interface LVCLoginViewController ()
@property (weak) IBOutlet NSButton *loginButton;
@property (weak) IBOutlet NSSecureTextField *passwordField;
@end

@implementation LVCLoginViewController

- (void)loadView {
    [super loadView];
    NSArray *loginFields = @[self.emailField.rac_textSignal,
                             self.passwordField.rac_textSignal];

    RACSignal *loginEnabled = [RACSignal combineLatest:loginFields reduce:^(NSString *email,
                                                                            NSString *password){
         BOOL validEmail = [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", LVCLoginViewControllerEmailRegEx] evaluateWithObject:email];
         return @(validEmail && password.length > 0);
     }];
    [self.loginButton rac_liftSelector:@selector(setEnabled:) withSignals:loginEnabled, nil];
}


- (IBAction)loginPressed:(id)sender {
    if (self.loginHander) {
        self.loginHander(self.emailField.stringValue,
                         self.passwordField.stringValue);
    }
}
@end
