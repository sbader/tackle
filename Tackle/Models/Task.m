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
NSString * const kMRAddOneHourActionIdentifier = @"addOneHourAction";
NSString * const kMRTaskNotificationCategoryIdentifier = @"taskNotificationCategory";

@implementation Task

@dynamic title;
@dynamic dueDate;
@dynamic isDone;
@dynamic createdDate;
@dynamic completedDate;
@dynamic identifier;

- (void) awakeFromInsert {
    [super awakeFromInsert];
    self.createdDate = [NSDate date];
}

+ (Task *)insertItemWithTitle:(NSString *)title dueDate:(NSDate *)dueDate identifier:(NSString *)identifier inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    Task *task = [NSEntityDescription insertNewObjectForEntityForName:@"Task"
                                               inManagedObjectContext:managedObjectContext];

    task.title = title;
    task.dueDate = dueDate;
    task.identifier = identifier;

    return task;
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

@end
