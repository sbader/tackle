//
//  MRNewTaskInterfaceController.m
//  Tackle
//
//  Created by Scott Bader on 4/29/15.
//  Copyright (c) 2015 Melody Road. All rights reserved.
//

#import "MRNewTaskInterfaceController.h"

#import "NSDate+TackleAdditions.h"
#import "MRDataReadingController.h"
#import "MRParentDataCoordinator.h"
#import "MRMainInterfaceController.h"

@interface MRNewTaskInterfaceController()

@property (weak) IBOutlet WKInterfaceLabel *titleLabel;
@property (weak) IBOutlet WKInterfaceLabel *dueDateLabel;
@property (weak) IBOutlet WKInterfaceButton *setTimeButton;
@property (weak) IBOutlet WKInterfaceButton *saveButton;

@property (nonatomic) NSDate *selectedDate;
@property (nonatomic) NSString *title;

@property (nonatomic) MRParentDataCoordinator *parentDataCoordinator;
@property (nonatomic) MRDataReadingController *persistenceController;

@end

@implementation MRNewTaskInterfaceController
- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    self.selectedDate = [NSDate date];
    [self.dueDateLabel setText:self.selectedDate.tackleString];
    [self.titleLabel setText:nil];

    NSDictionary *contextDictionary = (NSDictionary *)context;

    self.persistenceController = contextDictionary[kMRInterfaceControllerContextPersistenceController];
    self.parentDataCoordinator = contextDictionary[kMRInterfaceControllerContextDataReadingController];

    [self editTitle];
}

- (void)willActivate {
    [super willActivate];
}

- (void)didDeactivate {
    [super didDeactivate];
}

- (void)setTitleAndDateWithText:(NSString *)text {
    NSError *error = nil;
    NSDataDetector *dateDetector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeDate
                                                                   error:&error];

    NSTextCheckingResult *result = [dateDetector firstMatchInString:text options:kNilOptions range:NSMakeRange(0, text.length)];
    if (result && [result.date compare:[NSDate date]] == NSOrderedDescending) {
        NSString *leftoverText = [text stringByReplacingCharactersInRange:result.range withString:@""];
        NSString *titleText = [leftoverText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        self.selectedDate = result.date;
        self.title = titleText;
        [self updateDueDateLabel];
        [self updateTitleLabel];
    }
    else {
        self.title = text;
    }
}

- (void)editTitle {
    [self presentTextInputControllerWithSuggestions:@[@"Get a birthday card Tomorrow at 2:30 PM", @"Go to the mall Sunday at 1:00 PM"] allowedInputMode:WKTextInputModePlain completion:^(NSArray *results) {
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
    [self.parentDataCoordinator createTaskWithTitle:self.title dueDate:self.selectedDate completion:^(NSError *error) {
        if (error) {
            NSLog(@"Error creating task %@", error.localizedDescription);
        }
        else {
            NSLog(@"Successfully created task");
        }

        [self popController];
    }];
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
