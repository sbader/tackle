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
#import "MRPersistenceController.h"
#import "NSDate+TackleAdditions.h"


@interface MRMainInterfaceController()

@property (strong) MRPersistenceController *persistenceController;
@property (weak) IBOutlet WKInterfaceTable *mainTable;
@property (nonatomic) NSArray *todoItems;

@end


@implementation MRMainInterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    self.todoItems = @[];

    self.persistenceController = [[MRPersistenceController alloc] initWithCallback:^{
        [self completeUserInterface];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleManagedObjectContextDidSave:) name:NSManagedObjectContextDidSaveNotification object:nil];
    }];
}

- (void)completeUserInterface {
    [self refreshTable];
}

- (void)refreshTable {
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

    [self.mainTable setNumberOfRows:self.todoItems.count withRowType:@"mainRowType"];
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

    [self refreshTable];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

- (void)table:(WKInterfaceTable *)table didSelectRowAtIndex:(NSInteger)rowIndex {
    NSDictionary *context = @{
                              @"task": [self.todoItems objectAtIndex:rowIndex],
                              @"persistenceController": self.persistenceController
                              };

    [self pushControllerWithName:@"TaskInterfaceController" context:context];
}

- (void)tellParentApplicationToRefresh {
    NSDictionary *userInfo = @{
                               @"openRequestType": @"refreshContext"
                               };

    [WKInterfaceController openParentApplication:userInfo reply:^(NSDictionary *replyInfo, NSError *error) {
    }];
}

- (void)handleManagedObjectContextDidSave:(id)sender {
    [self tellParentApplicationToRefresh];
}

@end



