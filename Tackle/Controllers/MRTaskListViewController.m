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
        self.title = NSLocalizedString(@"Tasks List Title", nil);
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

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(undoManagerDidUndoChange:)
                                                 name:NSUndoManagerDidUndoChangeNotification
                                               object:self.persistenceController.managedObjectContext.undoManager];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(undoManagerDidRedoChange:)
                                                 name:NSUndoManagerDidRedoChangeNotification
                                               object:self.persistenceController.managedObjectContext.undoManager];
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

- (void)displayEditViewWithTitle:(NSString *)title dueDate:(NSDate *)dueDate repeatInterval:(TaskRepeatInterval)repeatInterval animated:(BOOL)animated {
    MRTaskEditViewController *editController = [[MRTaskEditViewController alloc] initWithTitle:title dueDate:dueDate repeatInterval:repeatInterval managedObjectContext:self.persistenceController.managedObjectContext];
    editController.delegate = self;
    MRTaskEditNavigationController *navigationController = [[MRTaskEditNavigationController alloc] initWithRootViewController:editController];
    [self presentViewController:navigationController animated:animated completion:nil];
}

- (void)displayEditViewWithTitle:(NSString *)title dueDate:(NSDate *)dueDate repeatInterval:(TaskRepeatInterval)repeatInterval {
    [self displayEditViewWithTitle:title dueDate:dueDate repeatInterval:repeatInterval animated:YES];
}

- (void)saveEditingTaskWithTitle:(NSString *)title dueDate:(NSDate *)dueDate repeatInterval:(TaskRepeatInterval)repeatInterval {
    Task *task;

    if (self.editingTask) {
        task = self.editingTask;
    }
    else {
        task = [NSEntityDescription insertNewObjectForEntityForName:@"Task"
                                             inManagedObjectContext:self.persistenceController.managedObjectContext];

        task.identifier = [NSUUID UUID].UUIDString;
        task.originalDueDate = dueDate;
    }

    task.title = title;
    task.dueDate = dueDate;
    task.repeats = @(repeatInterval);

    [self.persistenceController save];
    [[MRNotificationProvider sharedProvider] rescheduleAllNotificationsWithManagedObjectContext:self.persistenceController.managedObjectContext];
}

- (void)handleNotificationForTask:(Task *)task {
    [self countAndDisplayIconForPassedTasks];
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
    [self displayEditViewWithTitle:nil dueDate:nil repeatInterval:TaskRepeatIntervalNone];
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
    [self displayEditViewWithTitle:task.title dueDate:task.dueDate repeatInterval:task.taskRepeatInterval];
}

- (NSUndoManager *)undoManager {
    return self.persistenceController.managedObjectContext.undoManager;
}

- (void)completedTask:(Task *)task {
    task.isDone = YES;
    task.completedDate = [NSDate date];

    [[self undoManager] setActionName:@"Completed Task"];

    [task createRepeatedTaskInManagedObjectContext:self.persistenceController.managedObjectContext];

    [self.persistenceController save];
    [[MRNotificationProvider sharedProvider] rescheduleAllNotificationsWithManagedObjectContext:self.persistenceController.managedObjectContext];
}

#pragma mark - Task Alerting Delegate

- (void)checkTaskCount {
    if (self.modalPresentedViewController) {
        NSFetchRequest *fetchRequest = [Task passedOpenTasksFetchRequestWithManagedObjectContext:self.persistenceController.managedObjectContext];

        NSError *error = nil;
        NSInteger count = [self.persistenceController.managedObjectContext countForFetchRequest:fetchRequest error:&error];
        NSAssert(error == nil, @"Could not get count for fetch request: %@", error);

        if (count == 0) {
            [self mr_dismissViewControllerModallyAnimated:YES completion:nil];
        }
    }
}

- (void)editedAlertedTask:(Task *)task {
    [self.persistenceController save];
    [[MRNotificationProvider sharedProvider] rescheduleAllNotificationsWithManagedObjectContext:self.persistenceController.managedObjectContext];
    [self checkTaskCount];
}

- (void)completedAlertedTask:(Task *)task {
    [self completedTask:task];
    [self checkTaskCount];
}

#pragma mark - Task Editing Delegate

- (void)completedTask {
    if (self.editingTask) {
        [self completedTask:self.editingTask];
    }
}

- (void)editedTaskTitle:(NSString *)title dueDate:(NSDate *)dueDate repeatInterval:(TaskRepeatInterval)repeatInterval {
    [self saveEditingTaskWithTitle:title dueDate:dueDate repeatInterval:repeatInterval];
}

#pragma mark - Archive Task Delegate

- (void)selectedRecycledTitle:(NSString *)title {
    [self dismissViewControllerAnimated:YES completion:^{
        [self displayEditViewWithTitle:title dueDate:nil repeatInterval:TaskRepeatIntervalNone];
    }];
}

#pragma mark - Core Data Observer

- (void)managedObjectContextDidChange:(id)sender {
    [self countAndDisplayIconForPassedTasks];
    [self displayInfoViewWithOpenTasks];
}

- (void)undoManagerDidUndoChange:(id)sender {
    [[MRNotificationProvider sharedProvider] rescheduleAllNotificationsWithManagedObjectContext:self.persistenceController.managedObjectContext];
}

- (void)undoManagerDidRedoChange:(id)sender {
    [[MRNotificationProvider sharedProvider] rescheduleAllNotificationsWithManagedObjectContext:self.persistenceController.managedObjectContext];
}

#pragma mark - Key Commands

- (NSArray<UIKeyCommand *>*)keyCommands {
    return @[
             [UIKeyCommand keyCommandWithInput:@"q" modifierFlags:UIKeyModifierControl action:@selector(handleNotificationKeyCommand:) discoverabilityTitle:@"Fire First Notification"],
             ];
}

- (void)handleNotificationKeyCommand:(id)sender {
}

- (void)countAndDisplayIconForPassedTasks {
    NSFetchRequest *fetchRequest = [Task passedOpenTasksFetchRequestWithManagedObjectContext:self.persistenceController.managedObjectContext];
    [fetchRequest setFetchLimit:5];

    NSError *error = nil;
    NSInteger count = [self.persistenceController.managedObjectContext countForFetchRequest:fetchRequest error:&error];
    NSAssert(error == nil, @"Could not get count for fetch request: %@", error);

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
