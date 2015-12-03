//
//  MRNewTaskInterfaceController.m
//  Tackle
//
//  Created by Scott Bader on 4/29/15.
//  Copyright (c) 2015 Melody Road. All rights reserved.
//

#import "MRNewTaskInterfaceController.h"

#import "NSDate+TackleAdditions.h"
#import "MRPersistenceController.h"
#import "MRMainInterfaceController.h"
#import "MRConnectivityController.h"
#import "Task.h"

@interface MRNewTaskInterfaceController()

@property (weak) IBOutlet WKInterfaceLabel *titleLabel;
@property (weak) IBOutlet WKInterfaceLabel *dueDateLabel;
@property (weak) IBOutlet WKInterfaceButton *setTimeButton;
@property (weak) IBOutlet WKInterfaceButton *saveButton;

@property (nonatomic) NSDate *selectedDate;
@property (nonatomic) NSString *title;

@property (nonatomic) MRPersistenceController *persistenceController;
@property (nonatomic) MRConnectivityController *connectivityController;

@end

@implementation MRNewTaskInterfaceController
- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    self.selectedDate = [NSDate date];
    [self.dueDateLabel setText:self.selectedDate.tackleString];
    [self.titleLabel setText:nil];

    NSDictionary *contextDictionary = (NSDictionary *)context;

    self.persistenceController = contextDictionary[kMRInterfaceControllerContextPersistenceController];
    self.connectivityController = contextDictionary[kMRInterfaceControllerContextConnectivityController];

    [self editTitle];
}

- (void)willActivate {
    [super willActivate];
}

- (void)didDeactivate {
    [super didDeactivate];
}

- (void)setTitleAndDateWithText:(NSString *)text {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSError *error = nil;
        NSDataDetector *dateDetector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeDate
                                                                       error:&error];

        NSTextCheckingResult *result = [dateDetector firstMatchInString:text options:kNilOptions range:NSMakeRange(0, text.length)];
        if (result && [result.date compare:[NSDate date]] == NSOrderedDescending) {
            NSString *leftoverText = [text stringByReplacingCharactersInRange:result.range withString:@""];
            NSString *titleText = [leftoverText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            self.selectedDate = result.date;
            self.title = titleText;
        }
        else {
            self.title = text;
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateDueDateLabel];
            [self updateTitleLabel];
        });
    });
}

- (void)editTitle {
    NSArray *suggestions = nil;
#if TARGET_IPHONE_SIMULATOR
    suggestions = @[@"Leave for the mall in ten minutes", @"Buy a birthday card tomorrow at 11:00am"];
#endif
    [self presentTextInputControllerWithSuggestions:suggestions allowedInputMode:WKTextInputModePlain completion:^(NSArray *results) {
        if (results && results.count > 0) {
            NSString *result = [results objectAtIndex:0];
            [self setTitleAndDateWithText:result];
        }
    }];
}

- (void)updateDueDateLabel {
    [self.dueDateLabel setText:self.selectedDate.tackleString];
}

- (void)updateTitleLabel {
    [self.titleLabel setText:self.title];
}

- (IBAction)handleSaveButton:(id)sender {
    Task *task = [Task insertItemWithTitle:self.title dueDate:self.selectedDate identifier:[NSUUID UUID].UUIDString inManagedObjectContext:self.persistenceController.managedObjectContext];
    [self.persistenceController save];
    [self sendDataUpdatedNotification];

    [self.connectivityController sendNewTaskNotificationWithTask:task];
    [self dismissController];
}

- (void)sendDataUpdatedNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:kMRDataUpdatedNotificationName object:nil];
}

- (IBAction)handleEditTitleButton:(id)sender {
    [self editTitle];
}

- (void)updateDateWithCalendarUnit:(NSCalendarUnit)unit interval:(NSTimeInterval)interval {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    self.selectedDate = [calendar dateByAddingUnit:unit
                                             value:interval
                                            toDate:self.selectedDate
                                           options:0];
    [self updateDueDateLabel];
}

- (IBAction)handleCancelButton:(id)sender {
    [self dismissController];
}

- (IBAction)handleAddTenMinutesButton:(id)sender {
    [self updateDateWithCalendarUnit:NSCalendarUnitMinute interval:10];
}

- (IBAction)handleAddAnHourButton:(id)sender {
    [self updateDateWithCalendarUnit:NSCalendarUnitHour interval:1];
}

- (IBAction)handleAddADayButton:(id)sender {
    [self updateDateWithCalendarUnit:NSCalendarUnitDay interval:1];
}

@end
