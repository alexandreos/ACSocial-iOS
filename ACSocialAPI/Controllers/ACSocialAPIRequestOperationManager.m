//
//  ACSocialAPIRequestOperationManager.m
//  ACSocial
//
//  Created by Alexandre Santos on 28/08/15.
//  Copyright (c) 2015 Avenue Code. All rights reserved.
//

#import "ACSocialAPIRequestOperationManager.h"

static NSString * const kBaseURL = @"http://ac-social-api.herokuapp.com";

@implementation ACSocialAPIRequestOperationManager

+ (instancetype)sharedManager {
    static ACSocialAPIRequestOperationManager *_sharedManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[ACSocialAPIRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseURL]];
    });
    
    return _sharedManager;
}

- (instancetype)initWithBaseURL:(nullable NSURL *)url {
    self = [super initWithBaseURL:url];
    if(self) {
        // Setup options
        self.requestSerializer = [[AFJSONRequestSerializer alloc] init];
        self.responseSerializer = [[AFJSONResponseSerializer alloc] init];
    }
    return self;
}

@end
