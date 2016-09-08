//
//  MRTaskNotificationsTableViewController.m
//  Tackle
//
//  Created by Scott Bader on 2/6/16.
//  Copyright © 2016 Melody Road. All rights reserved.
//

#import "MRTaskNotificationsTableViewController.h"


#import "Task.h"
#import "MRTaskNotificationTableViewCell.h"
#import "MRPersistenceController.h"
#import "MRNotificationProvider.h"
#import "MRHeartbeat.h"
#import "MRTimer.h"

@interface MRTaskNotificationsTableViewController () <NSFetchedResultsControllerDelegate, MRTaskNotificationTableViewCellDelegate>

@property (nonatomic) MRPersistenceController *persistenceController;
@property (nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic) NSLayoutConstraint *heightConstraint;
@property (nonatomic) MRTimer *timer;

@end

static NSString * const notificationTasksCellReuseIdentifier = @"NotificationTaskCell";

@implementation MRTaskNotificationsTableViewController

- (instancetype)initWithPersistenceController:(MRPersistenceController *)persistenceController {
    self = [super init];

    if (self) {
        _persistenceController = persistenceController;
    }

    return self;
}

- (void)attachObservers {
    self.timer = [[MRTimer alloc] initWithStartDate:[NSDate date] interval:1 repeatedBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self heartDidBeat];
        });
    }];
    [self.timer startTimer];
}

- (void)detachObservers {
    if (self.timer) {
        [self.timer cancel];
        self.timer = nil;
    }
}

- (void)dealloc {
    [self detachObservers];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.allowsSelection = NO;

    [self.tableView registerClass:[MRTaskNotificationTableViewCell class] forCellReuseIdentifier:notificationTasksCellReuseIdentifier];
    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.backgroundColor = [UIColor offWhiteBackgroundColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorColor = [UIColor grayBackgroundColor];
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.allowsSelection = NO;
    self.tableView.scrollEnabled = YES;
    self.tableView.alwaysBounceVertical = NO;

    [self.view applyTackleLayerDisplay];

    self.heightConstraint = [NSLayoutConstraint constraintWithItem:self.view
                                                         attribute:NSLayoutAttributeHeight
                                                         relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                            toItem:nil
                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                        multiplier:1.0
                                                          constant:0.0];

    self.heightConstraint.priority = UILayoutPriorityDefaultLow;
    [self.view addConstraint:self.heightConstraint];
    [self attachObservers];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];


    [self adjustHeightOfTableView];
}

- (void)updateCell:(MRTaskNotificationTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Task *task = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [cell setTitle:task.title];
    [cell setDetail:task.dueDate.tackleString];
    cell.taskCellDelegate = self;
}

- (void)adjustHeightOfTableView {
    CGFloat height = self.tableView.contentSize.height;
    CGFloat maxHeight = self.tableView.superview.frame.size.height - self.tableView.frame.origin.y;

    if (height > maxHeight) {
        height = maxHeight;
    }

    [UIView animateWithDuration:0.25 animations:^{
        self.heightConstraint.constant = height;
        [self.view setNeedsUpdateConstraints];
    }];
}

#pragma mark - Fetched results controller

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }


    NSFetchRequest *fetchRequest = [Task passedOpenTasksFetchRequestWithManagedObjectContext:self.persistenceController.managedObjectContext];
    [fetchRequest setSortDescriptors:@[[[NSSortDescriptor alloc] initWithKey:@"dueDate" ascending:YES]]];

    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                               managedObjectContext:self.persistenceController.managedObjectContext
                                                                                                 sectionNameKeyPath:nil
                                                                                                          cacheName:nil];

    fetchedResultsController.delegate = self;
    self.fetchedResultsController = fetchedResultsController;

    NSError *error = nil;
    [self.fetchedResultsController performFetch:&error];
    NSAssert(error == nil, @"Failed to execute fetch %@", error);

    return _fetchedResultsController;
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;

        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;

        case NSFetchedResultsChangeUpdate:
            [self updateCell:(MRTaskNotificationTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;

        case NSFetchedResultsChangeMove:
            [self.tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
            [self updateCell:(MRTaskNotificationTableViewCell *)[self.tableView cellForRowAtIndexPath:newIndexPath] atIndexPath:newIndexPath];
            break;
    }
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return sectionInfo.numberOfObjects;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MRTaskNotificationTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:notificationTasksCellReuseIdentifier forIndexPath:indexPath];
    [self updateCell:cell atIndexPath:indexPath];

    return cell;
}

#pragma mark - Table View Delegate

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

#pragma - Task Cell Delegate

- (void)addTenMinutesButtonWasTappedWithCell:(MRTaskNotificationTableViewCell *)cell {
    Task *task = [self.fetchedResultsController objectAtIndexPath:[self.tableView indexPathForCell:cell]];
    [self.taskNotificationTableViewControllerDelegate addTenMinutesForTask:task];
}

- (void)addOneHourButtonWasTappedWithCell:(MRTaskNotificationTableViewCell *)cell {
    Task *task = [self.fetchedResultsController objectAtIndexPath:[self.tableView indexPathForCell:cell]];
    [self.taskNotificationTableViewControllerDelegate addOneHourForTask:task];
}

- (void)addOneDayButtonWasTappedWithCell:(MRTaskNotificationTableViewCell *)cell {
    Task *task = [self.fetchedResultsController objectAtIndexPath:[self.tableView indexPathForCell:cell]];
    [self.taskNotificationTableViewControllerDelegate addOneDayForTask:task];
}

- (void)doneButtonWasTappedWithCell:(MRTaskNotificationTableViewCell *)cell {
    Task *task = [self.fetchedResultsController objectAtIndexPath:[self.tableView indexPathForCell:cell]];
    [self.taskNotificationTableViewControllerDelegate completedTask:task];
}

- (void)heartDidBeat {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self.tableView visibleCells] enumerateObjectsUsingBlock:^(MRTaskNotificationTableViewCell *cell, NSUInteger idx, BOOL *stop) {
            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
            [self updateCell:cell atIndexPath:indexPath];
        }];

    });
}

- (void)displayTask:(Task *)task {
    NSIndexPath *indexPath = [self.fetchedResultsController indexPathForObject:task];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];

    if (cell) {
        UIColor *initialColor = cell.contentView.backgroundColor;

        [UIView animateWithDuration:0.2 animations:^{
            cell.backgroundColor = [[UIColor plumTintColor] colorWithAlphaComponent:0.65];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 delay:0.2 options:0 animations:^{
                cell.backgroundColor = initialColor;
            } completion:nil];
        }];
    }
}
@end
