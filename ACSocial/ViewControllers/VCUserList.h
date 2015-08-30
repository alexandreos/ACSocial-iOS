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

/**
 Notify the delegate of the updated friend.
 
 @param vcUserList    The user list view controller.
 @param updatedFriend The updated friend object.
 */
- (void)vcUserList:(VCUserList *)vcUserList didUpdateFriend:(ACUser *)updatedFriend;

@end

@interface VCUserList : UITableViewController

@property (nonatomic, weak) id<VCUserListDelegate>delegate;

@end
