//
//  VCUserList.h
//  ACSocial
//
//  Created by Alexandre Santos on 26/08/15.
//  Copyright (c) 2015 Avenue Code. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACUser.h"

@class VCUserList;

@protocol VCUserListDelegate <NSObject>

- (void)vcUserList:(VCUserList *)vcUserList didAddFriend:(ACUser *)addedFriend;

@end

@interface VCUserList : UITableViewController

@property (nonatomic, weak) id<VCUserListDelegate>delegate;

@end
