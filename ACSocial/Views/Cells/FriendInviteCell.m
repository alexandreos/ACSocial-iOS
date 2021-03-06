//
//  FriendInviteCell.m
//  ACSocial
//
//  Created by Alexandre Santos on 28/08/15.
//  Copyright (c) 2015 Avenue Code. All rights reserved.
//

#import "FriendInviteCell.h"
#import "ACUser.h"
#import "ACSocialStyle.h"

@implementation FriendInviteCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.actionButton applyPrimaryStyle];
}

- (void)setupWithUser:(ACUser *)user {
    [super setupWithUser:user];

    if(user.friendRequestStatus == ACFriendRequestStatusAccepted) {
        // Unfriend button
        [self.actionButton setTitle:@"Unfriend" forState:UIControlStateNormal];
    }
    else if(user.friendRequestStatus == ACFriendRequestStatusReceived) {
        // Accept button
        [self.actionButton setTitle:@"Accept" forState:UIControlStateNormal];
    }
    self.accessoryType = UITableViewCellAccessoryNone;
    self.actionButton.hidden = NO;
}

@end
