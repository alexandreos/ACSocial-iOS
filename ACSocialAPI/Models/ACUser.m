//
//  ACUser.m
//  ACSocial
//
//  Created by Alexandre Santos on 26/08/15.
//  Copyright (c) 2015 Avenue Code. All rights reserved.
//

#import "ACUser.h"
#import <NSString+MD5.h>

static ACUser *_currentUser = nil;

@interface ACUser ()

@end

@implementation ACUser
@synthesize pictureURL = _pictureURL;


- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if(self) {
        self.identifier = dictionary[@"_id"];
        self.name = dictionary[@"name"];
        self.email = dictionary[@"email"];
    }
    
    return self;
}

+ (instancetype)currentUser {
    return _currentUser;
}

+ (void)setCurrentUser:(ACUser *)user {
    if(_currentUser != user) {
        _currentUser = user;
    }
}

#pragma mark - Properties

- (NSURL *)pictureURL {
    
    // Lazy load a picture URL
    if(_pictureURL == nil) {
        NSString *hashedUserID = [self.email MD5Digest];
        NSString *gravatarURLString = [NSString stringWithFormat:@"http://www.gravatar.com/avatar/%@.jpg?s=100", hashedUserID];
        NSURL *gravatarURL = [NSURL URLWithString:gravatarURLString];
        _pictureURL = gravatarURL;
    }
    return _pictureURL;
}

@end
