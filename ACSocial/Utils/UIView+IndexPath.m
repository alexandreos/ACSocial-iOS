//
//  UIView+IndexPath.m
//  ACSocial
//
//  Created by Alexandre Santos on 26/08/15.
//  Copyright (c) 2015 Avenue Code. All rights reserved.
//

#import "UIView+IndexPath.h"
#import <objc/runtime.h>

@implementation UIView (IndexPath)

- (void)setIndexPath:(NSIndexPath *)indexPath
{
    objc_setAssociatedObject(self, @selector(indexPath), indexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSIndexPath *)indexPath
{
    return objc_getAssociatedObject(self, @selector(indexPath));
}

@end
