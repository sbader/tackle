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

@interface MRAddTimeTableViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) NSArray *timeIntervals;

@end

@implementation MRAddTimeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.timeIntervals = @[
                           [MRTimeInterval timeIntervalWithName:@"ten minutes" unit:NSCalendarUnitMinute interval:10],
                           [MRTimeInterval timeIntervalWithName:@"an hour" unit:NSCalendarUnitHour interval:1],
                           [MRTimeInterval timeIntervalWithName:@"a day" unit:NSCalendarUnitDay interval:1],
                           ];

    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorColor = [UIColor grayBorderColor];
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView registerClass:[MRAddTimeTableViewCell class] forCellReuseIdentifier:addTimeCellReuseIdentifier];
}

#pragma mark - Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.timeIntervals.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MRAddTimeTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:addTimeCellReuseIdentifier forIndexPath:indexPath];
    MRTimeInterval *timeInterval = self.timeIntervals[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"Add %@", timeInterval.name];

    return cell;
}

#pragma mark - Table View Delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.timeIntervalDelegate selectedTimeInterval:self.timeIntervals[indexPath.row]];

    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

@end
