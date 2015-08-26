//
//  ACUser.h
//  ACSocial
//
//  Created by Alexandre Santos on 26/08/15.
//  Copyright (c) 2015 Avenue Code. All rights reserved.
//

#import "ACDictionaryDeserializable.h"

@interface ACUser : NSObject <ACDictionaryDeserializable>

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *email;
@property (nonatomic) NSURL *pictureURL;

@property (nonatomic) NSArray *friends;

/**
 The current user signed-in in the app.
 
 @return The current user instance or nil if none is signed-in.
 */
+ (instancetype)currentUser;

/**
 Set the current user instance.
 
 @param user The user instance to be set as the signed-in user in the app.
 */
+ (void)setCurrentUser:(ACUser *)user;

@end
