//
//  ACSocialAPIService.h
//  ACSocial
//
//  Created by Alexandre Santos on 28/08/15.
//  Copyright (c) 2015 Avenue Code. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import "ACUser.h"

@interface ACSocialAPIService : NSObject

+ (AFHTTPRequestOperation *)loginWithUsername:(NSString *)username password:(NSString *)password completion:(void (^)(BOOL success, NSError *error))completion;

+ (AFHTTPRequestOperation *)getCurrentUserWithcompletion:(void (^)(ACUser *user, NSError *error))completion;

+ (AFHTTPRequestOperation *)getAllUsersWithcompletion:(void (^)(NSArray *allUsers, NSError *error))completion;

+ (AFHTTPRequestOperation *)getAllFriendsWithcompletion:(void (^)(NSArray *friends, NSError *error))completion;

+ (AFHTTPRequestOperation *)inviteFriend:(ACUser *)friendUser completion:(void (^)(NSArray *friends, NSError *error))completion;

@end
