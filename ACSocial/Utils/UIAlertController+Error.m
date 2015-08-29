//
//  UIAlertController+Error.m
//  ACSocial
//
//  Created by Alexandre Santos on 29/08/15.
//  Copyright (c) 2015 Avenue Code. All rights reserved.
//

#import "UIAlertController+Error.h"

@implementation UIAlertController (Error)

+ (instancetype)alertControllerWithError:(NSError *)error {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Oops" message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
    return alert;
}

@end
