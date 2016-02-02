//
//  MRNotificationsTaskListViewController.m
//  Tackle
//
//  Created by Scott Bader on 2/2/16.
//  Copyright © 2016 Melody Road. All rights reserved.
//

#import "MRNotificationsTaskListViewController.h"
#import "MRPersistenceController.h"

#import "Task.h"
#import "MRNotificationTaskView.h"
#import "MRHeartbeat.h"

@interface MRNotificationsTaskListViewController () <MRNotificationTaskViewDelegate>

@property (nonatomic) MRPersistenceController *persistenceController;
@property (nonatomic) NSMutableArray<Task *> *tasks;
@property (nonatomic) UIStackView *containerView;
@property (nonatomic) NSMapTable *tasksByViewMap;
@property (nonatomic) NSMapTable *viewsByTaskMap;

@end


@implementation MRNotificationsTaskListViewController

- (instancetype)initWithPersistenceController:(MRPersistenceController *)persistenceController {
    self = [super init];

    if (self) {
        _persistenceController = persistenceController;
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.translatesAutoresizingMaskIntoConstraints = NO;

    self.tasksByViewMap = [NSMapTable weakToWeakObjectsMapTable];
    self.viewsByTaskMap = [NSMapTable weakToWeakObjectsMapTable];

    self.containerView = [[UIStackView alloc] init];
    self.containerView.translatesAutoresizingMaskIntoConstraints = NO;
    self.containerView.axis = UILayoutConstraintAxisVertical;
    self.containerView.distribution = UIStackViewDistributionEqualCentering;
    self.containerView.alignment = UIStackViewAlignmentFill;

    [self.view addSubview:self.containerView];

    [self.containerView constraintsMatchSuperview];
    [self updateViews];

    [self attachObservers];
}

- (void)dealloc {
    [self removeObservers];
}

- (void)updateTasks {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Task"
                                              inManagedObjectContext:self.persistenceController.managedObjectContext];
    [fetchRequest setEntity:entity];

    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dueDate" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];

    [fetchRequest setSortDescriptors:sortDescriptors];
    //    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"isDone == NO AND dueDate < %@", [NSDate date]]];
    [fetchRequest setFetchLimit:5];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"isDone == NO", [NSDate date]]];

    NSError *requestError = nil;

    self.tasks = [[self.persistenceController.managedObjectContext executeFetchRequest:fetchRequest error:&requestError] mutableCopy];
}

- (void)updateViews {
    [self updateTasks];

    for (Task *task in self.tasks) {
        MRNotificationTaskView *view = [[MRNotificationTaskView alloc] init];
        view.notificationTaskViewDelegate = self;

        [self updateView:view withTask:task];

        [self.containerView addArrangedSubview:view];
        [self.tasksByViewMap setObject:task forKey:view];
        [self.viewsByTaskMap setObject:view forKey:task];
    }
}

- (void)attachObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(managedObjectContextDidChange:)
                                                 name:NSManagedObjectContextObjectsDidChangeNotification
                                               object:self.persistenceController.managedObjectContext];

   [[NSNotificationCenter defaultCenter] addObserver:self
                                            selector:@selector(heartDidBeat:)
                                                name:[MRHeartbeat slowHeartbeatId]
                                              object:nil];
}

- (void)removeObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)managedObjectContextDidChange:(NSNotification *)notification {
    NSSet *updated = notification.userInfo[NSUpdatedObjectsKey];

    for (Task *task in updated) {
        MRNotificationTaskView *view = [self.viewsByTaskMap objectForKey:task];

        if (task.isDone) {
            if (self.containerView.arrangedSubviews.count > 1) {
                [UIView animateWithDuration:0.2 animations:^{
                    view.hidden = YES;
                } completion:^(BOOL finished) {
                    [self.containerView removeArrangedSubview:view];
                }];
            }
            else {
                view.hidden = YES;
                [self.containerView removeArrangedSubview:view];
            }

            [self.tasks removeObject:task];
        }
        else {
            [self updateView:view withTask:task];
        }
    }
}

- (Task *)taskForView:(MRNotificationTaskView *)view {
    return [self.tasksByViewMap objectForKey:view];
}

- (void)updateView:(MRNotificationTaskView *)view withTask:(Task *)task {
    view.titleLabel.text = task.title;
    view.detailLabel.text = task.dueDate.tackleString;
}

#pragma - Task View Delegate

- (void)addTenMinutesButtonWasTappedWithView:(MRNotificationTaskView *)view {
    Task *task = [self taskForView:view];
    [self.notificationsTaskListDelegate addTenMinutesForTask:task];
}

- (void)addOneHourButtonWasTappedWithView:(MRNotificationTaskView *)view {
    Task *task = [self taskForView:view];
    [self.notificationsTaskListDelegate addOneHourForTask:task];
}

- (void)addOneDayButtonWasTappedWithView:(MRNotificationTaskView *)view {
    Task *task = [self taskForView:view];
    [self.notificationsTaskListDelegate addOneDayForTask:task];
}

- (void)doneButtonWasTappedWithView:(MRNotificationTaskView *)view {
    Task *task = [self taskForView:view];
    [self.notificationsTaskListDelegate completedTask:task];
}

- (void)heartDidBeat:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        for (MRNotificationTaskView *view in self.containerView.arrangedSubviews) {
            [self updateView:view withTask:[self taskForView:view]];
        }
    });
}

- (void)displayTask:(Task *)task {
    MRNotificationTaskView *view = [self.viewsByTaskMap objectForKey:task];
    UIColor *initialColor = view.backgroundColor;

    [UIView animateWithDuration:0.2 animations:^{
        view.backgroundColor = [[UIColor plumTintColor] colorWithAlphaComponent:0.65];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 delay:0.2 options:0 animations:^{
            view.backgroundColor = initialColor;
        } completion:nil];
    }];
}

@end
