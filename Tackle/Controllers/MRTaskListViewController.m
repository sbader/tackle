//
//  MRTaskListViewController.m
//  Tackle
//
//  Created by Scott Bader on 12/27/14.
//  Copyright (c) 2014 Melody Road. All rights reserved.
//

#import "MRTaskListViewController.h"

#import <QuartzCore/QuartzCore.h>


#import "Task.h"
#import "PaintCodeStyleKit.h"
#import "MRTaskTableViewDelegate.h"
#import "MRTaskEditViewController.h"
#import "MRTaskTableViewController.h"
#import "MRTaskEditNavigationController.h"

@interface MRTaskListViewController () <MRTaskTableViewDelegate, MRTaskEditingDelegate>

@property (nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic) Task *editingTask;
@property (nonatomic) UIView *infoView;

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

- (void)dealloc {
    [self removeObservers];
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
                                                                            action:@selector(handleLogoButton:)];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[PaintCodeStyleKit imageOfAddIcon]
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(handleAddButton:)];

    [self setupInfoView];
    [self addObservers];
    [self displayInfoViewWithOpenTasks];
}


- (void)addObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(managedObjectContextDidChange:)
                                                 name:NSManagedObjectContextObjectsDidChangeNotification
                                               object:self.managedObjectContext];
}

- (void)removeObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSManagedObjectContextObjectsDidChangeNotification object:self.managedObjectContext];
}

- (void)setupInfoView {
    self.infoView = [[UIView alloc] init];
    self.infoView.translatesAutoresizingMaskIntoConstraints = NO;
    self.infoView.layer.cornerRadius = 5;
    self.infoView.backgroundColor = [UIColor offWhiteBackgroundColor];
    [self.view addSubview:self.infoView];

    [self.infoView topConstraintMatchesSuperviewWithConstant:35.0];
    [self.infoView leadingConstraintMatchesSuperviewWithConstant:10.0];
    [self.infoView trailingConstraintMatchesSuperviewWithConstant:-10.0];

    UILabel *infoLabel = [[UILabel alloc] init];
    infoLabel.translatesAutoresizingMaskIntoConstraints = NO;
    infoLabel.text = @"You have nothing to tackle right now. You can add a task by hitting the plus sign above.";
    infoLabel.textAlignment = NSTextAlignmentLeft;
    infoLabel.font = [UIFont fontForInfoLabel];
    infoLabel.numberOfLines = 0;
    [self.infoView addSubview:infoLabel];

    [infoLabel topConstraintMatchesSuperviewWithConstant:15.0];
    [infoLabel bottomConstraintMatchesSuperviewWithConstant:-15.0];
    [infoLabel leadingConstraintMatchesSuperviewWithConstant:13.0];

    UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:[PaintCodeStyleKit imageOfArrow]];
    arrowImageView.tintColor = [UIColor grayBackgroundColor];
    arrowImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.infoView addSubview:arrowImageView];

    [arrowImageView topConstraintMatchesSuperviewWithConstant:12.0];
    [arrowImageView bottomConstraintMatchesSuperviewWithConstant:-20.0];
    [arrowImageView trailingConstraintMatchesSuperviewWithConstant:-10.0];
    [arrowImageView staticHeightConstraint:80.0];
    [arrowImageView staticWidthConstraint:20.0];

    [self.infoView addConstraint:[NSLayoutConstraint constraintWithItem:infoLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:arrowImageView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:-22.0]];
}

- (void)displayEditViewWithTitle:(NSString *)title dueDate:(NSDate *)dueDate {
    MRTaskEditViewController *editController = [[MRTaskEditViewController alloc] initWithTitle:title dueDate:dueDate managedObjectContext:self.managedObjectContext];
    editController.delegate = self;
    MRTaskEditNavigationController *navigationController = [[MRTaskEditNavigationController alloc] initWithRootViewController:editController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

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

- (void)displayInfoViewWithOpenTasks {
    NSInteger tasks = [Task numberOfOpenTasksInManagedObjectContext:self.managedObjectContext];
    self.infoView.hidden = (tasks > 0);
}

#pragma mark - Handlers

- (void)handleAddButton:(id)sender {
    self.editingTask = nil;
    [self displayEditViewWithTitle:nil dueDate:nil];
}

- (void)handleLogoButton:(id)sender {
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

#pragma mark - Core Data Observer

- (void)managedObjectContextDidChange:(id)sender {
    [self displayInfoViewWithOpenTasks];
}

@end
