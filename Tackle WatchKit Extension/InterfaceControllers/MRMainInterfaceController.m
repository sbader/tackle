//
//  InterfaceController.m
//  Tackle WatchKit Extension
//
//  Created by Scott Bader on 4/28/15.
//  Copyright (c) 2015 Melody Road. All rights reserved.
//

#import "MRMainInterfaceController.h"

#import "Task.h"
#import "MRMainRowController.h"
#import "NSDate+TackleAdditions.h"
#import "MRParentDataCoordinator.h"
#import "MRReadOnlyPersistenceController.h"

NSString * const kMRDataUpdatedNotificationName = @"MRDataUpdatedNotification";
NSString * const kMRInterfaceControllerContextTask = @"Task";
NSString * const kMRInterfaceControllerContextPersistenceController = @"PersistenceController";
NSString * const kMRInterfaceControllerContextDataReadingController = @"DataReadingController";

@interface MRMainInterfaceController()

@property (strong) MRReadOnlyPersistenceController *persistenceController;
@property (strong) MRParentDataCoordinator *parentDataCoordinator;
@property (weak) IBOutlet WKInterfaceTable *mainTable;
@property (nonatomic) NSArray *todoItems;

@end


@implementation MRMainInterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    self.todoItems = @[];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dataDidUpdate:)
                                                 name:kMRDataUpdatedNotificationName
                                               object:nil];

    self.persistenceController = [[MRReadOnlyPersistenceController alloc] initWithCallback:^{
        [self completeUserInterface];
    }];

    self.parentDataCoordinator = [[MRParentDataCoordinator alloc] init];
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
                 kMRInterfaceControllerContextDataReadingController: self.parentDataCoordinator
                 };
    }

    return nil;
}

- (id)contextForSegueWithIdentifier:(NSString *)segueIdentifier {
    if ([segueIdentifier isEqualToString:@"AddTaskSegue"]) {
        return @{
                 kMRInterfaceControllerContextPersistenceController: self.persistenceController,
                 kMRInterfaceControllerContextDataReadingController: self.parentDataCoordinator
                 };
    }

    return nil;
}

- (void)dataDidUpdate:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self refreshTodoItems];
    });
}

@end



