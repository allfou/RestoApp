//
//  SortedByViewController.m
//  RestoApp
//
//  Created by Fouad Allaoui on 4/21/17.
//  Copyright © 2017 Fouad Allaoui. All rights reserved.
//

#import "SortedByViewController.h"

@interface SortedByViewController ()

@property NSString *selectedSortedBy;
@property NSIndexPath *lastSelectedCell;

@end

@implementation SortedByViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Remove extra cells
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    // Init default food type
    self.selectedSortedBy = [[NSUserDefaults standardUserDefaults] stringForKey:@"sortedBy"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    // Unselect last selected cell
    [tableView cellForRowAtIndexPath:self.lastSelectedCell].accessoryType = UITableViewCellAccessoryNone;
    
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    
    // Save selected Category into NSUserDefaults
    [[NSUserDefaults standardUserDefaults] setValue:[tableView cellForRowAtIndexPath:indexPath].textLabel.text forKey:@"sortedBy"];
    
    // Refresh Restaurant list with new food type
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadRestaurantListMessageEvent" object:self.selectedSortedBy];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath*)indexPath {
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell*)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Pre-select default category from NSUserDefaults
    if ([self.selectedSortedBy isEqualToString:cell.textLabel.text]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.lastSelectedCell = indexPath;
    }
    
    // Remove inset separator
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17.0f];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *myLabel = [[UILabel alloc] init];
    myLabel.frame = CGRectMake(15, 15, self.view.frame.size.width, 40);
    myLabel.font = [UIFont fontWithName:@"HelveticaNeue-light" size:13.0f];
    myLabel.text = [self tableView:tableView titleForHeaderInSection:section];
    UIView *headerView = [[UIView alloc] init];
    [headerView addSubview:myLabel];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 47;
}

@end
