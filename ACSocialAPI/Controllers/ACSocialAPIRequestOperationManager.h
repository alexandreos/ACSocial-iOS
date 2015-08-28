//
//  ACSocialAPIRequestOperationManager.h
//  ACSocial
//
//  Created by Alexandre Santos on 28/08/15.
//  Copyright (c) 2015 Avenue Code. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"

@interface ACSocialAPIRequestOperationManager : AFHTTPRequestOperationManager

/**
 @return The singleton instance of the manager used by the API.
 */
+ (instancetype)sharedManager;

@end
