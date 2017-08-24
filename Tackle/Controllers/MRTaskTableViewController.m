//
//  MRTaskTableViewController.m
//  Tackle
//
//  Created by Scott Bader on 12/27/14.
//  Copyright (c) 2014 Melody Road. All rights reserved.
//

#import "MRTaskTableViewController.h"

#import "Task.h"
#import "MRHeartbeat.h"
#import "MRTaskTableViewCell.h"
#import "MRTimer.h"

@interface MRTaskTableViewController () <NSFetchedResultsControllerDelegate>

@property (nonatomic) MRPersistenceController *persistenceController;
@property (nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic) MRTimer *timer;

@end

static NSString * const taskCellReuseIdentifier = @"TaskCell";

@implementation MRTaskTableViewController

- (instancetype)initWithPersistenceController:(MRPersistenceController *)persistenceController {
    self = [super init];

    if (self) {
        _persistenceController = persistenceController;
        [self.tableView registerClass:[MRTaskTableViewCell class] forCellReuseIdentifier:taskCellReuseIdentifier];
        self.view.translatesAutoresizingMaskIntoConstraints = NO;
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.separatorColor = [UIColor grayBorderColor];
        self.tableView.separatorInset = UIEdgeInsetsZero;
        self.tableView.allowsMultipleSelectionDuringEditing = NO;
        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

        [self attachObservers];
    }

    return self;
}

- (void)dealloc {
    [self detachObservers];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)refreshTasks {
    [self.tableView reloadData];
}

- (void)updateCell:(MRTaskTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Task *task = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = task.title;
    cell.detailTextLabel.text = task.dueDate.tackleString;
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

- (void)heartDidBeat {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self.tableView visibleCells] enumerateObjectsUsingBlock:^(MRTaskTableViewCell *cell, NSUInteger idx, BOOL *stop) {
            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
            [self updateCell:cell atIndexPath:indexPath];
        }];

    });
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }

    NSFetchRequest *fetchRequest = [Task openTasksFetchRequestWithManagedObjectContext:self.persistenceController.managedObjectContext];
    [fetchRequest setFetchBatchSize:20];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dueDate" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];

    NSFetchedResultsController *frc = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                         managedObjectContext:self.persistenceController.managedObjectContext
                                                                           sectionNameKeyPath:nil
                                                                                    cacheName:nil];

    frc.delegate = self;
    self.fetchedResultsController = frc;

    NSError *error = nil;
    [self.fetchedResultsController performFetch:&error];
    NSAssert(error == nil, @"Failed to execute fetch %@", error);

    return _fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
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
            [self updateCell:(MRTaskTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;

        case NSFetchedResultsChangeMove:
            [self.tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
            [self updateCell:(MRTaskTableViewCell *)[self.tableView cellForRowAtIndexPath:newIndexPath] atIndexPath:newIndexPath];
            break;
    }
}

#pragma mark - Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return sectionInfo.numberOfObjects;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MRTaskTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:taskCellReuseIdentifier forIndexPath:indexPath];
    [self updateCell:cell atIndexPath:indexPath];

    return cell;
}

#pragma mark - Table View Delegate

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Task *task = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self.taskDelegate selectedTask:task];
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:NSLocalizedString(@"Task Row Done Action", nil) handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        Task *task = [self.fetchedResultsController objectAtIndexPath:indexPath];

        if ([self.taskDelegate respondsToSelector:@selector(completedTask:)]) {
            [self.taskDelegate completedTask:task];
        }
    }];

    return @[action];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
}

@end
