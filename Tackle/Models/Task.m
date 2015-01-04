//
//  Task.m
//  Tackle
//
//  Created by Scott Bader on 1/22/14.
//  Copyright (c) 2014 Melody Road. All rights reserved.
//

#import "Task.h"

NSString * const kMRAddTenMinutesActionIdentifier = @"addTenMinutesAction";
NSString * const kMRDestroyTaskActionIdentifier = @"destroyTaskAction";
NSString * const kMRTaskNotificationCategoryIdentifier = @"taskNotificationCategory";

@implementation Task

@dynamic text;
@dynamic dueDate;
@dynamic isDone;

+ (Task *)insertItemWithText:(NSString*)text dueDate:(NSDate *)dueDate inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    Task *task = [NSEntityDescription insertNewObjectForEntityForName:@"Task"
                                               inManagedObjectContext:managedObjectContext];

    task.text = text;
    task.dueDate = dueDate;

    return task;
}

+ (NSInteger)numberOfOpenTasksInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Task" inManagedObjectContext:managedObjectContext];
    fetchRequest.entity = entity;
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"isDone == NO"];

    return [managedObjectContext countForFetchRequest:fetchRequest error:nil];
}

+ (NSArray *)allOpenTasksWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext error:(NSError **)error {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Task" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchBatchSize:20];

    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dueDate" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];

    [fetchRequest setSortDescriptors:sortDescriptors];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"isDone == NO"]];

    return [managedObjectContext executeFetchRequest:fetchRequest error:error];
}

- (BOOL)scheduleNotification {
    UILocalNotification *notification = [[UILocalNotification alloc] init];

    [notification setFireDate:self.dueDate];
    [notification setAlertBody:self.text];
    [notification setRepeatInterval:NSCalendarUnitMinute];
    [notification setAlertAction:@"Tackle"];
    [notification setSoundName:UILocalNotificationDefaultSoundName];
    [notification setUserInfo:@{@"uniqueId": self.objectID.URIRepresentation.absoluteString}];
    [notification setCategory:@"taskNotificationCategory"];

    [[UIApplication sharedApplication] scheduleLocalNotification:notification];

    return YES;
}

- (void)cancelNotification {
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

- (void)rescheduleNotification {
    [self cancelNotification];
    [self scheduleNotification];
}

- (void)markAsDone {
    [self setIsDone:YES];
    [self cancelNotification];
}

+ (void)rescheduleAllNotificationsWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    [[UIApplication sharedApplication] cancelAllLocalNotifications];

    NSError *error;
    NSArray *tasks = [self allOpenTasksWithManagedObjectContext:managedObjectContext error:&error];

    if (error) {
        NSLog(@"error getting tasks: %@", error);
        return;
    }

    [tasks enumerateObjectsUsingBlock:^(Task *task, NSUInteger idx, BOOL *stop) {
        [task scheduleNotification];
    }];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ %@", self.text, self.dueDate];
}

@end
