//
//  MRNotificationsModalViewController.m
//  Tackle
//
//  Created by Scott Bader on 1/30/16.
//  Copyright © 2016 Melody Road. All rights reserved.
//

#import "MRNotificationsModalViewController.h"

#import "Task.h"
#import "MRNotificationTasksTableViewController.h"
#import "MRPersistenceController.h"

@interface MRNotificationsModalViewController () <MRNotificationTasksTableViewDelegate>

@property (nonatomic) MRPersistenceController *persistenceController;
@property (nonatomic) MRNotificationTasksTableViewController *tasksTableViewController;
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

    NSLayoutConstraint *widthConstraint = [self.contentView.widthAnchor constraintLessThanOrEqualToConstant:355.0];
//    widthConstraint.priority = UILayoutPriorityDefaultHigh;

    [self.contentView addConstraint:widthConstraint];
    [self.view addConstraint:[self.contentView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor]];

    NSLayoutConstraint *leadingConstraint = [self.contentView.leadingAnchor constraintGreaterThanOrEqualToAnchor:self.view.leadingAnchor constant:10.0];
    leadingConstraint.priority = UILayoutPriorityDefaultHigh;
    NSLayoutConstraint *trailingConstraint = [self.contentView.trailingAnchor constraintGreaterThanOrEqualToAnchor:self.view.trailingAnchor constant:-10.0];
    trailingConstraint.priority = UILayoutPriorityDefaultHigh;
    [self.view addConstraint:leadingConstraint];
    [self.view addConstraint:trailingConstraint];
    [self.contentView topConstraintMatchesSuperviewWithConstant:0.0];
    [self.contentView bottomConstraintMatchesSuperviewWithConstant:-10.0];


//    UILabel *titleLabel = [[UILabel alloc] init];
//    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
//    titleLabel.text = NSLocalizedString(@"Time’s Up", nil);
//    titleLabel.font = [UIFont fontForModalTitleLabel];
//    titleLabel.textColor = [UIColor grayTextColor];
//    titleLabel.textAlignment = NSTextAlignmentLeft;
//    [self.contentView addSubview:titleLabel];
//
//    [titleLabel leadingConstraintMatchesSuperviewWithConstant:20.0];
//    [titleLabel topConstraintMatchesSuperviewWithConstant:20.0];
//    [titleLabel trailingConstraintMatchesSuperviewWithConstant:-20.0];

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

//    [doneButton topConstraintMatchesSuperviewWithConstant:20.0];
//    [doneButton bottomConstraintMatchesView:titleLabel withConstant:0.0];
//    [self.contentView addConstraint:[titleLabel.trailingAnchor constraintEqualToAnchor:doneButton.leadingAnchor constant:-20.0]];
//    [self.contentView addConstraint:[doneButton.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-20.0]];

    self.tasksTableViewController = [[MRNotificationTasksTableViewController alloc] initWithPersistenceController:self.persistenceController];
    self.tasksTableViewController.notificationTasksTableViewDelegate = self;
    [self.contentView addSubview:self.tasksTableViewController.view];

    [self.tasksTableViewController.view topConstraintMatchesSuperviewWithConstant:10.0];
    [self.tasksTableViewController.view leadingConstraintMatchesSuperviewWithConstant:0.0];
    [self.tasksTableViewController.view trailingConstraintMatchesSuperviewWithConstant:0.0];

    [doneButton topConstraintBelowView:self.tasksTableViewController.view];
    [doneButton horizontalConstraintsMatchSuperview];
    [doneButton bottomConstraintMatchesSuperview];
}

- (void)displayTask:(Task *)task {
    [self.tasksTableViewController displayTask:task];
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
