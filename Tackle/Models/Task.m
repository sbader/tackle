//
//  Task.m
//  Tackle
//
//  Created by Scott Bader on 1/22/14.
//  Copyright (c) 2014 Melody Road. All rights reserved.
//

#import "Task.h"

#import "MRTaskNotification.h"

NSString * const kMRAddTenMinutesActionIdentifier = @"addTenMinutesAction";
NSString * const kMRDestroyTaskActionIdentifier = @"destroyTaskAction";
NSString * const kMRAddOneHourActionIdentifier = @"addOneHourAction";
NSString * const kMRTaskNotificationCategoryIdentifier = @"taskNotificationCategory";

@implementation Task

@dynamic title;
@dynamic dueDate;
@dynamic isDone;
@dynamic createdDate;
@dynamic originalDueDate;
@dynamic completedDate;
@dynamic identifier;
@dynamic repeats;

- (void) awakeFromInsert {
    [super awakeFromInsert];
    self.createdDate = [NSDate date];
}

- (Task *)createRepeatedTaskInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    TaskRepeatInterval interval = [self taskRepeatInterval];

    if (interval == TaskRepeatIntervalNone) {
        return nil;
    }

    Task *task = [NSEntityDescription insertNewObjectForEntityForName:@"Task"
                                               inManagedObjectContext:managedObjectContext];

    task.identifier = [NSUUID UUID].UUIDString;
    task.title = self.title;

    NSDate *dueDate;

    switch (interval) {
        case TaskRepeatIntervalAllDays:
            dueDate = [self.originalDueDate followingDay];
            break;
        case TaskRepeatIntervalWeekdays:
            dueDate = [self.originalDueDate followingDay];

            while (![dueDate isWeekday]) {
                dueDate = [self.originalDueDate followingDay];
            }
            break;

        default:
            return nil;
            break;
    }

    task.dueDate = dueDate;
    task.originalDueDate = dueDate;

    return task;
}

- (TaskRepeatInterval)taskRepeatInterval {
    NSInteger repeatValue = self.repeats.integerValue;

    if (repeatValue == TaskRepeatIntervalAllDays) {
        return TaskRepeatIntervalAllDays;
    }
    else if (repeatValue == TaskRepeatIntervalWeekdays) {
        return TaskRepeatIntervalWeekdays;
    }


    return TaskRepeatIntervalNone;
}

+ (Task *)findTaskWithIdentifier:(NSString *)identifier inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext  {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Task" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchLimit:1];

    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"identifier == %@", identifier]];

    NSError *error;
    NSArray *tasks = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    NSAssert(tasks != nil, @"Failed to execute fetch %@", error);

    if (tasks.count > 0) {
        return tasks[0];
    }

    return nil;
}

+ (Task *)findTaskWithTaskNotificationIdentifier:(NSString *)taskNotificationIdentifier inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext  {
    NSString *identifier = [MRTaskNotification taskIdentifierFromTaskNotificationIdentifier:taskNotificationIdentifier];

    if (identifier == nil) {
        return nil;
    }

    return [Task findTaskWithIdentifier:identifier inManagedObjectContext:managedObjectContext];
}

+ (NSInteger)numberOfOpenTasksInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Task" inManagedObjectContext:managedObjectContext];
    fetchRequest.entity = entity;
    fetchRequest.includesPropertyValues = NO;
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"isDone == NO"];

    NSError *error = nil;
    NSInteger count = [managedObjectContext countForFetchRequest:fetchRequest error:&error];
    NSAssert(error == nil, @"Failed to execute fetch %@", error);
    
    return count;
}

+ (NSFetchRequest *)allTasksFetchRequestWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Task" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];

    return fetchRequest;
}

+ (NSFetchRequest *)openTasksFetchRequestWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Task"
                                              inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"isDone == NO", [NSDate date]]];

    return fetchRequest;
}

+ (NSFetchRequest *)passedOpenTasksFetchRequestWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Task"
                                              inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"isDone == NO AND dueDate < %@", [NSDate date]]];

    return fetchRequest;
}

+ (NSFetchRequest *)archivedTasksFetchRequestWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Task" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchBatchSize:20];

    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"isDone == YES"]];

    return fetchRequest;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<Task: title:%@, dueDate:%@>", self.title, self.dueDate];
}

- (NSDateComponents *)dueDateComponents {
    NSCalendarUnit components = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute;

    return [[NSCalendar currentCalendar] components:components
                                           fromDate:self.dueDate];
}

- (NSArray<MRTaskNotification *> *)taskNotifications {
    return @[
             [[MRTaskNotification alloc] initWithTaskIdentifier:self.identifier delay:0],
             [[MRTaskNotification alloc] initWithTaskIdentifier:self.identifier delay:1],
             [[MRTaskNotification alloc] initWithTaskIdentifier:self.identifier delay:4],
             [[MRTaskNotification alloc] initWithTaskIdentifier:self.identifier delay:9],
             [[MRTaskNotification alloc] initWithTaskIdentifier:self.identifier delay:29],
             [[MRTaskNotification alloc] initWithTaskIdentifier:self.identifier delay:59]
    ];
}

@end
