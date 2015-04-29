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
#import "MRPersistenceController.h"

@interface MRTaskInterfaceController ()

@property (weak) IBOutlet WKInterfaceLabel *titleLabel;
@property (weak) IBOutlet WKInterfaceLabel *dateLabel;
@property (weak) IBOutlet WKInterfaceButton *doneButton;
@property (weak) IBOutlet WKInterfaceButton *addTenMinutesButton;
@property (weak) IBOutlet WKInterfaceButton *addAnHourButton;
@property (weak) IBOutlet WKInterfaceButton *addADayButton;

@property (nonatomic) Task *task;
@property (nonatomic) MRPersistenceController *persistenceController;

@end

@implementation MRTaskInterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    NSDictionary *contextDictionary = (NSDictionary *)context;

    self.task = contextDictionary[@"task"];
    self.persistenceController = contextDictionary[@"persistenceController"];

    [self.titleLabel setText:self.task.title];
    [self updateDateLabel];
}

- (void)updateDateLabel {
    [self.dateLabel setText:self.task.dueDate.tackleString];
}

- (void)willActivate {
    [super willActivate];
}

- (void)didDeactivate {
    [super didDeactivate];
}

//- (void)tellParentApplicationToRescheduleNotifications {
//    NSDictionary *userInfo = @{
//                               @"openRequestType": @"rescheduleNotifications"
//                               };
//    [MRTaskInterfaceController openParentApplication:userInfo reply:^(NSDictionary *replyInfo, NSError *error) {
//    }];
//}

- (void)updateTaskDueDateWithUnit:(NSCalendarUnit)unit interval:(NSTimeInterval)interval {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    self.task.dueDate = [calendar dateByAddingUnit:unit
                                            value:interval
                                           toDate:self.task.dueDate
                                          options:0];
    [self.persistenceController save];
//    [self tellParentApplicationToRescheduleNotifications];
    [self updateDateLabel];
}

- (IBAction)handleDoneButton:(id)sender {
    self.task.isDone = YES;
    self.task.completedDate = [NSDate date];
    [self.persistenceController save];

//    [self tellParentApplicationToRescheduleNotifications];
    [self popController];
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



