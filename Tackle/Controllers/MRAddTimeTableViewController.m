//
//  MRAddTimeTableViewController.m
//  Tackle
//
//  Created by Scott Bader on 12/28/14.
//  Copyright (c) 2014 Melody Road. All rights reserved.
//

#import "MRAddTimeTableViewController.h"

#import "MRAddTimeTableViewCell.h"

static NSString *addTimeCellReuseIdentifier = @"AddTimeCell";

@implementation MRAddTimeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorColor = [UIColor grayBorderColor];
//    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView registerClass:[MRAddTimeTableViewCell class] forCellReuseIdentifier:addTimeCellReuseIdentifier];
}

#pragma mark - Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MRAddTimeTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:addTimeCellReuseIdentifier forIndexPath:indexPath];
    NSString *text;

    switch (indexPath.row) {
        case 0:
            text = @"Add ten minutes";
            break;
        case 1:
            text = @"Add an hour";
            break;
        case 2:
            text = @"Add a day";
            break;
        default:
            break;
    }

    cell.textLabel.text = text;

    return cell;
}

#pragma mark - Table View Delegate

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

@end
