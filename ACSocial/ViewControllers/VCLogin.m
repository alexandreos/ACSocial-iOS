//
//  VCLogin.h
//  ACSocial
//
//  Created by Alexandre Santos on 26/08/15.
//  Copyright (c) 2015 Avenue Code. All rights reserved.
//

#import "VCLogin.h"
#import "ACUser.h"

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
    // TODO: Login using rest API
    // Just create a fake user for now
    ACUser *user = [[ACUser alloc] init];
    user.name = @"Alexandre Santos";
    user.email = @"asantos@avenuecode.com";
    user.pictureURL = [NSURL URLWithString:@"https://www.gravatar.com/avatar/d97d62f942fce0f98e44ae91dacd703c?s=64&d=identicon&r=PG"];

    // Add 1 friend
    ACUser *friend = [[ACUser alloc] init];
    friend.name = @"Amir Razmara";
    friend.email = @"amir@avenuecode.com";
    friend.pictureURL = [NSURL URLWithString:@"https://ssl.gstatic.com/s2/profiles/images/silhouette48.png"];
    
    user.friends = @[friend];
    
    [ACUser setCurrentUser:user];
    
    if([self.delegate respondsToSelector:@selector(vcLogin:didLoginUser:)]) {
        [self.delegate vcLogin:self didLoginUser:user];
    }
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
