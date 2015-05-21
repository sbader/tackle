//
//  MRTaskInterfaceController.m
//  Tackle
//
//  Created by Scott Bader on 4/28/15.
//  Copyright (c) 2015 Melody Road. All rights reserved.
//

#import "MRTaskInterfaceController.h"

#import "Task.h"
#import "NSDate+TackleAdditions.h"
#import "MRReadOnlyPersistenceController.h"
#import "MRParentDataCoordinator.h"
#import "MRMainInterfaceController.h"

@interface MRTaskInterfaceController ()

@property (weak) IBOutlet WKInterfaceLabel *titleLabel;
@property (weak) IBOutlet WKInterfaceLabel *dateLabel;
@property (weak) IBOutlet WKInterfaceButton *doneButton;
@property (weak) IBOutlet WKInterfaceButton *addTenMinutesButton;
@property (weak) IBOutlet WKInterfaceButton *addAnHourButton;
@property (weak) IBOutlet WKInterfaceButton *addADayButton;

@property (nonatomic) Task *task;
@property (nonatomic) NSString *currentTitle;
@property (nonatomic) NSDate *currentDate;
@property (nonatomic) MRParentDataCoordinator *parentDataCoordinator;
@property (nonatomic) MRReadOnlyPersistenceController *persistenceController;

@end

@implementation MRTaskInterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    NSDictionary *contextDictionary = (NSDictionary *)context;

    self.task = contextDictionary[kMRInterfaceControllerContextTask];
    self.persistenceController = contextDictionary[kMRInterfaceControllerContextPersistenceController];
    self.parentDataCoordinator = contextDictionary[kMRInterfaceControllerContextDataReadingController];

    self.currentDate = [self.task.dueDate copy];
    self.currentTitle = [self.task.title copy];

    [self.titleLabel setText:self.currentTitle];
    [self updateDateLabel];
}

- (void)updateDateLabel {
    [self.dateLabel setText:self.currentDate.tackleString];
}

- (void)willActivate {
    [super willActivate];
}

- (void)didDeactivate {
    [super didDeactivate];
}

- (void)updateTaskDueDateWithUnit:(NSCalendarUnit)unit interval:(NSTimeInterval)interval {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    self.currentDate = [calendar dateByAddingUnit:unit
                                            value:interval
                                           toDate:self.currentDate
                                          options:0];

    [self updateDateLabel];
}

- (IBAction)handleCancelButton:(id)sender {
    [self dismissController];
}

- (IBAction)handleSaveButton:(id)sender {
    self.task.dueDate = self.currentDate;

    [self.parentDataCoordinator updateTask:self.task withCompletion:^(NSError *error) {
        if (error) {
            NSLog(@"Error updating task %@", error.localizedDescription);
        }
        else {
            NSLog(@"Successfully updated task");
            [self sendDataUpdatedNotification];
        }

        [self dismissController];
    }];
}

- (IBAction)handleDoneButton:(id)sender {
    [self.parentDataCoordinator completeTask:self.task withCompletion:^(NSError *error) {
        if (error) {
            NSLog(@"Error completing task %@", error.localizedDescription);
        }
        else {
            NSLog(@"Successfully completed task");
            [self sendDataUpdatedNotification];
        }

        [self dismissController];
    }];
}

- (void)sendDataUpdatedNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:kMRDataUpdatedNotificationName object:nil];
}

- (IBAction)handleAddTenMinutesButton:(id)sender {
    [self updateTaskDueDateWithUnit:NSCalendarUnitMinute interval:10];
}

- (IBAction)handleAddAnHourButton:(id)sender {
    [self updateTaskDueDateWithUnit:NSCalendarUnitHour interval:1];
}

- (IBAction)handleAddADayButton:(id)sender {
    [self updateTaskDueDateWithUnit:NSCalendarUnitDay interval:1];
}

@end



