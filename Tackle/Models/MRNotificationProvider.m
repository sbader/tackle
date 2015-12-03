//
//  MRNotificationProvider.m
//  Tackle
//
//  Created by Scott Bader on 1/8/15.
//  Copyright (c) 2015 Melody Road. All rights reserved.
//

#import "MRNotificationProvider.h"

@implementation MRNotificationProvider

+ (instancetype)sharedProvider {
    static MRNotificationProvider *provider = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        provider = [[self alloc] init];
    });

    return provider;
}


- (void)rescheduleAllNotificationsWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    [[UIApplication sharedApplication] cancelAllLocalNotifications];

    NSError *error;
    NSArray *tasks = [Task allOpenTasksWithManagedObjectContext:managedObjectContext error:&error];

    if (error) {
        NSLog(@"error getting tasks: %@", error);
        return;
    }

    [tasks enumerateObjectsUsingBlock:^(Task *task, NSUInteger idx, BOOL *stop) {
        [self scheduleNotificationForTask:task];
    }];
}

- (void)rescheduleNotificationForTask:(Task *)task {
    [self cancelNotificationForTask:task];
    [self scheduleNotificationForTask:task];
}

- (void)scheduleNotificationForTask:(Task *)task {
    UILocalNotification *notification = [[UILocalNotification alloc] init];

    [notification setFireDate:task.dueDate];
    [notification setAlertBody:task.title];
    [notification setRepeatInterval:NSCalendarUnitMinute];
    [notification setAlertAction:@"Tackle"];
    [notification setSoundName:UILocalNotificationDefaultSoundName];
    [notification setUserInfo:@{@"identifier": task.identifier}];
    [notification setCategory:@"taskNotificationCategory"];

    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

- (void)cancelNotificationForTask:(Task *)task {
    NSArray *localNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];

    NSUInteger index = [localNotifications indexOfObjectPassingTest:^BOOL(UILocalNotification *notification, NSUInteger idx, BOOL *stop) {
        NSString *taskIdentifier = (NSString *)[notification.userInfo objectForKey:@"identifier"];
        return [taskIdentifier isEqualToString:task.identifier];
    }];

    if (index == NSNotFound) {
        return;
    }

    UILocalNotification *notification = [localNotifications objectAtIndex:index];
    [[UIApplication sharedApplication] cancelLocalNotification:notification];
}

@end
