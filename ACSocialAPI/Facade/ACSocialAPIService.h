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

+ (AFHTTPRequestOperation *)getCurrentUserWithCompletion:(void (^)(ACUser *user, NSError *error))completion;

+ (AFHTTPRequestOperation *)getAllUsersWithCompletion:(void (^)(NSArray *allUsers, NSError *error))completion;

+ (AFHTTPRequestOperation *)getAllUsersWithStatusAndCompletion:(void (^)(NSArray *allUsers, NSError *error))completion;

+ (AFHTTPRequestOperation *)getAllFriendsWithCompletion:(void (^)(NSArray *friends, NSError *error))completion;

+ (AFHTTPRequestOperation *)inviteFriend:(ACUser *)friendUser completion:(void (^)(BOOL success, NSError *error))completion;

+ (AFHTTPRequestOperation *)acceptFriend:(ACUser *)friendUser completion:(void (^)(BOOL success, NSError *error))completion;

+ (AFHTTPRequestOperation *)friendInvitedWithCompletion:(void (^)(NSArray *friendInvitesSent, NSError *error))completion;
+ (AFHTTPRequestOperation *)friedRequestsReceivedWithCompletion:(void (^)(NSArray *friendRequestsReceived, NSError *error))completion;

@end
