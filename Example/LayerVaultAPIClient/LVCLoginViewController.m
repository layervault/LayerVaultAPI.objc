//
//  LVCLoginViewController.m
//  LayerVaultAPIClient
//
//  Created by Matt Thomas on 12/20/13.
//  Copyright (c) 2013 LayerVault. All rights reserved.
//

#import "LVCLoginViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <PromiseKit/PromiseKit.h>
#import <Mantle/EXTScope.h>


@interface LVCLoginViewController ()
@property (weak) IBOutlet NSButton *loginButton;
@property (weak) IBOutlet NSSecureTextField *passwordField;
@property (weak) IBOutlet NSTextField *tokenField;
@property (weak) IBOutlet NSTabView *tabView;
@property (weak) IBOutlet NSTabViewItem *emailTab;
@property (weak) IBOutlet NSTabViewItem *tokenTab;
@end

@implementation LVCLoginViewController

- (void)loadView {
    [super loadView];

    NSArray *loginFields = @[self.emailField.rac_textSignal,
                             self.passwordField.rac_textSignal,
                             self.tokenField.rac_textSignal];

    __weak typeof(self) weakSelf = self;
    RACSignal *loginEnabled = [RACSignal combineLatest:loginFields reduce:^(NSString *email,
                                                                            NSString *password,
                                                                            NSString *token) {
        if (weakSelf.tabView.selectedTabViewItem == self.emailTab) {
            return @(email.length > 0 && password.length > 0);
        } else if (weakSelf.tabView.selectedTabViewItem == self.tokenTab) {
            return @(token.length > 0);
        }
        return @NO;
     }];
    [self.loginButton rac_liftSelector:@selector(setEnabled:) withSignals:loginEnabled, nil];
}


- (IBAction)loginPressed:(id)sender {
    if (self.loginHander) {
        self.loginHander(self.emailField.stringValue,
                         self.passwordField.stringValue,
                         self.tokenField.stringValue);
    }
}
@end
