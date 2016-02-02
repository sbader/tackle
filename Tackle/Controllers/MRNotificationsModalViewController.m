//
//  MRNotificationsModalViewController.m
//  Tackle
//
//  Created by Scott Bader on 1/30/16.
//  Copyright © 2016 Melody Road. All rights reserved.
//

#import "MRNotificationsModalViewController.h"

#import "Task.h"
#import "MRNotificationsTaskListViewController.h"
#import "MRPersistenceController.h"

@interface MRNotificationsModalViewController () <MRNotificationsTaskListDelegate>

@property (nonatomic) MRPersistenceController *persistenceController;
@property (nonatomic) MRNotificationsTaskListViewController *taskListViewController;
@property (nonatomic) UIView *contentView;

@end

@implementation MRNotificationsModalViewController

- (instancetype)initWithPersistenceController:(MRPersistenceController *)persistenceController {
    self = [super init];

    if (self) {
        _persistenceController = persistenceController;
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor clearColor];

    self.view.translatesAutoresizingMaskIntoConstraints = NO;

    self.contentView = [[UIView alloc] init];
    self.contentView.backgroundColor = [UIColor offWhiteBackgroundColor];
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.contentView];

    [self.contentView addConstraint:[self.contentView.widthAnchor constraintLessThanOrEqualToConstant:355.0]];
    [self.contentView addConstraint:[self.contentView.widthAnchor constraintGreaterThanOrEqualToConstant:320.0]];
    [self.view addConstraint:[self.contentView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor]];

    NSLayoutConstraint *leadingConstraint = [self.contentView.leadingAnchor constraintGreaterThanOrEqualToAnchor:self.view.leadingAnchor constant:10.0];
    leadingConstraint.priority = UILayoutPriorityDefaultHigh;
    NSLayoutConstraint *trailingConstraint = [self.contentView.trailingAnchor constraintGreaterThanOrEqualToAnchor:self.view.trailingAnchor constant:-10.0];
    trailingConstraint.priority = UILayoutPriorityDefaultHigh;
    [self.view addConstraint:leadingConstraint];
    [self.view addConstraint:trailingConstraint];
    [self.contentView topConstraintMatchesSuperviewWithConstant:0.0];
    [self.contentView bottomConstraintMatchesSuperviewWithConstant:-10.0];

    [self.contentView needsUpdateConstraints];

    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeSystem];
    doneButton.translatesAutoresizingMaskIntoConstraints = NO;
    [doneButton setTitle:NSLocalizedString(@"Notification Done Button", nil) forState:UIControlStateNormal];
    doneButton.titleLabel.font = [UIFont fontForModalDoneButton];
    [doneButton addTarget:self action:@selector(doneButtonWasTapped:) forControlEvents:UIControlEventTouchUpInside];
    doneButton.backgroundColor = [UIColor offWhiteBackgroundColor];
    doneButton.contentEdgeInsets = UIEdgeInsetsMake(10.0, 0.0, 10.0, 0.0);
    [doneButton setBackgroundImage:[UIImage imageWithColor:[UIColor offWhiteBackgroundColor]] forState:UIControlStateNormal];
    [doneButton setBackgroundImage:[UIImage imageWithColor:[UIColor darkenedOffWhiteBackgroundColor]] forState:UIControlStateHighlighted];

    [self.contentView addSubview:doneButton];

    self.taskListViewController = [[MRNotificationsTaskListViewController alloc] initWithPersistenceController:self.persistenceController];
    self.taskListViewController.notificationsTaskListDelegate = self;
    [self.contentView addSubview:self.taskListViewController.view];

    [self.taskListViewController.view topConstraintMatchesSuperviewWithConstant:10.0];
    [self.taskListViewController.view leadingConstraintMatchesSuperviewWithConstant:0.0];
    [self.taskListViewController.view trailingConstraintMatchesSuperviewWithConstant:0.0];
    [doneButton topConstraintBelowView:self.taskListViewController.view];

    [doneButton horizontalConstraintsMatchSuperview];
    [doneButton bottomConstraintMatchesSuperview];
}

- (void)displayTask:(Task *)task {
    [self.taskListViewController displayTask:task];
}

- (void)doneButtonWasTapped:(id)sender {
    [self mr_dismissViewControllerModallyAnimated:YES completion:nil];
}

- (void)addTenMinutesForTask:(Task *)task {
    task.dueDate = [[NSCalendar currentCalendar] dateByAddingUnit:NSCalendarUnitMinute
                                                            value:10
                                                           toDate:task.dueDate
                                                          options:0];

    [self.taskAlertingDelegate editedAlertedTask:task];
}

- (void)addOneHourForTask:(Task *)task {
    task.dueDate = [[NSCalendar currentCalendar] dateByAddingUnit:NSCalendarUnitHour
                                                            value:1
                                                           toDate:task.dueDate
                                                          options:0];

    [self.taskAlertingDelegate editedAlertedTask:task];
}

- (void)addOneDayForTask:(Task *)task {
    task.dueDate = [[NSCalendar currentCalendar] dateByAddingUnit:NSCalendarUnitDay
                                                            value:1
                                                           toDate:task.dueDate
                                                          options:0];

    [self.taskAlertingDelegate editedAlertedTask:task];
}

- (void)completedTask:(Task *)task {
    [self.taskAlertingDelegate completedAlertedTask:task];
}

@end
