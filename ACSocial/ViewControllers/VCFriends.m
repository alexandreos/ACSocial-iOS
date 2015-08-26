//
//  VCFriends.m
//  ACSocial
//
//  Created by Alexandre Santos on 26/08/15.
//  Copyright (c) 2015 Avenue Code. All rights reserved.
//

#import "VCFriends.h"

@interface VCFriends ()

@property (nonatomic) NSMutableArray *friends;

@end

@implementation VCFriends

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"My Friends";
    
    // TODO: Load all friends
    self.friends = [NSMutableArray array];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BasicCellID" forIndexPath:indexPath];
    
    cell.textLabel.text = self.friends[indexPath.row];
    
    return cell;
}

@end
