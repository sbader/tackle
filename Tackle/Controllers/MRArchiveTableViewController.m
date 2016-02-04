//
//  MRArchiveTableViewController.m
//  Tackle
//
//  Created by Scott Bader on 1/27/16.
//  Copyright © 2016 Melody Road. All rights reserved.
//

#import "MRArchiveTableViewController.h"

#import "Task.h"
#import "MRTaskTableViewCell.h"
#import "MRTaskArchiveTableViewCell.h"
#import "MRPersistenceController.h"
#import "MRArchiveTaskTableViewDelegate.h"
#import "MRFullDateFormatter.h"
#import "MRLongDateFormatter.h"
#import "MRTimeDateFormatter.h"


@interface MRArchiveTableViewController () <NSFetchedResultsControllerDelegate>

@property (nonatomic) MRPersistenceController *persistenceController;
@property (nonatomic) NSFetchedResultsController *fetchedResultsController;

@end

static NSString * const archiveTaskCellReuseIdentifier = @"ArchiveTaskCell";

@implementation MRArchiveTableViewController

- (instancetype)initWithPersistenceController:(MRPersistenceController *)persistenceController {
    self = [super init];

    if (self) {
        _persistenceController = persistenceController;
        [self.tableView registerClass:[MRTaskArchiveTableViewCell class] forCellReuseIdentifier:archiveTaskCellReuseIdentifier];
        self.view.translatesAutoresizingMaskIntoConstraints = NO;
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.separatorColor = [UIColor grayBorderColor];
        self.tableView.separatorInset = UIEdgeInsetsZero;
        self.tableView.allowsMultipleSelectionDuringEditing = NO;
        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        self.tableView.allowsSelection = NO;
    }

    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)updateCell:(MRTaskArchiveTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Task *task = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = task.title;

    NSString *dateString = [NSString stringWithFormat:NSLocalizedString(@"Archive Task Completed Format", nil), task.completedDate.tackleString];

    NSMutableAttributedString *attributedDateString = [[NSMutableAttributedString alloc] initWithString:dateString
                                                                                             attributes:@{
                                                                                                          NSFontAttributeName:[UIFont fontForArchivedTaskDate]
                                                                                                          }];
    [attributedDateString addAttribute:NSFontAttributeName
                                 value:[UIFont fontForArchivedTaskDateDescription]
                                 range:NSMakeRange(0, 10)];

    cell.detailTextLabel.attributedText = attributedDateString;
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }

    NSFetchRequest *fetchRequest = [Task archivedTasksFetchRequestWithManagedObjectContext:self.persistenceController.managedObjectContext];

    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"completedDate" ascending:NO];
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
            [self updateCell:(MRTaskArchiveTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;

        case NSFetchedResultsChangeMove:
            [self.tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
            [self updateCell:(MRTaskArchiveTableViewCell *)[self.tableView cellForRowAtIndexPath:newIndexPath] atIndexPath:newIndexPath];
            break;
    }
}

#pragma mark - Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return sectionInfo.numberOfObjects;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MRTaskArchiveTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:archiveTaskCellReuseIdentifier forIndexPath:indexPath];
    [self updateCell:cell atIndexPath:indexPath];

    return cell;
}

#pragma mark - Table View Delegate

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:NSLocalizedString(@"Archive Action Delete", nil) handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        Task *task = [self.fetchedResultsController objectAtIndexPath:indexPath];

        [self.tableView beginUpdates];

        [self.persistenceController.managedObjectContext deleteObject:task];

        [self.tableView endUpdates];
    }];

    UITableViewRowAction *recycleAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:NSLocalizedString(@"Archive Action Recycle", nil) handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        Task *task = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [self.archiveTaskDelegate selectedRecycledTitle:task.title];
    }];

    return @[deleteAction, recycleAction];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
}

@end
