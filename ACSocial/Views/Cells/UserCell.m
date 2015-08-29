//
//  UserCell.m
//  ACSocial
//
//  Created by Alexandre Santos on 26/08/15.
//  Copyright (c) 2015 Avenue Code. All rights reserved.
//

#import "UserCell.h"
#import "ACUser.h"
#import <UIImageView+AFNetworking.h>

@implementation UserCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    
    // Make image round
    self.userImageView.layer.cornerRadius = self.userImageView.bounds.size.width/2;
    self.userImageView.layer.masksToBounds = YES;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    // Clear target and add it again
    [self.actionButton removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupWithUser:(ACUser *)user {
    // Setup UserCell properly.
    self.nameLabel.text = user.name;
    
    [self.userImageView setImageWithURL:user.pictureURL placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    if(user.friendRequestStatus == ACFriendRequestStatusSent ||
       user.friendRequestStatus == ACFriendRequestStatusAccepted) {
        self.actionButton.hidden = YES;
        self.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else if(user.friendRequestStatus == ACFriendRequestStatusReceived) {
        self.accessoryType = UITableViewCellAccessoryNone;
        self.actionButton.hidden = YES;
    }
    else {
        self.accessoryType = UITableViewCellAccessoryNone;
        self.actionButton.hidden = NO;
    }
}

@end
