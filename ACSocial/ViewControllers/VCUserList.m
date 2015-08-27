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

static NSString * const CellID = @"UserCell";

@interface VCUserList ()

@property (nonatomic) NSArray *allUsers;

@end

@implementation VCUserList

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"All Users";
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([UserCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:CellID];
    
    // TODO: Load users from the REST API
    self.allUsers = @[ [[ACUser alloc] initWithDictionary:@{@"name":@"Alexandre"}],
                       [[ACUser alloc] initWithDictionary:@{@"name":@"José"}],
                       [[ACUser alloc] initWithDictionary:@{@"name":@"Carlos"}],
                       [[ACUser alloc] initWithDictionary:@{@"name":@"Tiago"}],
                       [[ACUser alloc] initWithDictionary:@{@"name":@"Pedro"}],
                       [[ACUser alloc] initWithDictionary:@{@"name":@"Luis"}],
                       [[ACUser alloc] initWithDictionary:@{@"name":@"Thiago"}],
                       [[ACUser alloc] initWithDictionary:@{@"name":@"Marcelo"}]];
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

    UserCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID forIndexPath:indexPath];
    
    ACUser *user = self.allUsers[indexPath.row];
    
    // Setup UserCell properly.
    cell.nameLabel.text = user.name;

    [cell.userImageView setImageWithURL:user.pictureURL placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    // Clear target and add it again
    [cell.addFriendButton removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
    [cell.addFriendButton addTarget:self action:@selector(addFriendButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    // Set the index path for later refence when the button is tapped.
    cell.addFriendButton.indexPath = indexPath;
    
    return cell;
}

#pragma mark - UI Actions

- (IBAction)doneButtonTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)addFriendButtonTapped:(id)sender {
    if([self.delegate respondsToSelector:@selector(vcUserList:didAddFriend:)]) {
        // Get the index path from the button
        UIButton *button = sender;
        ACUser *addedFriend = self.allUsers[button.indexPath.row];
        
        [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"Added friend: %@", addedFriend.name]];
        
        if([self.delegate respondsToSelector:@selector(vcUserList:didAddFriend:)]) {
            [self.delegate vcUserList:self didAddFriend:addedFriend];
        }
    }
}

@end
