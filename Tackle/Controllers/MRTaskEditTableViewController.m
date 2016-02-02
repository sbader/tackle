//
//  MRTaskEditTableViewController.m
//  Tackle
//
//  Created by Scott Bader on 12/28/14.
//  Copyright (c) 2014 Melody Road. All rights reserved.
//

#import "MRTaskEditTableViewController.h"

#import "MRPreviousTaskTableViewCell.h"
#import "MRAddTimeTableViewCell.h"
#import "PaintCodeStyleKit.h"
#import "Task.h"

static NSString *addTimeCellReuseIdentifier = @"AddTimeCell";
static NSString *previousTaskCellReuseIdentifier = @"PreviousTaskCell";

@interface MRTaskEditTableViewController () <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>

@property (nonatomic) NSArray *timeIntervals;
@property (nonatomic) BOOL doneButtonEnabled;
@property (nonatomic) BOOL previousTasksEnabled;
@property (nonatomic) NSDictionary *sections;
@property (nonatomic) NSLayoutConstraint *heightConstraint;

@property (nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic) NSFetchedResultsController *fetchedResultsController;

@end

@implementation MRTaskEditTableViewController

- (instancetype)initWithDoneButtonEnabled:(BOOL)doneButtonEnabled previousTasksEnabled:(BOOL)previousTasksEnabled managedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    self = [super initWithStyle:UITableViewStyleGrouped];

    if (self) {
        self.managedObjectContext = managedObjectContext;
        self.doneButtonEnabled = doneButtonEnabled;
        self.previousTasksEnabled = previousTasksEnabled;
    }

    return self;
}

- (void)dealloc {
    [self removeObservers];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.timeIntervals = @[
                           [MRTimeInterval timeIntervalWithName:NSLocalizedString(@"Ten Minutes", nil) icon:[PaintCodeStyleKit imageOfStopwatchColored] unit:NSCalendarUnitMinute interval:10],
                           [MRTimeInterval timeIntervalWithName:NSLocalizedString(@"an Hour", nil) icon:[PaintCodeStyleKit imageOfHourglassColored]  unit:NSCalendarUnitHour interval:1],
                           [MRTimeInterval timeIntervalWithName:NSLocalizedString(@"a Day", nil) icon:[PaintCodeStyleKit imageOfCalanderColored]  unit:NSCalendarUnitDay interval:1],
                           ];

    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor lightGrayFormBackgroundColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorColor = [UIColor grayBorderColor];
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    self.tableView.cellLayoutMarginsFollowReadableWidth = NO;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView registerClass:[MRAddTimeTableViewCell class] forCellReuseIdentifier:addTimeCellReuseIdentifier];
    [self.tableView registerClass:[MRPreviousTaskTableViewCell class] forCellReuseIdentifier:previousTaskCellReuseIdentifier];

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

- (void)attachObservers {
    [self addObserver:self.tableView forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeObservers {
    [self removeObserver:self.tableView forKeyPath:@"contentSize"];
}

- (void)updateTableContentSize {
    [self.tableView layoutIfNeeded];
    self.heightConstraint.constant = self.tableView.contentSize.height;
}

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }

    NSFetchRequest *fetchRequest = [Task archivedTasksFetchRequestWithManagedObjectContext:self.managedObjectContext];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"completedDate" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
    fetchRequest.propertiesToFetch = @[
                                       [[fetchRequest.entity propertiesByName] objectForKey:@"title"]
                                       ];

    fetchRequest.returnsDistinctResults = YES;

    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                                managedObjectContext:self.managedObjectContext
                                                                                                  sectionNameKeyPath:nil
                                                                                                           cacheName:nil];

    fetchedResultsController.delegate = self;
    self.fetchedResultsController = fetchedResultsController;

    NSError *error = nil;
    [self.fetchedResultsController performFetch:&error];
    NSAssert(error == nil, @"Failed to execute fetch %@", error);

    return _fetchedResultsController;
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.doneButtonEnabled && self.previousTasksEnabled) {
        return 3;
    }
    else if (self.doneButtonEnabled || self.previousTasksEnabled) {
        return 2;
    }

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self isDoneButtonSection:section]) {
        return 1;
    }
    else if ([self isPreviousTasksSection:section]) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][0];
        return sectionInfo.numberOfObjects;
    }

    return self.timeIntervals.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self isPreviousTasksSection:indexPath.section]) {
        MRPreviousTaskTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:previousTaskCellReuseIdentifier forIndexPath:indexPath];
        NSIndexPath *path = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
        Task *task = [self.fetchedResultsController objectAtIndexPath:path];
        cell.textLabel.text = task.title;
        return cell;
    }
    else if ([self isDoneButtonSection:indexPath.section]) {
        MRAddTimeTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:addTimeCellReuseIdentifier forIndexPath:indexPath];
        cell.textLabel.text = NSLocalizedString(@"Task Done Button Title", nil);
        cell.imageView.image = [PaintCodeStyleKit imageOfCheckmark];
        return cell;

    }
    else {
        MRAddTimeTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:addTimeCellReuseIdentifier forIndexPath:indexPath];
        MRTimeInterval *timeInterval = self.timeIntervals[indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Task Add Time Format", nil), timeInterval.name];
        cell.imageView.image = timeInterval.icon;

        return cell;
    }
}

#pragma mark - Table View Delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self isDoneButtonSection:indexPath.section]) {
        [self.delegate selectedDone];
    }
    else if ([self isTimeIntervalSection:indexPath.section]) {
        [self.delegate selectedTimeInterval:self.timeIntervals[indexPath.row]];
    }
    else if ([self isPreviousTasksSection:indexPath.section]) {
        NSIndexPath *path = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
        NSDictionary *taskDict = [self.fetchedResultsController objectAtIndexPath:path];
        [self.delegate selectedPreviousTaskTitle:taskDict[@"title"]];
    }

    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([self isPreviousTasksSection:section] && [self tableView:tableView numberOfRowsInSection:section] > 0) {
        return 42.5;
    }

    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view;
    if ([self isPreviousTasksSection:section] && [self tableView:tableView numberOfRowsInSection:section] > 0) {
         view = [[UIView alloc] init];

        UIView *labelContainer = [[UIView alloc] init];
        labelContainer.translatesAutoresizingMaskIntoConstraints = NO;
        labelContainer.backgroundColor = [UIColor offWhiteBackgroundColor];
        [view addSubview:labelContainer];

        [labelContainer horizontalConstraintsMatchSuperview];
        [labelContainer bottomConstraintMatchesSuperview];
        [labelContainer staticHeightConstraint:25.0];

        UILabel *label = [[UILabel alloc] init];
        label.translatesAutoresizingMaskIntoConstraints = NO;
        label.text = NSLocalizedString(@"Use Previous Task", nil);
        label.font = [UIFont fontForTableViewSectionHeader];
        [labelContainer addSubview:label];

        [label leadingConstraintMatchesSuperviewWithConstant:20.0];
        [label trailingConstraintMatchesSuperview];
        [label verticalCenterConstraintMatchesSuperview];

        UIView *separator = [[UIView alloc] init];
        separator.translatesAutoresizingMaskIntoConstraints = NO;
        separator.backgroundColor = [UIColor grayBorderColor];
        [labelContainer addSubview:separator];

        [separator topConstraintMatchesSuperview];
        [separator horizontalConstraintsMatchSuperview];
        [separator staticHeightConstraint:0.5];

        return view;
    }

    return nil;
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    [self updateTableContentSize];
}

#pragma mark - Convenience

- (BOOL)isPreviousTasksSection:(NSInteger)section {
    return ((self.doneButtonEnabled && self.previousTasksEnabled) && (section == 2)) || ((self.previousTasksEnabled && !self.doneButtonEnabled) && (section == 1));
}

- (BOOL)isDoneButtonSection:(NSInteger)section {
    return self.doneButtonEnabled && section == 0;
}

- (BOOL)isTimeIntervalSection:(NSInteger)section {
    return (self.doneButtonEnabled && section == 1) || (self.previousTasksEnabled && section == 0);
}

@end
