//
//  UIAlertController+Error.h
//  ACSocial
//
//  Created by Alexandre Santos on 29/08/15.
//  Copyright (c) 2015 Avenue Code. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (Error)

+ (instancetype)alertControllerWithError:(NSError *)error;

@end
