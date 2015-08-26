//
//  VCLogin.h
//  ACSocial
//
//  Created by Alexandre Santos on 26/08/15.
//  Copyright (c) 2015 Avenue Code. All rights reserved.
//

#import "VCLogin.h"
#import "ACUser.h"

@interface VCLogin ()

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation VCLogin

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI Actions

- (IBAction)loginButtonTapped:(id)sender {
    // Just create a fake user for now
    ACUser *user = [[ACUser alloc] init];
    user.name = @"Alexandre Santos";
    user.email = @"asantos@avenuecode.com";
    user.pictureURL = [NSURL URLWithString:@"https://www.gravatar.com/avatar/d97d62f942fce0f98e44ae91dacd703c?s=64&d=identicon&r=PG"];
    
    [ACUser setCurrentUser:user];
}

@end
