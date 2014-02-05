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

+ (Task *)insertItemWithText:(NSString*)text dueDate:(NSDate *)dueDate inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    Task *task = [NSEntityDescription insertNewObjectForEntityForName:@"Task"
                                               inManagedObjectContext:managedObjectContext];

    task.text = text;
    task.dueDate = dueDate;

    return task;
}

- (BOOL)scheduleNotification
{
    UILocalNotification *notification = [[UILocalNotification alloc] init];

    [notification setFireDate:self.dueDate];
    [notification setAlertBody:self.text];
    [notification setRepeatInterval:NSMinuteCalendarUnit];
    [notification setAlertAction:@"Tackle"];
    [notification setSoundName:UILocalNotificationDefaultSoundName];
    [notification setUserInfo:@{@"uniqueId": self.objectID.URIRepresentation.absoluteString}];

    [[UIApplication sharedApplication] scheduleLocalNotification:notification];

    return YES;
}

- (void)cancelNotification
{
    NSArray *localNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];

    NSUInteger index = [localNotifications indexOfObjectPassingTest:^BOOL(UILocalNotification *notification, NSUInteger idx, BOOL *stop) {
        NSString *uniqueId = (NSString *)[notification.userInfo objectForKey:@"uniqueId"];
        return [uniqueId isEqualToString:self.objectID.URIRepresentation.absoluteString];
    }];

    if (index == NSNotFound) {
        return;
    }

    UILocalNotification *notification = [localNotifications objectAtIndex:index];
    [[UIApplication sharedApplication] cancelLocalNotification:notification];
}

- (void)rescheduleNotification
{
    [self cancelNotification];
    [self scheduleNotification];
}

- (void)markAsDone
{
    [self setIsDone:YES];
    [self cancelNotification];
}

@end
