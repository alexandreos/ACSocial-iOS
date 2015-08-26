//
//  VCFriends.m
//  ACSocial
//
//  Created by Alexandre Santos on 26/08/15.
//  Copyright (c) 2015 Avenue Code. All rights reserved.
//

#import "VCFriends.h"
#import "VCUserList.h"
#import "ACUser.h"
#import "UserCell.h"

static NSString * const kVCUserListSegueID = @"VCUserListSegueID";

@interface VCFriends () <VCUserListDelegate>

@property (nonatomic) NSMutableArray *friends;

@end

@implementation VCFriends

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"My Friends";
    
    // TODO: Load all friends
    self.friends = [ACUser currentUser].friends ? [[ACUser currentUser].friends mutableCopy] : [NSMutableArray array];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:kVCUserListSegueID]) {
        UINavigationController *nc = segue.destinationViewController;
        VCUserList *vcUserList = (VCUserList *)nc.topViewController;
        
        // Set the delegate of the User List view controller to this instance
        vcUserList.delegate = self;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.friends.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserCellID" forIndexPath:indexPath];

    ACUser *friend = self.friends[indexPath.row];
    cell.nameLabel.text = friend.name;
    
    return cell;
}

#pragma mark - VCUserListDelegate

- (void)vcUserList:(VCUserList *)vcUserList didAddFriend:(NSString *)friendName {
    [self.friends addObject:friendName];
    [ACUser currentUser].friends = [self.friends copy];
    
    [self.tableView reloadData];
}

@end
