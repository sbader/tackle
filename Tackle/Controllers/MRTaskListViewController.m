//
//  MRTaskListViewController.m
//  Tackle
//
//  Created by Scott Bader on 12/27/14.
//  Copyright (c) 2014 Melody Road. All rights reserved.
//

#import "MRTaskListViewController.h"

#import "Task.h"
#import "PaintCodeStyleKit.h"
#import "MRTaskTableViewController.h"
#import "MRTaskEditNavigationController.h"
#import "MRTaskEditViewController.h"

@interface MRTaskListViewController () <MRTaskTableViewDelegate, MRTaskEditingDelegate>

@property (nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic) Task *editingTask;

@end

@implementation MRTaskListViewController

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    self = [super init];

    if (self) {
        self.title = @"Tasks";
        self.managedObjectContext = managedObjectContext;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    MRTaskTableViewController *tableViewController = [[MRTaskTableViewController alloc] initWithManagedObjectContext:self.managedObjectContext];
    tableViewController.taskDelegate = self;
    [self addChildViewController:tableViewController];
    [self.view addSubview:tableViewController.view];
    [tableViewController.view constraintsMatchSuperview];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[PaintCodeStyleKit imageOfLetterTIcon]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:nil];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[PaintCodeStyleKit imageOfAddIcon]
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(handleAddButton:)];

}

- (void)displayEditViewWithTitle:(NSString *)title dueDate:(NSDate *)dueDate {
    MRTaskEditViewController *editController = [[MRTaskEditViewController alloc] initWithTitle:title dueDate:dueDate];
    editController.delegate = self;
    MRTaskEditNavigationController *navigationController = [[MRTaskEditNavigationController alloc] initWithRootViewController:editController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)handleAddButton:(id)sender {
    self.editingTask = nil;
    [self displayEditViewWithTitle:nil dueDate:nil];
}

//- (void)markAsDone:(MRMainCollectionViewCell *)cell {
//    __block NSError *error;
//    [self.collectionView performBatchUpdates:^{
//        Task *task = [self.fetchedResultsController objectAtIndexPath:[self.collectionView indexPathForCell:cell]];
//        [task setIsDone:YES];
//        [task cancelNotification];
//
//        [task.managedObjectContext performBlock:^{
//            [task.managedObjectContext save:&error];
//        }];
//    } completion:^(BOOL finished) {
//
//    }];
//}

- (void)saveEditingTaskWithTitle:(NSString *)title dueDate:(NSDate *)dueDate {
    Task *task;

    if (self.editingTask) {
        task = self.editingTask;
    }
    else {
        task = [NSEntityDescription insertNewObjectForEntityForName:@"Task"
                                                   inManagedObjectContext:self.managedObjectContext];
    }

    task.text = title;
    task.dueDate = dueDate;

    __block NSError *error;
    [task.managedObjectContext performBlock:^{
        [task.managedObjectContext save:&error];
        [Task rescheduleAllNotificationsWithManagedObjectContext:task.managedObjectContext];
    }];
}

- (void)handleNotificationForTask:(Task *)task {
    [self selectedTask:task];
}

#pragma mark - Task Selection Delegate

- (void)selectedTask:(Task *)task {
    self.editingTask = task;
    [self displayEditViewWithTitle:task.text dueDate:task.dueDate];
}

- (void)completedTask:(Task *)task {
    __block NSError *error;
    task.isDone = YES;

    [task.managedObjectContext performBlock:^{
        [task.managedObjectContext save:&error];
        [Task rescheduleAllNotificationsWithManagedObjectContext:task.managedObjectContext];
    }];
}

#pragma mark - Task Editing Delegate

- (void)editedTaskTitle:(NSString *)title dueDate:(NSDate *)dueDate {
    [self saveEditingTaskWithTitle:title dueDate:dueDate];
}

@end
