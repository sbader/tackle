//
//  TackMainTableViewController.m
//  Tackle
//
//  Created by Scott Bader on 1/22/14.
//  Copyright (c) 2014 Melody Road. All rights reserved.
//

#import "TackMainTableViewController.h"

#import "TackMainTableViewCell.h"
#import "TackDateFormatter.h"
#import "Task.h"

@interface TackMainTableViewController () <UITextFieldDelegate, TackMainTableViewCellDelegate>
- (void)updateCell:(TackMainTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation TackMainTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.dueDate = [NSDate date];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.tableView setBackgroundColor:[UIColor darkPlumColor]];
    [self.tableView setRowHeight:67.0f];

    [self.tableView setSectionHeaderHeight:22.0f];
    [self.tableView setSectionFooterHeight:22.0f];

    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];

    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    [self.tableView setSeparatorColor:[UIColor lightOpaqueGrayColor]];

    [self.tableView registerClass:[TackMainTableViewCell class] forCellReuseIdentifier:@"Cell"];

//    [self.taskTextField setDelegate:self];
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDoesRelativeDateFormatting:YES];
//
//    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
//    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
//
//    [self.timeButton setTitle:[dateFormatter stringFromDate:self.dueDate] forState:UIControlStateNormal];
//
//    [self attachObservers];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self detachObservers];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)insertNewObject:(id)sender
{
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];

    Task *task = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];

    [task setText:self.taskTextField.text];
    [task setDueDate:[NSDate dateWithTimeIntervalSinceNow:86400]];

    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TackMainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    [self updateCell:cell atIndexPath:indexPath];

    [cell setDelegate:self];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Task *task = [self.fetchedResultsController objectAtIndexPath:indexPath];

    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];

    UIFont *font = [UIFont effraRegularWithSize:15.0f];

    NSDictionary *attributes = @{NSFontAttributeName:[font fontWithSize:15.0f],
                                 NSParagraphStyleAttributeName:paragraphStyle};

    CGRect rect = [task.text boundingRectWithSize:CGSizeMake(234, MAXFLOAT)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:attributes
                                              context:nil];

    CGFloat height = ceil(rect.size.height) + 46;

    return height;
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Task" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];

    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];

    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dueDate" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];

    [fetchRequest setSortDescriptors:sortDescriptors];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"isDone == NO"]];

//    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;

	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}

    return _fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;

    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeUpdate:
            [self updateCell:(TackMainTableViewCell *)[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;

        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        Task *task = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [task cancelNotification];
        [context deleteObject:task];

        NSError *error = nil;
        if (![context save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (void)updateCell:(TackMainTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Task *task = [self.fetchedResultsController objectAtIndexPath:indexPath];

    [cell setText:task.text];
    [cell setDueDate:task.dueDate];
}

- (void)addTaskWithText:(NSString *)text dueDate:(NSDate *)dueDate
{
    if (text.length != 0) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];

        Task *task = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];

        [task setText:text];
        [task setDueDate:dueDate];

        NSError *error = nil;
        if (![context save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }

        [task scheduleNotification];
        [self.taskTextField setText:@""];
        [self setDueDate:[NSDate date]];
        [self.view endEditing:YES];
    }
}

- (IBAction)tenMinuteButtonPressed:(id)sender
{
    [self setDueDate:[NSDate dateWithTimeInterval:600 sinceDate:self.dueDate]];
}

- (IBAction)oneHourButtonPressed:(id)sender
{
    [self setDueDate:[NSDate dateWithTimeInterval:3600 sinceDate:self.dueDate]];
}

- (IBAction)oneDayButtonPressed:(id)sender
{
    [self setDueDate:[NSDate dateWithTimeInterval:86400 sinceDate:self.dueDate]];
}

- (IBAction)doneButtonPressed:(id)sender
{
    [self addTaskWithText:self.taskTextField.text dueDate:self.dueDate];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.taskTextField) {
        [textField resignFirstResponder];
        return NO;
    }

    return YES;
}

- (void)markAsDone:(TackMainTableViewCell *)cell
{
    Task *task = [self.fetchedResultsController objectAtIndexPath:[self.tableView indexPathForCell:cell]];
    [task markAsDone];

    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];

    NSError *error = nil;
    if (![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

- (void)attachObservers {
    [self addObserver:self forKeyPath:@"dueDate" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)detachObservers {
    [self removeObserver:self forKeyPath:@"dueDate"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"dueDate"]) {
        NSDate *date = (NSDate *)[change valueForKey:NSKeyValueChangeNewKey];
        [self.timeButton setTitle:[[TackDateFormatter sharedInstance] stringFromDate:date] forState:UIControlStateNormal];
    }
}

@end
