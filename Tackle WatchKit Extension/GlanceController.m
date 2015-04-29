//
//  GlanceController.m
//  Tackle WatchKit Extension
//
//  Created by Scott Bader on 4/28/15.
//  Copyright (c) 2015 Melody Road. All rights reserved.
//

#import "GlanceController.h"

#import "Task.h"
#import "NSDate+TackleAdditions.h"
#import "MRDataReadingController.h"


@interface GlanceController()

@property (weak) IBOutlet WKInterfaceLabel *headingLabel;
@property (weak) IBOutlet WKInterfaceLabel *titleLabel;
@property (weak) IBOutlet WKInterfaceLabel *dateLabel;
@property (strong) MRDataReadingController *persistenceController;

@end


@implementation GlanceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    self.persistenceController = [[MRDataReadingController alloc] initWithCallback:^{
        NSError *error;
        NSArray *tasks = [Task allOpenTasksWithManagedObjectContext:self.persistenceController.managedObjectContext error:&error];

        if (!error) {
            if (tasks.count > 0) {
                Task *nextTask = tasks[0];
                [self.titleLabel setText:nextTask.title];
                [self.dateLabel setText:[nextTask.dueDate tackleStringSinceDate:[NSDate date]]];

                NSString *headingText;
                if (tasks.count == 1) {
                    headingText = @"1 Task";
                }
                else {
                    headingText = [NSString stringWithFormat:@"%@ Tasks", @(tasks.count)];
                }

                [self.headingLabel setText:headingText];
            }
            else {
                [self.titleLabel setText:@""];
                [self.dateLabel setText:@""];
                [self.headingLabel setText:@"No Tasks"];
            }
        }
    }];
}

- (void)willActivate {
    [super willActivate];
}

- (void)didDeactivate {
    [super didDeactivate];
}

@end



