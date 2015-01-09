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

- (void) awakeFromInsert {
    [super awakeFromInsert];
    self.createdDate = [NSDate date];
}

+ (Task *)insertItemWithTitle:(NSString*)title dueDate:(NSDate *)dueDate inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    Task *task = [NSEntityDescription insertNewObjectForEntityForName:@"Task"
                                               inManagedObjectContext:managedObjectContext];

    task.title = title;
    task.dueDate = dueDate;

    return task;
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
