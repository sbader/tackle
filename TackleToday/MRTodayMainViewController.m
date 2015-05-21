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
#import "MRReadOnlyPersistenceController.h"

#import <NotificationCenter/NotificationCenter.h>

@interface MRTodayMainViewController () <NCWidgetProviding>

@property (nonatomic) MRTodayTableViewController *tableViewController;
@property (strong) MRReadOnlyPersistenceController *persistenceController;

@end

@implementation MRTodayMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.persistenceController = [[MRReadOnlyPersistenceController alloc] initWithCallback:^{
        [self completeUserInterface];
    }];
}

- (void)completeUserInterface {
    self.tableViewController = [[MRTodayTableViewController alloc] initWithPersistenceController:self.persistenceController];
    self.tableViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.tableViewController.view];
    [self.tableViewController.view constraintsMatchSuperview];

    [self addChildViewController:self.tableViewController];
}

@end
