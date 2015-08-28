//
//  ACUser.m
//  ACSocial
//
//  Created by Alexandre Santos on 26/08/15.
//  Copyright (c) 2015 Avenue Code. All rights reserved.
//

#import "ACUser.h"

static ACUser *_currentUser = nil;

@implementation ACUser

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if(self) {
        self.identifier = dictionary[@"_id"];
        self.name = dictionary[@"name"];
        self.email = dictionary[@"email"];
        
        self.pictureURL = [NSURL URLWithString:dictionary[@"picture_url"]];
        
        NSArray *friendsDicts = dictionary[@"friends"];
        NSMutableArray *friends = [NSMutableArray arrayWithCapacity:[friendsDicts count]];
        for (NSDictionary *friendDict in friendsDicts) {
            ACUser *friendUser = [[ACUser alloc] initWithDictionary:friendDict];
            [friends addObject:friendUser];
        }
        self.friends = friends.count > 0 ? [friends copy] : nil;
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

@end
