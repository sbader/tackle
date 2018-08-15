//
//  MRNotificationProvider.m
//  Tackle
//
//  Created by Scott Bader on 1/8/15.
//  Copyright (c) 2015 Melody Road. All rights reserved.
//

#import "MRNotificationProvider.h"

#import "MRTaskNotification.h"

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
    [[UNUserNotificationCenter currentNotificationCenter] removeAllDeliveredNotifications];
    [[UNUserNotificationCenter currentNotificationCenter] removeAllPendingNotificationRequests];

    NSFetchRequest *fetchRequest = [Task openTasksFetchRequestWithManagedObjectContext:managedObjectContext];
    NSError *error = nil;
    NSArray *tasks = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    NSAssert(tasks != nil, @"Failed to execute fetch %@", error);

    for (Task *task in tasks) {
        [self scheduleNotificationForTask:task];
    }
}

- (void)rescheduleNotificationForTask:(Task *)task {
    [self cancelNotificationForTask:task];
    [self scheduleNotificationForTask:task];
}

- (void)scheduleNotificationForTask:(Task *)task {
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = @"Time To Tackle";
    content.body = task.title;
    content.sound = [UNNotificationSound soundNamed:@"tacklespiel.aif"];
    content.categoryIdentifier = kMRTaskNotificationCategoryIdentifier;

    NSDateComponents *components = task.dueDateComponents;

    for (MRTaskNotification *taskNotification in task.taskNotifications) {
        NSDateComponents *delayComponents = [components copy];
        [delayComponents setValue:(delayComponents.minute + taskNotification.delay)
                     forComponent:NSCalendarUnitMinute];

        UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:delayComponents
                                                                                                          repeats:NO];


        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:taskNotification.identifier
                                                                              content:content
                                                                              trigger:trigger];

        [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:nil];
        MRLog(@"Scheduled notification for task %@, notificationIdentifier: %@", task.title, taskNotification.identifier);
    }
}

- (void)cancelNotificationForTask:(Task *)task {
    NSArray *identifiers = [task.taskNotifications valueForKey:@"identifier"];
    [[UNUserNotificationCenter currentNotificationCenter] removeDeliveredNotificationsWithIdentifiers:identifiers];
    [[UNUserNotificationCenter currentNotificationCenter] removePendingNotificationRequestsWithIdentifiers:identifiers];
    MRLog(@"Canceled notifications for task %@, notificationIdentifiers: %@", task.title, identifiers);
}

@end
