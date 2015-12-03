//
//  InterfaceController.m
//  Tackle WatchKit Extension
//
//  Created by Scott Bader on 4/28/15.
//  Copyright (c) 2015 Melody Road. All rights reserved.
//

#import "MRMainInterfaceController.h"

#import <WatchConnectivity/WatchConnectivity.h>

#import "Task.h"
#import "MRMainRowController.h"
#import "NSDate+TackleAdditions.h"
#import "MRPersistenceController.h"
#import "MRConnectivityController.h"

NSString * const kMRDataUpdatedNotificationName = @"MRDataUpdatedNotification";
NSString * const kMRInterfaceControllerContextTask = @"Task";
NSString * const kMRInterfaceControllerContextPersistenceController = @"PersistenceController";
NSString * const kMRInterfaceControllerContextConnectivityController = @"ConnectivityController";
NSString * const kMRInterfaceControllerContextDataReadingController = @"DataReadingController";

@interface MRMainInterfaceController() <MRConnectivityControllerDelegate>

@property (strong) MRPersistenceController *persistenceController;
@property (weak) IBOutlet WKInterfaceTable *mainTable;
@property (nonatomic) NSArray *todoItems;
@property (nonatomic) MRConnectivityController *connectivityController;

@end


@implementation MRMainInterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    self.todoItems = @[];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dataDidUpdate:)
                                                 name:kMRDataUpdatedNotificationName
                                               object:nil];

    self.persistenceController = [[MRPersistenceController alloc] init];
    [self completeUserInterface];

    self.connectivityController = [[MRConnectivityController alloc] initWithPersistenceController:self.persistenceController];
    self.connectivityController.delegate = self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)completeUserInterface {
    [self refreshTodoItems];
    [self refreshTable];
}

- (void)refreshTodoItems {
    if (!self.persistenceController) {
        return;
    }

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Task"
                                              inManagedObjectContext:self.persistenceController.managedObjectContext];

    [fetchRequest setEntity:entity];

    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dueDate" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];

    [fetchRequest setSortDescriptors:sortDescriptors];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"isDone == NO"]];

    NSError *error;
    self.todoItems = [self.persistenceController.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    NSLog(@"found todo items %@", @(self.todoItems.count));
}

- (void)refreshTable {
    if (self.todoItems.count != self.mainTable.numberOfRows) {
        [self.mainTable setNumberOfRows:self.todoItems.count withRowType:@"mainRowType"];
    }

    NSInteger rowCount = self.mainTable.numberOfRows;

    for (NSInteger i = 0; i < rowCount; i++) {
        Task *task = [self.todoItems objectAtIndex:i];
        MRMainRowController *row = [self.mainTable rowControllerAtIndex:i];
        [row.titleLabel setText:task.title];
        [row.dateLabel setText:[task.dueDate tackleStringSinceDate:[NSDate date]]];
    }
}

- (void)willActivate {
    [super willActivate];

    if (self.persistenceController) {
        [self refreshTable];
    }
}

- (void)didDeactivate {
    [super didDeactivate];
}

- (id)contextForSegueWithIdentifier:(NSString *)segueIdentifier inTable:(WKInterfaceTable *)table rowIndex:(NSInteger)rowIndex {
    if ([segueIdentifier isEqualToString:@"EditTaskSegue"]) {
        return @{
                 kMRInterfaceControllerContextTask: [self.todoItems objectAtIndex:rowIndex],
                 kMRInterfaceControllerContextPersistenceController: self.persistenceController,
                 kMRInterfaceControllerContextConnectivityController: self.connectivityController
                 };
    }

    return nil;
}

- (id)contextForSegueWithIdentifier:(NSString *)segueIdentifier {
    if ([segueIdentifier isEqualToString:@"AddTaskSegue"]) {
        return @{
                 kMRInterfaceControllerContextPersistenceController: self.persistenceController,
                 kMRInterfaceControllerContextConnectivityController: self.connectivityController
                 };
    }

    return nil;
}

- (void)dataDidUpdate:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self refreshTodoItems];
    });
}

- (void)connectivityController:(MRConnectivityController *)connectivityController didAddTask:(Task *)task {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self refreshTodoItems];
        [self refreshTable];
    });
}

- (void)connectivityController:(MRConnectivityController *)connectivityController didUpdateTask:(Task *)task {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self refreshTodoItems];
        [self refreshTable];
    });
}

- (void)connectivityController:(MRConnectivityController *)connectivityController didCompleteTask:(Task *)task {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self refreshTodoItems];
        [self refreshTable];
    });
}

@end



