//
//  MRTaskListViewController.m
//  Tackle
//
//  Created by Scott Bader on 12/27/14.
//  Copyright (c) 2014 Melody Road. All rights reserved.
//

#import "MRTaskListViewController.h"

#import "PaintCodeStyleKit.h"
#import "MRTaskTableViewController.h"
#import "MRTaskEditNavigationController.h"
#import "MRTaskEditViewController.h"

@interface MRTaskListViewController () <MRTaskEditingDelegate>

@property (nonatomic) NSManagedObjectContext *managedObjectContext;

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
    tableViewController.taskEditingDelegate = self;
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
    MRTaskEditNavigationController *navigationController = [[MRTaskEditNavigationController alloc] initWithRootViewController:editController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)handleAddButton:(id)sender {
    [self displayEditViewWithTitle:nil dueDate:nil];
}

//- (void)taskEditViewDidReturnWithText:(NSString *)text dueDate:(NSDate *)dueDate {
//    if (self.editingTask) {
//        BOOL shouldReschedule = !([dueDate isEqual:self.editingTask.dueDate]);
//
//        [self.editingTask setText:text];
//        [self.editingTask setDueDate:dueDate];
//
//        __block NSError *error;
//        [self.editingTask.managedObjectContext performBlock:^{
//            [self.editingTask.managedObjectContext save:&error];
//        }];
//
//        if (shouldReschedule) {
//            [self.editingTask rescheduleNotification];
//        }
//
//        [self setEditingTask:nil];
//    }
//    else {
//        Task *task = [NSEntityDescription insertNewObjectForEntityForName:@"Task" inManagedObjectContext:self.managedObjectContext];
//        [task setText:text];
//        [task setDueDate:dueDate];
//
//        __block NSError *error;
//        [task.managedObjectContext performBlock:^{
//            [task.managedObjectContext save:&error];
//            [task scheduleNotification];
//        }];
//    }
//
//    [self.mainCollectionViewController resetContentOffsetWithAnimations:^{
//        self.editView.topConstraint.constant = kMREditViewInitialTop;
//        [self.view layoutIfNeeded];
//    } completions:^{
//        [self.editView resetContent];
//    }];
//}

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

#pragma mark - Task Editing Delegate

- (void)editTask:(Task *)task {
    [self displayEditViewWithTitle:task.text dueDate:task.dueDate];
}

@end
