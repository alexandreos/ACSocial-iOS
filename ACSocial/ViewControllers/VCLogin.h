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

/**
 Notify the delegate of the login event.
 
 @param vcLogin The login view controller.
 @param user    The signed-in user.
 */
- (void)vcLogin:(VCLogin *)vcLogin didLoginUser:(ACUser *)user;

@end

@interface VCLogin : UIViewController

@property (nonatomic, weak) id<VCLoginDelegate> delegate;

/**
 Create a new instance of the view controller from the VCLogin.xib file.
 
 @return The created instance.
 */
+ (instancetype)instanceFromNib;

@end

