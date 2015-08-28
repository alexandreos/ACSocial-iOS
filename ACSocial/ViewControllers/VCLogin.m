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

@interface VCLogin () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation VCLogin

+ (instancetype)instanceFromNib {
    return [[VCLogin alloc] initWithNibName:NSStringFromClass([VCLogin class]) bundle:[NSBundle mainBundle]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark - UI Actions

- (IBAction)loginButtonTapped:(id)sender {
    
    [SVProgressHUD show];
    [ACSocialAPIService loginWithUsername:self.emailTextField.text password:self.passwordTextField.text completion:^(BOOL success, NSError *error) {
        if(success) {
            // Load current user
            [ACSocialAPIService getCurrentUserWithcompletion:^(ACUser *user, NSError *error) {
                [SVProgressHUD dismiss];
                if(user) {
                    // Success
                    if([self.delegate respondsToSelector:@selector(vcLogin:didLoginUser:)]) {
                        [self.delegate vcLogin:self didLoginUser:user];
                    }
                }
                else {
                    [self showAlertWithError:error];
                }
            }];
        }
        else {
            [SVProgressHUD dismiss];
            [self showAlertWithError:error];
        }

    }];
}

#pragma mark - Private Method

- (void)showAlertWithError:(NSError *)error {
    // Some error happened, let's display an alert
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Oops" message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
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
