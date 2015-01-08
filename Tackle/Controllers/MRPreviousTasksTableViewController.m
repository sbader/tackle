//
//  MRPreviousTasksTableViewController.m
//  Tackle
//
//  Created by Scott Bader on 1/4/15.
//  Copyright (c) 2015 Melody Road. All rights reserved.
//

#import "MRPreviousTasksTableViewController.h"

#import "Task.h"
#import "MRPreviousTaskTableViewCell.h"

@interface MRPreviousTasksTableViewController () <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>

@property (nonatomic) NSManagedObjectContext  *managedObjectContext;
@property (nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic) NSLayoutConstraint *heightConstraint;

@end

static NSString * const previousTaskCellReuseIdentifier = @"PreviousTaskCell";

@implementation MRPreviousTasksTableViewController

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    self = [super initWithStyle:UITableViewStylePlain];

    if (self) {
        self.managedObjectContext = managedObjectContext;
        [self.tableView registerClass:[MRPreviousTaskTableViewCell class] forCellReuseIdentifier:previousTaskCellReuseIdentifier];
        self.view.translatesAutoresizingMaskIntoConstraints = NO;
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.separatorColor = [UIColor grayBorderColor];
        self.tableView.allowsMultipleSelectionDuringEditing = NO;
        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

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
    }

    return self;
}

- (void)updateTableContentSize {
    [self.tableView layoutIfNeeded];
    self.heightConstraint.constant = self.tableView.contentSize.height;
}

- (void)updateCell:(MRPreviousTaskTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = dict[@"title"];
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Task" inManagedObjectContext:self.managedObjectContext];
    fetchRequest.entity = entity;
    fetchRequest.propertiesToFetch = @[
                                       [[entity propertiesByName] objectForKey:@"title"]
                                       ];
    fetchRequest.returnsDistinctResults = YES;
    fetchRequest.resultType = NSDictionaryResultType;
    fetchRequest.fetchLimit = 5;

    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"completedDate" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];

    [fetchRequest setSortDescriptors:sortDescriptors];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"isDone == YES"]];

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

#pragma mark - Table View Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return sectionInfo.numberOfObjects;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MRPreviousTaskTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:previousTaskCellReuseIdentifier forIndexPath:indexPath];
    [self updateCell:cell atIndexPath:indexPath];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([self tableView:tableView numberOfRowsInSection:section] > 0) {
        return 25.0;
    }
    else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view;
    if ([self tableView:tableView numberOfRowsInSection:section] > 0) {
        view = [[UIView alloc] init];
        UILabel *label = [[UILabel alloc] init];
        label.translatesAutoresizingMaskIntoConstraints = NO;
        label.text = @"Use Previous Task";
        label.font = [UIFont fontForTableViewSectionHeader];
        [view addSubview:label];

        [label leadingConstraintMatchesSuperviewWithConstant:20.0];
        [label trailingConstraintMatchesSuperview];
        [label verticalCenterConstraintMatchesSuperview];

        UIView *separator = [[UIView alloc] init];
        separator.translatesAutoresizingMaskIntoConstraints = NO;
        separator.backgroundColor = [UIColor grayBorderColor];
        [view addSubview:separator];

        [separator bottomConstraintMatchesSuperview];
        [separator horizontalConstraintsMatchSuperview];
        [separator staticHeightConstraint:0.5];
    }

    return view;
}

#pragma mark - Table View Delegate

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *taskDict = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self.taskDelegate selectedPreviousTaskTitle:taskDict[@"title"]];

    return nil;
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    [self updateTableContentSize];
}

@end
