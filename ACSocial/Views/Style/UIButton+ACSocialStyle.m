//
//  UIButton+ACSocialStyle.m
//  ACSocial
//
//  Created by Alexandre Santos on 29/08/15.
//  Copyright (c) 2015 Avenue Code. All rights reserved.
//

#import "UIButton+ACSocialStyle.h"

@implementation UIButton (ACSocialStyle)

- (void)applyPrimaryStyle {
    self.layer.cornerRadius = 4;
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = 1;
    UIColor *titleColor = [UIColor colorWithRed:0.043 green:0.376 blue:0.996 alpha:1.000];
    self.layer.borderColor = titleColor.CGColor;
    [self setTitleColor:titleColor forState:UIControlStateNormal];
    [self setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
    [self setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
}

@end
