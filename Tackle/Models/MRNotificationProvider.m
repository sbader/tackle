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

    UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:task.dueDateComponents
                                                                                                      repeats:NO];


    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:task.identifier
                                                                          content:content
                                                                          trigger:trigger];

    //TODO: Add a way to do repeated notifications. May need to just created a bunch of requests

    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:nil];
    os_log(OS_LOG_DEFAULT, "Scheduled notification for task %@", task.title);
}

- (void)cancelNotificationForTask:(Task *)task {
    [[UNUserNotificationCenter currentNotificationCenter] removePendingNotificationRequestsWithIdentifiers:@[task.identifier]];
}

@end
