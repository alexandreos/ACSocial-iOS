//
//  VCUserList.h
//  ACSocial
//
//  Created by Alexandre Santos on 26/08/15.
//  Copyright (c) 2015 Avenue Code. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ACUser;
@class VCUserList;

@protocol VCUserListDelegate <NSObject>

@optional

- (void)vcUserList:(VCUserList *)vcUserList didUpdateFriend:(ACUser *)updatedFriend;

@end

@interface VCUserList : UITableViewController

@property (nonatomic, weak) id<VCUserListDelegate>delegate;

@end
