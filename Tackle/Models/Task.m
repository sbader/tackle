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

+ (Task *)insertItemWithTitle:(NSString*)title dueDate:(NSDate *)dueDate identifier:(NSString *)identifier inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    Task *task = [NSEntityDescription insertNewObjectForEntityForName:@"Task"
                                               inManagedObjectContext:managedObjectContext];

    task.title = title;
    task.dueDate = dueDate;
    task.identifier = identifier;

    return task;
}

+ (Task *)firstOpenTaskInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Task" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchLimit:1];

    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dueDate" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];

    [fetchRequest setSortDescriptors:sortDescriptors];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"isDone == NO"]];

    NSError *error;
    NSArray *tasks = [managedObjectContext executeFetchRequest:fetchRequest error:&error];

    if (tasks.count > 0) {
        return tasks[0];
    }

    return nil;
}

+ (Task *)findTaskWithUniqueId:(NSString *)uniqueId inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectID *managedObjectId = [[managedObjectContext persistentStoreCoordinator] managedObjectIDForURIRepresentation:[NSURL URLWithString:uniqueId]];
    NSError *error;
    return (Task *)[managedObjectContext existingObjectWithID:managedObjectId error:&error];
}

+ (Task *)findTaskWithIdentifier:(NSString *)identifier inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext  {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Task" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchLimit:1];

    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"identifier == %@", identifier]];

    NSError *error;
    NSArray *tasks = [managedObjectContext executeFetchRequest:fetchRequest error:&error];

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

    return [managedObjectContext countForFetchRequest:fetchRequest error:nil];
}

+ (NSInteger)numberOfCompletedTasksInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Task" inManagedObjectContext:managedObjectContext];
    fetchRequest.entity = entity;
    fetchRequest.includesPropertyValues = NO;
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"isDone == YES"];

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

- (void)markAsDone {
    [self setIsDone:YES];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ %@", self.title, self.dueDate];
}

@end
