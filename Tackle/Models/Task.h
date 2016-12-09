//
//  Task.h
//  Tackle
//
//  Created by Scott Bader on 1/22/14.
//  Copyright (c) 2014 Melody Road. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MRTaskNotification;

extern NSString * const kMRAddTenMinutesActionIdentifier;
extern NSString * const kMRDestroyTaskActionIdentifier;
extern NSString * const kMRTaskNotificationCategoryIdentifier;
extern NSString * const kMRAddOneHourActionIdentifier;

typedef NS_ENUM(NSInteger, TaskRepeatInterval) {
    TaskRepeatIntervalNone,
    TaskRepeatIntervalAllDays,
    TaskRepeatIntervalWeekdays
};

@interface Task : NSManagedObject

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSDate *dueDate;
@property (nonatomic, retain) NSDate *originalDueDate;
@property (nonatomic, retain) NSString *identifier;
@property (nonatomic, retain) NSDate *createdDate;
@property (nonatomic, retain) NSDate *completedDate;
@property (nonatomic, retain) NSNumber *repeats;
@property (nonatomic) BOOL isDone;

- (Task *)createRepeatedTaskInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;
+ (Task *)findTaskWithIdentifier:(NSString *)identifier inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;
+ (Task *)findTaskWithTaskNotificationIdentifier:(NSString *)taskNotificationIdentifier inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;
+ (NSInteger)numberOfOpenTasksInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;
+ (NSFetchRequest *)allTasksFetchRequestWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;
+ (NSFetchRequest *)openTasksFetchRequestWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;
+ (NSFetchRequest *)passedOpenTasksFetchRequestWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;
+ (NSFetchRequest *)archivedTasksFetchRequestWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

- (NSDateComponents *)dueDateComponents;
- (NSArray<MRTaskNotification *> *)taskNotifications;

@end
