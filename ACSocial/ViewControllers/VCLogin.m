//
//  VCLogin.h
//  ACSocial
//
//  Created by Alexandre Santos on 26/08/15.
//  Copyright (c) 2015 Avenue Code. All rights reserved.
//

#import "VCLogin.h"
#import "ACSocialAPI.h"
#import <SVProgressHUD.h>
#import "UIAlertController+Error.h"
#import "ACSocialStyle.h"

@interface VCLogin () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation VCLogin

+ (instancetype)instanceFromNib {
    return [[VCLogin alloc] initWithNibName:NSStringFromClass([VCLogin class]) bundle:[NSBundle mainBundle]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    self.title = @"ACSocial";
    
    [self.loginButton applyPrimaryStyle];
}

#pragma mark - UI Actions

- (IBAction)loginButtonTapped:(id)sender {
    // Dismiss keyboard
    [self.emailTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    
    // Present HUD
    [SVProgressHUD show];
    
    // Make login request
    [ACSocialAPIService loginWithUsername:self.emailTextField.text password:self.passwordTextField.text completion:^(BOOL success, NSError *error) {
        if(success) {
            // Load current user
            [ACSocialAPIService getCurrentUserWithCompletion:^(ACUser *user, NSError *error) {
                [SVProgressHUD dismiss];
                if(user) {
                    // Success
                    if([self.delegate respondsToSelector:@selector(vcLogin:didLoginUser:)]) {
                        [self.delegate vcLogin:self didLoginUser:user];
                    }
                }
                else {
                    [self presentViewController:[UIAlertController alertControllerWithError:error] animated:YES completion:nil];
                }
            }];
        }
        else {
            [SVProgressHUD dismiss];
            [self presentViewController:[UIAlertController alertControllerWithError:error] animated:YES completion:nil];
        }

    }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField == self.emailTextField) {
        [self.passwordTextField becomeFirstResponder];
    }
    else if(textField == self.passwordTextField) {
        // Simulate tap on the login button
        [self loginButtonTapped:nil];
    }
    
    return NO;
}

@end
