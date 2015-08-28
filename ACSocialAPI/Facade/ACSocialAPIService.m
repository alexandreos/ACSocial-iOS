//
//  ACSocialAPIService.m
//  ACSocial
//
//  Created by Alexandre Santos on 28/08/15.
//  Copyright (c) 2015 Avenue Code. All rights reserved.
//

#import "ACSocialAPIService.h"
#import "ACSocialAPIRequestOperationManager.h"

@implementation ACSocialAPIService

+ (AFHTTPRequestOperation *)loginWithUsername:(NSString *)username password:(NSString *)password completion:(void (^)(BOOL, NSError *))completion {
    ACSocialAPIRequestOperationManager *manager = [ACSocialAPIRequestOperationManager sharedManager];
    AFHTTPResponseSerializer *originalResponseSerializer = manager.responseSerializer;
    // Create a generic response serializer since the response is not JSON
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    AFHTTPRequestOperation *requestOperation = [manager POST:@"/login" parameters:@{@"username":username, @"password":password} success:^void(AFHTTPRequestOperation *operation, id data) {
        
        [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", [operation.responseString stringByReplacingOccurrencesOfString:@"\"" withString:@""]] forHTTPHeaderField:@"Authorization"];
        
        if(completion) {
            completion(YES, nil);
        }
    } failure:^void(AFHTTPRequestOperation * operation, NSError *error) {
        if(completion) {
            completion(NO, error);
        }
    }];
    
    manager.responseSerializer = originalResponseSerializer;
    
    return requestOperation;
}

+ (AFHTTPRequestOperation *)getCurrentUserWithCompletion:(void (^)(ACUser *, NSError *))completion {
    ACSocialAPIRequestOperationManager *manager = [ACSocialAPIRequestOperationManager sharedManager];
    return [manager GET:@"/users/me" parameters:nil success:^void(AFHTTPRequestOperation *operation, NSDictionary *dictionary) {
        ACUser *user = [[ACUser alloc] initWithDictionary:dictionary];
        [ACUser setCurrentUser:user];
        if(completion) {
            completion(user, nil);
        }
    } failure:^void(AFHTTPRequestOperation * operation, NSError *error) {
        if(completion) {
            completion(nil, error);
        }
    }];
}

+ (AFHTTPRequestOperation *)getAllUsersWithCompletion:(void (^)(NSArray *allUsers, NSError *error))completion {
    ACSocialAPIRequestOperationManager *manager = [ACSocialAPIRequestOperationManager sharedManager];
    return [manager GET:@"/users" parameters:nil success:^void(AFHTTPRequestOperation *operation, NSArray *userDicts) {
        if(completion) {
            NSMutableArray *users = [NSMutableArray arrayWithCapacity:userDicts.count];
            for (NSDictionary *dict in userDicts) {
                ACUser *user = [[ACUser alloc] initWithDictionary:dict];
                [users addObject:user];
            }
            completion(users, nil);
        }
        
    } failure:^void(AFHTTPRequestOperation * operation, NSError *error) {
        if(completion) {
            completion(nil, error);
        }
    }];
}

+ (AFHTTPRequestOperation *)getAllUsersWithStatusAndCompletion:(void (^)(NSArray *allUsers, NSError *error))completion {
    ACSocialAPIRequestOperationManager *manager = [ACSocialAPIRequestOperationManager sharedManager];
    return [manager GET:@"/users" parameters:nil success:^void(AFHTTPRequestOperation *operation, NSArray *userDicts) {
        if(completion) {
            NSMutableArray *users = [NSMutableArray arrayWithCapacity:userDicts.count];
            for (NSDictionary *dict in userDicts) {
                ACUser *user = [[ACUser alloc] initWithDictionary:dict];
                [users addObject:user];
            }
            
            // Fetch all invites sent and received
            [self friedRequestsReceivedWithCompletion:^(NSArray *requestDicts, NSError *error) {
                for (NSDictionary *requestDict in requestDicts) {
                    NSString *identifier = requestDict[@"userRequester"][@"_id"];
                    ACUser *friend = [[users filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"identifier = %@", identifier]] firstObject];
                    friend.friendRequestStatus = ACFriendRequestStatusReceived;
                }
                [self friendInvitedWithCompletion:^(NSArray *inviteDicts, NSError *error) {
                    for (NSDictionary *inviteDict in inviteDicts) {
                        NSString *identifier = inviteDict[@"userRequested"][@"_id"];
                        ACUser *friend = [[users filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"identifier = %@", identifier]] firstObject];
                        friend.friendRequestStatus = ACFriendRequestStatusSent;
                    }
                    
                    completion(users, nil);
                }];
            }];
        }
        
    } failure:^void(AFHTTPRequestOperation * operation, NSError *error) {
        if(completion) {
            completion(nil, error);
        }
    }];
}

+ (AFHTTPRequestOperation *)getAllFriendsWithCompletion:(void (^)(NSArray *friends, NSError *error))completion {
    ACSocialAPIRequestOperationManager *manager = [ACSocialAPIRequestOperationManager sharedManager];
    return [manager GET:@"/friendships/me" parameters:nil success:^void(AFHTTPRequestOperation *operation, NSArray *friendDicts) {
        if(completion) {
            NSMutableArray *friends = [NSMutableArray arrayWithCapacity:friendDicts.count];
            for (NSDictionary *dict in friendDicts) {
                ACUser *friend = [[ACUser alloc] initWithDictionary:dict];
                [friends addObject:friend];
            }
            completion(friends, nil);
        }

    } failure:^void(AFHTTPRequestOperation * operation, NSError *error) {
        if(completion) {
            completion(nil, error);
        }
    }];

}

+ (AFHTTPRequestOperation *)inviteFriend:(ACUser *)friendUser completion:(void (^)(BOOL, NSError *))completion {
    ACSocialAPIRequestOperationManager *manager = [ACSocialAPIRequestOperationManager sharedManager];
    return [manager POST:[NSString stringWithFormat:@"/friendships/%@", friendUser.identifier] parameters:nil success:^void(AFHTTPRequestOperation *operation, id JSON) {
        if(completion) {
            completion(YES, nil);
        }
        
    } failure:^void(AFHTTPRequestOperation * operation, NSError *error) {
        if(completion) {
            completion(NO, error);
        }
    }];
}

+ (AFHTTPRequestOperation *)acceptFriend:(ACUser *)friendUser completion:(void (^)(BOOL success, NSError *error))completion {
    ACSocialAPIRequestOperationManager *manager = [ACSocialAPIRequestOperationManager sharedManager];
    return [manager PUT:[NSString stringWithFormat:@"/friendships/%@", friendUser.identifier] parameters:nil success:^void(AFHTTPRequestOperation *operation, id JSON) {
        if(completion) {
            completion(YES, nil);
        }
        
    } failure:^void(AFHTTPRequestOperation * operation, NSError *error) {
        if(completion) {
            completion(NO, error);
        }
    }];
}

+ (AFHTTPRequestOperation *)friedRequestsReceivedWithCompletion:(void (^)(NSArray *, NSError *))completion {
    ACSocialAPIRequestOperationManager *manager = [ACSocialAPIRequestOperationManager sharedManager];
    return [manager GET:@"/friendships/requests" parameters:nil success:^void(AFHTTPRequestOperation *operation, NSArray *requestDicts) {
        if(completion) {
            completion(requestDicts, nil);
        }
        
    } failure:^void(AFHTTPRequestOperation * operation, NSError *error) {
        if(completion) {
            completion(nil, error);
        }
    }];
}

+ (AFHTTPRequestOperation *)friendInvitedWithCompletion:(void (^)(NSArray *, NSError *))completion {
    ACSocialAPIRequestOperationManager *manager = [ACSocialAPIRequestOperationManager sharedManager];
    return [manager GET:@"/friendships/requested" parameters:nil success:^void(AFHTTPRequestOperation *operation, NSArray *requestDicts) {
        if(completion) {
            completion(requestDicts, nil);
        }
        
    } failure:^void(AFHTTPRequestOperation * operation, NSError *error) {
        if(completion) {
            completion(nil, error);
        }
    }];
}

@end
