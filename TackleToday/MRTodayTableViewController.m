//
//  MRTodayTableViewController.m
//  Tackle
//
//  Created by Scott Bader on 1/8/15.
//  Copyright (c) 2015 Melody Road. All rights reserved.
//

#import "MRTodayTableViewController.h"

#import <CoreData/CoreData.h>

#import "Task.h"
#import "MRTodayTableViewCell.h"
#import "NSDate+TackleAdditions.h"
#import "MRReadOnlyPersistenceController.h"

NSString *todayViewControllerContentCellIdentifier = @"todayViewCell";

@interface MRTodayTableViewController () <NSFetchedResultsControllerDelegate>

@property (nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic) NSLayoutConstraint *heightConstraint;
@property (nonatomic) MRReadOnlyPersistenceController *persistenceController;

@end

@implementation MRTodayTableViewController

- (instancetype)initWithPersistenceController:(MRReadOnlyPersistenceController *)persistenceController {
    self = [super initWithStyle:UITableViewStylePlain];

    if (self) {
        _persistenceController = persistenceController;
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView registerClass:[MRTodayTableViewCell class] forCellReuseIdentifier:todayViewControllerContentCellIdentifier];

    self.tableView.separatorInset = UIEdgeInsetsZero;
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

- (void)updateTableContentSize {
    [self.tableView layoutIfNeeded];
    self.heightConstraint.constant = self.tableView.contentSize.height;
}

- (void)updateCell:(MRTodayTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Task *task = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.taskLabel.text = task.title;
    cell.timeLabel.text = task.dueDate.tackleString;
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Task"
                                              inManagedObjectContext:self.persistenceController.managedObjectContext];

    [fetchRequest setEntity:entity];

    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dueDate" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];

    [fetchRequest setSortDescriptors:sortDescriptors];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"isDone == NO"]];

    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                                managedObjectContext:self.persistenceController.managedObjectContext
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
    MRTodayTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:todayViewControllerContentCellIdentifier forIndexPath:indexPath];
    [self updateCell:cell atIndexPath:indexPath];

    return cell;
}

#pragma mark - Table View Delegate

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Task *task = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSData *data = [task.objectID.URIRepresentation.absoluteString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64ObjectID = [data base64EncodedStringWithOptions:0];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tackle://task/%@", base64ObjectID]];

    [self.extensionContext openURL:url completionHandler:nil];

    return nil;
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    [self updateTableContentSize];
}


@end
