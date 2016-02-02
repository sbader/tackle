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
#import "MRNotificationProvider.h"
#import "MRTaskTableViewDelegate.h"
#import "MRTaskEditViewController.h"
#import "MRTaskTableViewController.h"
#import "MRTaskEditNavigationController.h"
#import "MRCreditsViewController.h"
#import "MRArchiveTaskTableViewDelegate.h"
#import "MRNotificationsModalViewController.h"

@interface MRTaskListViewController () <MRTaskTableViewDelegate, MRTaskEditingDelegate, MRArchiveTaskTableViewDelegate, MRTaskAlertingDelegate>

@property (nonatomic) MRPersistenceController *persistenceController;
@property (nonatomic) Task *editingTask;
@property (nonatomic) UIView *infoView;
@property (nonatomic) MRTaskTableViewController *tableViewController;

@end

@implementation MRTaskListViewController

- (instancetype)initWithPersistenceController:(MRPersistenceController *)persistenceController {
    self = [super init];

    if (self) {
        self.title = NSLocalizedString(@"Tasks List Title", nil); //@"Tasks";
        _persistenceController = persistenceController;
    }
    
    return self;
}

- (void)dealloc {
    [self removeObservers];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableViewController = [[MRTaskTableViewController alloc] initWithPersistenceController:self.persistenceController];
    self.tableViewController.taskDelegate = self;
    [self addChildViewController:self.tableViewController];
    [self.view addSubview:self.tableViewController.view];
    [self.tableViewController.view constraintsMatchSuperview];

    self.view.backgroundColor = [UIColor grayBackgroundColor];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[PaintCodeStyleKit imageOfLetterTIcon]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(handleLogoButton:)];

    [self setupInfoView];
    [self addObservers];
    [self displayInfoViewWithOpenTasks];
}

- (UIBarButtonItem *)addBarButtonItem {
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                         target:self
                                                         action:@selector(handleAddButton:)];
}

- (UIBarButtonItem *)alertsBarButtonItemForCount:(NSInteger)count {
    UIImage *image;

    switch (count) {
        case 1:
            image = [PaintCodeStyleKit imageOfAlertIconOne];
            break;
        case 2:
            image = [PaintCodeStyleKit imageOfAlertIconTwo];
            break;
        case 3:
            image = [PaintCodeStyleKit imageOfAlertIconThree];
            break;
        case 4:
            image = [PaintCodeStyleKit imageOfAlertIconFour];
            break;
        case 5:
            image = [PaintCodeStyleKit imageOfAlertIconFive];
            break;
        case 6:
            image = [PaintCodeStyleKit imageOfAlertIconSix];
            break;
        case 7:
            image = [PaintCodeStyleKit imageOfAlertIconSeven];
            break;
        case 8:
            image = [PaintCodeStyleKit imageOfAlertIconEight];
            break;
        default:
            image = [PaintCodeStyleKit imageOfAlertIconNinePlus];
            break;
    }

    return [[UIBarButtonItem alloc] initWithImage:image
                                            style:UIBarButtonItemStylePlain
                                           target:self
                                           action:@selector(handleAlertsButton:)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self countAndDisplayIconForPassedTasks];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self resignFirstResponder];
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)addObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(managedObjectContextDidChange:)
                                                 name:NSManagedObjectContextObjectsDidChangeNotification
                                               object:self.persistenceController.managedObjectContext];
}

- (void)removeObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    infoLabel.text = NSLocalizedString(@"You have nothing to tackle right now. You can add a task by hitting the plus sign above.", nil);
    infoLabel.adjustsFontSizeToFitWidth = YES;
    infoLabel.minimumScaleFactor = 0.75;
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

- (void)displayEditViewWithTitle:(NSString *)title dueDate:(NSDate *)dueDate animated:(BOOL)animated {
    MRTaskEditViewController *editController = [[MRTaskEditViewController alloc] initWithTitle:title dueDate:dueDate managedObjectContext:self.persistenceController.managedObjectContext];
    editController.delegate = self;
    MRTaskEditNavigationController *navigationController = [[MRTaskEditNavigationController alloc] initWithRootViewController:editController];
    [self presentViewController:navigationController animated:animated completion:nil];

}

- (void)displayEditViewWithTitle:(NSString *)title dueDate:(NSDate *)dueDate {
    [self displayEditViewWithTitle:title dueDate:dueDate animated:YES];
}

- (void)saveEditingTaskWithTitle:(NSString *)title dueDate:(NSDate *)dueDate {
    Task *task;

    if (self.editingTask) {
        task = self.editingTask;
    }
    else {
        task = [NSEntityDescription insertNewObjectForEntityForName:@"Task"
                                                   inManagedObjectContext:self.persistenceController.managedObjectContext];
        task.identifier = [NSUUID UUID].UUIDString;
    }

    task.title = title;
    task.dueDate = dueDate;

    [self.persistenceController save];
    [[MRNotificationProvider sharedProvider] rescheduleAllNotificationsWithManagedObjectContext:self.persistenceController.managedObjectContext];
}

- (void)handleNotificationForTask:(Task *)task {
    [self displayNotificationModalWithTask:task];
}

- (void)refreshTasks {
    [self.tableViewController refreshTasks];
}

- (void)displayInfoViewWithOpenTasks {
    NSInteger tasks = [Task numberOfOpenTasksInManagedObjectContext:self.persistenceController.managedObjectContext];
    self.infoView.hidden = (tasks > 0);
}

#pragma mark - Handlers

- (void)handleAddButton:(id)sender {
    self.editingTask = nil;
    [self displayEditViewWithTitle:nil dueDate:nil];
}

- (void)handleLogoButton:(id)sender {
    MRCreditsViewController *vc = [[MRCreditsViewController alloc] initWithPersistenceController:self.persistenceController];
    vc.archiveTaskDelegate = self;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)handleAlertsButton:(id)sender {
    [self displayNotificationModalWithTask:nil];
}

- (void)displayNotificationModalWithTask:(Task *)task {
    if (!self.modalPresentedViewController) {
        MRNotificationsModalViewController *vc = [[MRNotificationsModalViewController alloc] initWithPersistenceController:self.persistenceController];
        vc.taskAlertingDelegate = self;
        [self mr_presentViewControllerModally:vc animated:YES completion:^{
            if (task) {
                [vc displayTask:task];
            }
        }];
    }
}

#pragma mark - Task Selection Delegate

- (void)selectedTask:(Task *)task {
    self.editingTask = task;
    [self displayEditViewWithTitle:task.title dueDate:task.dueDate];
}

- (void)completedTask:(Task *)task {
    task.isDone = YES;
    task.completedDate = [NSDate date];

    [self.undoManager registerUndoWithTarget:self selector:@selector(undoCompleted:) object:task];
    [self.undoManager setActionName:@"Completed Task"];

    [self.persistenceController save];
    [[MRNotificationProvider sharedProvider] rescheduleAllNotificationsWithManagedObjectContext:self.persistenceController.managedObjectContext];
}

- (void)undoCompleted:(Task *)task {
    task.isDone = NO;
    task.completedDate = nil;

    [self.undoManager registerUndoWithTarget:self selector:@selector(completedTask:) object:task];
    [self.undoManager setActionName:@"Completed Task"];

    [self.persistenceController save];
    [[MRNotificationProvider sharedProvider] rescheduleAllNotificationsWithManagedObjectContext:self.persistenceController.managedObjectContext];
}

#pragma mark - Task Alerting Delegate

- (void)editedAlertedTask:(Task *)task {
    [self.persistenceController save];
    [[MRNotificationProvider sharedProvider] rescheduleAllNotificationsWithManagedObjectContext:self.persistenceController.managedObjectContext];
}

- (void)completedAlertedTask:(Task *)task {
    [self completedTask:task];

    if (self.modalPresentedViewController) {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Task" inManagedObjectContext:self.persistenceController.managedObjectContext];
        [fetchRequest setEntity:entity];
        [fetchRequest setFetchLimit:5];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"isDone == NO", [NSDate date]]];
        //    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"isDone == NO AND dueDate < %@", [NSDate date]]];

        NSError *error = nil;
        NSInteger count = [self.persistenceController.managedObjectContext countForFetchRequest:fetchRequest error:&error];
        if (count == 0) {
            [self mr_dismissViewControllerModallyAnimated:YES completion:nil];
        }
    }
}

#pragma mark - Task Editing Delegate

- (void)completedTask {
    if (self.editingTask) {
        [self completedTask:self.editingTask];
    }
}

- (void)editedTaskTitle:(NSString *)title dueDate:(NSDate *)dueDate {
    [self saveEditingTaskWithTitle:title dueDate:dueDate];
}

#pragma mark - Archive Task Delegate

- (void)selectedRecycledTitle:(NSString *)title {
    [self dismissViewControllerAnimated:YES completion:^{
        [self displayEditViewWithTitle:title dueDate:nil];
    }];
}

#pragma mark - Core Data Observer

- (void)managedObjectContextDidChange:(id)sender {
    [self countAndDisplayIconForPassedTasks];
    [self displayInfoViewWithOpenTasks];
}

#pragma mark - Key Commands

- (NSArray<UIKeyCommand *>*)keyCommands {
    return @[
             [UIKeyCommand keyCommandWithInput:@"q" modifierFlags:UIKeyModifierControl action:@selector(handleNotificationKeyCommand:) discoverabilityTitle:@"Fire First Notification"],
             ];
}

- (void)handleNotificationKeyCommand:(id)sender {
    Task *task = [Task firstPassedTaskInManagedObjectContext:self.persistenceController.managedObjectContext];
    [self handleNotificationForTask:task];
}

- (void)countAndDisplayIconForPassedTasks {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Task" inManagedObjectContext:self.persistenceController.managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchLimit:5];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"isDone == NO", [NSDate date]]];
//    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"isDone == NO AND dueDate < %@", [NSDate date]]];

    NSError *error = nil;
    NSInteger count = [self.persistenceController.managedObjectContext countForFetchRequest:fetchRequest error:&error];

    if (count > 0) {
        [self.navigationItem setRightBarButtonItems:@[[self addBarButtonItem], [self alertsBarButtonItemForCount:count]] animated:YES];
    }
    else {
        if (self.navigationItem.rightBarButtonItems) {
            if (self.navigationItem.rightBarButtonItems.count > 1) {
                [self.navigationItem setRightBarButtonItems:@[[self addBarButtonItem]] animated:YES];
            }
        }
        else {
            [self.navigationItem setRightBarButtonItems:@[[self addBarButtonItem]] animated:YES];
        }
    }
}

@end
