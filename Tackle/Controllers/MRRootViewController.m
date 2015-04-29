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

@interface MRRootViewController ()

@property (nonatomic) MRTaskListViewController *taskListController;
@property (nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic) UINavigationController *navigationController;

@end

@implementation MRRootViewController

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    self = [super init];

    if (self) {
        self.managedObjectContext = managedObjectContext;

        self.taskListController = [[MRTaskListViewController alloc] initWithManagedObjectContext:self.managedObjectContext];
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
