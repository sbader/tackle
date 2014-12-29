//
//  MRTaskTableViewController.m
//  Tackle
//
//  Created by Scott Bader on 12/27/14.
//  Copyright (c) 2014 Melody Road. All rights reserved.
//

#import "MRTaskTableViewController.h"

#import "Task.h"
#import "MRTaskTableViewCell.h"

@interface MRTaskTableViewController () <NSFetchedResultsControllerDelegate>

@property (nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic) MRTaskTableViewCell *prototypeCell;

@end

static NSString * const taskCellReuseIdentifier = @"TaskCell";

@implementation MRTaskTableViewController

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    self = [super init];

    if (self) {
        self.managedObjectContext = managedObjectContext;
        [self.tableView registerClass:[MRTaskTableViewCell class] forCellReuseIdentifier:taskCellReuseIdentifier];
        self.view.translatesAutoresizingMaskIntoConstraints = NO;
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.separatorColor = [UIColor grayBorderColor];
        self.tableView.separatorInset = UIEdgeInsetsZero;
        self.tableView.allowsMultipleSelectionDuringEditing = NO;
        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }

    return self;
}

- (void)updateCell:(MRTaskTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Task *task = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = task.text;
    cell.detailTextLabel.text = task.dueDate.tackleString;
}

- (MRTaskTableViewCell *)prototypeCell {
    if (!_prototypeCell) {
        _prototypeCell = [self.tableView dequeueReusableCellWithIdentifier:taskCellReuseIdentifier];
    }

    return _prototypeCell;
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Task" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchBatchSize:20];

    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dueDate" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];

    [fetchRequest setSortDescriptors:sortDescriptors];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"isDone == NO"]];

    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                                managedObjectContext:self.managedObjectContext
                                                                                                  sectionNameKeyPath:nil
                                                                                                           cacheName:nil];

    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;

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
    [self.taskEditingDelegate editTask:task];
}

@end
