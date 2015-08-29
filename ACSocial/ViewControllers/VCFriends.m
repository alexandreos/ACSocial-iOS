//
//  VCFriends.m
//  ACSocial
//
//  Created by Alexandre Santos on 26/08/15.
//  Copyright (c) 2015 Avenue Code. All rights reserved.
//

#import "VCFriends.h"
#import "VCUserList.h"
#import "UserCell.h"
#import "VCLogin.h"
#import <UIImageView+AFNetworking.h>
#import "ACSocialAPI.h"
#import "FriendInviteCell.h"
#import "UIView+IndexPath.h"
#import <SVProgressHUD.h>
#import "UIAlertController+Error.h"

// Segue IDs
static NSString * const kVCUserListSegueID = @"VCUserListSegueID";

// Cell IDs
static NSString * const UserCellID = @"UserCellID";

typedef NS_ENUM(NSUInteger, VCFriendsSections) {
    VCFriendsSectionFriends = 0,
    VCFriendsSectionRequestsReceived,
    VCFriendsSectionsCount
};

@interface VCFriends () <VCUserListDelegate, VCLoginDelegate>

@property (nonatomic) NSArray *requestsReceived;

@end

@implementation VCFriends

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"My Friends";
    
    self.refreshControl = [[UIRefreshControl alloc] initWithFrame:CGRectZero];
    [self.refreshControl addTarget:self action:@selector(loadData) forControlEvents:UIControlEventValueChanged];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if([ACUser currentUser] == nil) {
        // Present Login screen
        VCLogin *vcLogin = [VCLogin instanceFromNib];
        vcLogin.delegate = self;
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vcLogin];
        [self presentViewController:nc animated:NO completion:nil];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:kVCUserListSegueID]) {
        UINavigationController *nc = segue.destinationViewController;
        VCUserList *vcUserList = (VCUserList *)nc.topViewController;
        
        // Set the delegate of the User List view controller to this instance
        vcUserList.delegate = self;
    }
}

#pragma mark - Data Loading

- (void)loadData {
    [self loadFriends];
    [self loadRequestsReceived];
}

- (void)loadFriends {
    // Load all friends
    [ACSocialAPIService getAllFriendsWithCompletion:^(NSArray *friends, NSError *error) {
        [self.refreshControl endRefreshing];
        
        [ACUser currentUser].friends = friends;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:VCFriendsSectionFriends] withRowAnimation:UITableViewRowAnimationFade];
    }];
}

- (void)loadRequestsReceived {
    [ACSocialAPIService friedRequestsReceivedWithCompletion:^(NSArray *friendRequestsReceived, NSError *error) {
        self.requestsReceived = friendRequestsReceived;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:VCFriendsSectionRequestsReceived] withRowAnimation:UITableViewRowAnimationFade];
    }];
}

#pragma mark - UI Actions

- (void)acceptFriendButtonTapped:(id)sender {
    // Get the index path from the button
    UIButton *button = sender;
    ACUser *addedFriend = self.requestsReceived[button.indexPath.row];
    
    [SVProgressHUD showWithStatus:@"Accepting friend"];
    [ACSocialAPIService acceptFriend:addedFriend completion:^(BOOL success, NSError *error) {
        if(success) {
            [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"Accepted friend %@", addedFriend.name]];
            
            addedFriend.friendRequestStatus = ACFriendRequestStatusAccepted;
            [self loadData];
        }
        else {
            [SVProgressHUD dismiss];
            [self presentViewController:[UIAlertController alertControllerWithError:error] animated:YES completion:nil];
        }
    }];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return VCFriendsSectionsCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    switch (section) {
        case VCFriendsSectionFriends:
            return [ACUser currentUser].friends.count;

        case VCFriendsSectionRequestsReceived:
            return self.requestsReceived.count;
    }
    
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case VCFriendsSectionFriends:
            return [ACUser currentUser].friends.count > 0 ? @"Friends" : nil;
            
        case VCFriendsSectionRequestsReceived:
            return self.requestsReceived.count > 0 ? @"Friend Requests" : nil;
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case VCFriendsSectionFriends:
        {
            UserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserCellID" forIndexPath:indexPath];

            ACUser *friend = [ACUser currentUser].friends[indexPath.row];
            [cell setupWithUser:friend];
            
            return cell;
        }
        case VCFriendsSectionRequestsReceived:
        {
            FriendInviteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendInviteCellID" forIndexPath:indexPath];
            
            ACUser *friend = self.requestsReceived[indexPath.row];
            [cell setupWithUser:friend];
            
            [cell.actionButton addTarget:self action:@selector(acceptFriendButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
            cell.actionButton.indexPath = indexPath;
            
            return cell;
        }
    }
    return nil;
}

#pragma mark - VCUserListDelegate

- (void)vcUserList:(VCUserList *)vcUserList didAddFriend:(NSString *)friendName {
    // Reload data after inviting/accepting a friend
    [self loadFriends];
    [self loadRequestsReceived];
}

#pragma mark - VCLoginDelegate

- (void)vcLogin:(VCLogin *)vcLogin didLoginUser:(ACUser *)user {
    [vcLogin dismissViewControllerAnimated:YES completion:nil];
    
    // Reload data after login
    [self loadFriends];
    [self loadRequestsReceived];
}

@end
