//
//  Task.m
//  Tackle
//
//  Created by Scott Bader on 1/22/14.
//  Copyright (c) 2014 Melody Road. All rights reserved.
//

#import "Task.h"


@implementation Task

@dynamic text;
@dynamic dueDate;
@dynamic isDone;

- (BOOL) scheduleNotification
{
    UILocalNotification *notification = [[UILocalNotification alloc] init];

    [notification setFireDate:self.dueDate];
    [notification setAlertBody:self.text];
    [notification setAlertAction:@"Tackle"];

    [[UIApplication sharedApplication] scheduleLocalNotification:notification];

    return YES;
}

@end
