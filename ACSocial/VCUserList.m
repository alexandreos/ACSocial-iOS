//
//  VCUserList.m
//  ACSocial
//
//  Created by Alexandre Santos on 26/08/15.
//  Copyright (c) 2015 Avenue Code. All rights reserved.
//

#import "VCUserList.h"

@interface VCUserList ()

@property (nonatomic) NSArray *userNames;

@end

@implementation VCUserList

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Users List";
    
    self.userNames = @[@"Alexandre", @"Felipe", @"Marcelo", @"Eduardo", @"Tiago", @"Thiago", @"João"];
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
    return self.userNames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BasicCellID" forIndexPath:indexPath];
    
    cell.textLabel.text = self.userNames[indexPath.row];
    
    return cell;
}

@end
