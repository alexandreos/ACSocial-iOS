//
//  VCUserList.m
//  ACSocial
//
//  Created by Alexandre Santos on 26/08/15.
//  Copyright (c) 2015 Avenue Code. All rights reserved.
//

#import "VCUserList.h"
#import "UserCell.h"
#import "UIView+IndexPath.h"
#import <UIImageView+AFNetworking.h>
#import <SVProgressHUD.h>
#import "ACSocialAPI.h"
#import "UIAlertController+Error.h"

// Cell IDs
static NSString * const UserCellID = @"UserCellID";
static NSString * const FriendInviteCellID = @"FriendInviteCellID";

@interface VCUserList ()

@property (nonatomic) NSArray *allUsers;

@end

@implementation VCUserList

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"All Users";
    
    self.refreshControl = [[UIRefreshControl alloc] initWithFrame:CGRectZero];
    [self.refreshControl addTarget:self action:@selector(loadData) forControlEvents:UIControlEventValueChanged];
    
    [self.refreshControl beginRefreshing];
    [self loadData];
}

#pragma mark - Data Loading

- (void)loadData {
    // Load users from the REST API
    [ACSocialAPIService getAllUsersWithStatusAndCompletion:^(NSArray *allUsers, NSError *error) {
        [self.refreshControl endRefreshing];
        if(allUsers) {
            // Check which friends are friends already
            NSArray *currentFriends = [ACUser currentUser].friends;
            for (ACUser *friend in currentFriends) {
                ACUser *user = [[allUsers filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(ACUser *u, NSDictionary *bindings) {
                    return [friend.identifier isEqualToString:u.identifier];
                }]] firstObject];
                user.friendRequestStatus = ACFriendRequestStatusAccepted;
            }
            
            self.allUsers = allUsers;
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        else {
            // Show some error
            [self presentViewController:[UIAlertController alertControllerWithError:error] animated:YES completion:nil];
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.allUsers.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 66;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ACUser *user = self.allUsers[indexPath.row];

    UserCell *cell = nil;
    if(user.friendRequestStatus == ACFriendRequestStatusReceived ||
       user.friendRequestStatus == ACFriendRequestStatusAccepted) {
        cell = [tableView dequeueReusableCellWithIdentifier:FriendInviteCellID forIndexPath:indexPath];

        if(user.friendRequestStatus == ACFriendRequestStatusReceived) {
            // Add target action to button
            [cell.actionButton addTarget:self action:@selector(acceptFriendButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        }
        else {
            // Add target action to button
            [cell.actionButton addTarget:self action:@selector(unfriendButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    else {
        cell = [tableView dequeueReusableCellWithIdentifier:UserCellID forIndexPath:indexPath];
        // Add target action to button
        [cell.actionButton addTarget:self action:@selector(addFriendButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [cell setupWithUser:user];
    
    // Set the index path for later refence when the button is tapped.
    cell.actionButton.indexPath = indexPath;
    
    return cell;
}

#pragma mark - UI Actions

- (IBAction)doneButtonTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)addFriendButtonTapped:(id)sender {
    if([self.delegate respondsToSelector:@selector(vcUserList:didUpdateFriend:)]) {
        // Get the index path from the button
        UIButton *button = sender;
        ACUser *addedFriend = self.allUsers[button.indexPath.row];
        
        [SVProgressHUD showWithStatus:@"Inviting friend"];
        [ACSocialAPIService inviteFriend:addedFriend completion:^(BOOL success, NSError *error) {
            if(success) {
                [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"Invite sent to %@", addedFriend.name]];
                
                addedFriend.friendRequestStatus = ACFriendRequestStatusSent;
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
                
                if([self.delegate respondsToSelector:@selector(vcUserList:didUpdateFriend:)]) {
                    [self.delegate vcUserList:self didUpdateFriend:addedFriend];
                }
            }
            else {
                [SVProgressHUD dismiss];
                [self presentViewController:[UIAlertController alertControllerWithError:error] animated:YES completion:nil];
            }
        }];
    }
}

- (void)unfriendButtonTapped:(id)sender {
    if([self.delegate respondsToSelector:@selector(vcUserList:didUpdateFriend:)]) {
        // Get the index path from the button
        UIButton *button = sender;
        ACUser *addedFriend = self.allUsers[button.indexPath.row];
        
        [SVProgressHUD showWithStatus:@"Removing friend"];
        [ACSocialAPIService inviteFriend:addedFriend completion:^(BOOL success, NSError *error) {
            if(success) {
                [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"Removed friendship with %@", addedFriend.name]];
                
                [self loadData];
                
                if([self.delegate respondsToSelector:@selector(vcUserList:didUpdateFriend:)]) {
                    [self.delegate vcUserList:self didUpdateFriend:addedFriend];
                }
            }
            else {
                [SVProgressHUD dismiss];
                [self presentViewController:[UIAlertController alertControllerWithError:error] animated:YES completion:nil];
            }
        }];
    }
}

- (void)acceptFriendButtonTapped:(id)sender {
    if([self.delegate respondsToSelector:@selector(vcUserList:didUpdateFriend:)]) {
        // Get the index path from the button
        UIButton *button = sender;
        ACUser *addedFriend = self.allUsers[button.indexPath.row];
        
        [SVProgressHUD showWithStatus:@"Accepting friend"];
        [ACSocialAPIService acceptFriend:addedFriend completion:^(BOOL success, NSError *error) {
            if(success) {
                [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"Friends with %@", addedFriend.name]];
                
                addedFriend.friendRequestStatus = ACFriendRequestStatusAccepted;
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
                
                if([self.delegate respondsToSelector:@selector(vcUserList:didUpdateFriend:)]) {
                    [self.delegate vcUserList:self didUpdateFriend:addedFriend];
                }
            }
            else {
                [SVProgressHUD dismiss];
                [self presentViewController:[UIAlertController alertControllerWithError:error] animated:YES completion:nil];
            }
        }];
    }
}

@end
