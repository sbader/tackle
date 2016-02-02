//
//  MRNotificationTasksTableViewController.m
//  Tackle
//
//  Created by Scott Bader on 1/30/16.
//  Copyright © 2016 Melody Road. All rights reserved.
//

#import "MRNotificationTasksTableViewController.h"

#import "Task.h"
#import "MRNotificationTaskTableViewCell.h"
#import "MRPersistenceController.h"
#import "MRNotificationProvider.h"
#import "MRHeartbeat.h"

@interface MRNotificationTasksTableViewController () <NSFetchedResultsControllerDelegate, MRNotificationTaskTableViewCellDelegate>

@property (nonatomic) MRPersistenceController *persistenceController;
@property (nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic) NSLayoutConstraint *heightConstraint;

@end

static NSString * const notificationTasksCellReuseIdentifier = @"NotificationTaskCell";

@implementation MRNotificationTasksTableViewController

- (instancetype)initWithPersistenceController:(MRPersistenceController *)persistenceController {
    self = [super init];

    if (self) {
        _persistenceController = persistenceController;
    }

    return self;
}

- (void)attachObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(heartDidBeat:) name:[MRHeartbeat slowHeartbeatId] object:nil];
}

- (void)detachObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:[MRHeartbeat slowHeartbeatId] object:nil];
}

- (void)dealloc {
    [self detachObservers];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.allowsSelection = NO;

    [self.tableView registerClass:[MRNotificationTaskTableViewCell class] forCellReuseIdentifier:notificationTasksCellReuseIdentifier];
    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.allowsSelection = NO;
    self.tableView.scrollEnabled = NO;

    [self observeValueForKeyPath:@"contentSize" ofObject:self.tableView change:0 context:nil];
    self.heightConstraint = [NSLayoutConstraint constraintWithItem:self.view
                                                         attribute:NSLayoutAttributeHeight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:nil
                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                        multiplier:1.0
                                                          constant:0];

    self.heightConstraint.priority = UILayoutPriorityDefaultLow;

    [self.view addConstraint:self.heightConstraint];
    [self updateTableContentSize];
    [self attachObservers];
}

- (void)updateTableContentSize {
    [self.tableView layoutIfNeeded];
    self.heightConstraint.constant = self.tableView.contentSize.height;
}

- (void)updateCell:(MRNotificationTaskTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Task *task = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = task.title;
    cell.detailTextLabel.text = task.dueDate.tackleString;
    cell.taskCellDelegate = self;
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Task" inManagedObjectContext:self.persistenceController.managedObjectContext];
    [fetchRequest setEntity:entity];

    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dueDate" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];

    [fetchRequest setSortDescriptors:sortDescriptors];
//    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"isDone == NO AND dueDate < %@", [NSDate date]]];
    [fetchRequest setFetchLimit:5];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"isDone == NO", [NSDate date]]];

    NSFetchedResultsController *frc = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                          managedObjectContext:self.persistenceController.managedObjectContext
                                                                            sectionNameKeyPath:nil
                                                                                     cacheName:nil];

    frc.delegate = self;
    self.fetchedResultsController = frc;

    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }

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
            [self updateCell:(MRNotificationTaskTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;

        case NSFetchedResultsChangeMove:
            [self.tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
            [self updateCell:(MRNotificationTaskTableViewCell *)[self.tableView cellForRowAtIndexPath:newIndexPath] atIndexPath:newIndexPath];
            break;
    }
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return sectionInfo.numberOfObjects;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MRNotificationTaskTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:notificationTasksCellReuseIdentifier forIndexPath:indexPath];
    [self updateCell:cell atIndexPath:indexPath];

    return cell;
}

#pragma mark - Table View Delegate

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    [self updateTableContentSize];
}

#pragma - Task Cell Delegate

- (void)addTenMinutesButtonWasTappedWithCell:(MRNotificationTaskTableViewCell *)cell {
    Task *task = [self.fetchedResultsController objectAtIndexPath:[self.tableView indexPathForCell:cell]];
    [self.notificationTasksTableViewDelegate addTenMinutesForTask:task];
}

- (void)addOneHourButtonWasTappedWithCell:(MRNotificationTaskTableViewCell *)cell {
    Task *task = [self.fetchedResultsController objectAtIndexPath:[self.tableView indexPathForCell:cell]];
    [self.notificationTasksTableViewDelegate addOneHourForTask:task];
}

- (void)addOneDayButtonWasTappedWithCell:(MRNotificationTaskTableViewCell *)cell {
    Task *task = [self.fetchedResultsController objectAtIndexPath:[self.tableView indexPathForCell:cell]];
    [self.notificationTasksTableViewDelegate addOneDayForTask:task];
}

- (void)doneButtonWasTappedWithCell:(MRNotificationTaskTableViewCell *)cell {
    Task *task = [self.fetchedResultsController objectAtIndexPath:[self.tableView indexPathForCell:cell]];
    [self.notificationTasksTableViewDelegate completedTask:task];
}

- (void)heartDidBeat:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self.tableView visibleCells] enumerateObjectsUsingBlock:^(MRNotificationTaskTableViewCell *cell, NSUInteger idx, BOOL *stop) {
            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
            [self updateCell:cell atIndexPath:indexPath];
        }];

    });
}

- (void)displayTask:(Task *)task {
    NSIndexPath *indexPath = [self.fetchedResultsController indexPathForObject:task];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
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
