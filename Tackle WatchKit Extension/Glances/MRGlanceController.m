//
//  GlanceController.m
//  Tackle WatchKit Extension
//
//  Created by Scott Bader on 4/28/15.
//  Copyright (c) 2015 Melody Road. All rights reserved.
//

#import "MRGlanceController.h"

#import "Task.h"
#import "NSDate+TackleAdditions.h"
#import "MRReadOnlyPersistenceController.h"

@interface MRGlanceController()

@property (weak) IBOutlet WKInterfaceLabel *headingLabel;
@property (weak) IBOutlet WKInterfaceLabel *subheadingLabel;
@property (weak) IBOutlet WKInterfaceLabel *titleLabel;
@property (weak) IBOutlet WKInterfaceLabel *dateLabel;
@property (strong) MRReadOnlyPersistenceController *persistenceController;

@property(nonatomic, strong) NSThread *timerThread;
@property(nonatomic, assign) NSInteger tick;
@property(nonatomic, strong) NSTimer *timer;

@end

@implementation MRGlanceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
}

- (void)startTimerThread {
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0
                                                  target:self
                                                selector:@selector(timerDidFire:)
                                                userInfo:nil
                                                 repeats:YES];
    [runLoop run];
}

- (void)timerDidFire:(NSTimer *)timer {
    [self refreshTasksList];
}

- (void)refreshTasksList {
    if (self.persistenceController) {
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
                [self.subheadingLabel setText:@"Up Next"];
                [self.titleLabel setHidden:NO];
                [self.dateLabel setHidden:NO];
            }
            else {
                [self.headingLabel setText:@"No Tasks"];
                [self.subheadingLabel setText:@"No upcoming tasks to tackle"];
                [self.titleLabel setHidden:YES];
                [self.dateLabel setHidden:YES];
                [self.titleLabel setText:@""];
                [self.dateLabel setText:@""];
            }
        }
    }
}

- (void)willActivate {
    [super willActivate];

    self.persistenceController = [[MRReadOnlyPersistenceController alloc] initWithCallback:^{
        [self refreshTasksList];

        self.timerThread = [[NSThread alloc] initWithTarget:self selector:@selector(startTimerThread) object:nil];
        [self.timerThread start];
    }];
}

- (void)didDeactivate {
    [super didDeactivate];

    [self.timer invalidate];
}

@end



