//
//  VCLogin.h
//  ACSocial
//
//  Created by Alexandre Santos on 26/08/15.
//  Copyright (c) 2015 Avenue Code. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VCLogin;
@class ACUser;

@protocol VCLoginDelegate <NSObject>

- (void)vcLogin:(VCLogin *)vcLogin didLoginUser:(ACUser *)user;

@end

@interface VCLogin : UIViewController

@property (nonatomic, weak) id<VCLoginDelegate> delegate;

+ (instancetype)instanceFromNib;

@end

