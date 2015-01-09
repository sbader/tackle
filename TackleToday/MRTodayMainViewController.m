//
//  MRTodayMainViewController.m
//  Tackle
//
//  Created by Scott Bader on 1/8/15.
//  Copyright (c) 2015 Melody Road. All rights reserved.
//

#import "MRTodayMainViewController.h"

#import "MRTodayTableViewController.h"
#import "UIView+TackleAdditions.h"

#import <NotificationCenter/NotificationCenter.h>

@interface MRTodayMainViewController () <NCWidgetProviding>

@property (nonatomic) MRTodayTableViewController *tableViewController;

@end

@implementation MRTodayMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.translatesAutoresizingMaskIntoConstraints = NO;

    self.tableViewController = [[MRTodayTableViewController alloc] initWithStyle:UITableViewStylePlain];
    self.tableViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.tableViewController.view];
    [self.tableViewController.view constraintsMatchSuperview];

    [self addChildViewController:self.tableViewController];
}

@end
