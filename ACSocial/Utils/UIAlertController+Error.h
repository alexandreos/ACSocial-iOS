//
//  UIAlertController+Error.h
//  ACSocial
//
//  Created by Alexandre Santos on 29/08/15.
//  Copyright (c) 2015 Avenue Code. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (Error)

/**
 Create a new instance of an alert controller with the given error object.
 
 @param error The error object to be used.
 
 @return A new instance of the alert controller with the error localized description as a message.
 */
+ (instancetype)alertControllerWithError:(NSError *)error;

@end
