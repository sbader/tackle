//
//  MRRootViewController.m
//  Tackle
//
//  Created by Scott Bader on 12/27/14.
//  Copyright (c) 2014 Melody Road. All rights reserved.
//

#import "MRRootViewController.h"

#import "Task.h"
#import "MRTaskListViewController.h"
#import "MRConnectivityController.h"

@interface MRRootViewController ()

@property (nonatomic) MRTaskListViewController *taskListController;
@property (nonatomic) MRPersistenceController *persistenceController;
@property (nonatomic) MRConnectivityController *connectivityController;
@property (nonatomic) UINavigationController *navigationController;

@end

@implementation MRRootViewController

- (instancetype)initWithPersistenceController:(MRPersistenceController *)persistenceController connectivityController:(MRConnectivityController *)connectivityController {
    self = [super init];

    if (self) {
        _persistenceController = persistenceController;
        _connectivityController = connectivityController;

        self.taskListController = [[MRTaskListViewController alloc] initWithPersistenceController:self.persistenceController connectivityController:self.connectivityController];
        self.navigationController = [[UINavigationController alloc] initWithRootViewController:self.taskListController];
        
        [self addChildViewController:self.navigationController];
        [self.view addSubview:self.navigationController.view];
    }

    return self;
}

- (void)handleNotificationForTask:(Task *)task {
    [self.taskListController handleNotificationForTask:task];
}

- (void)refreshTasks {
    [self.taskListController refreshTasks];
}

@end
