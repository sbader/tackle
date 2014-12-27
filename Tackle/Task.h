//
//  Task.h
//  Tackle
//
//  Created by Scott Bader on 1/22/14.
//  Copyright (c) 2014 Melody Road. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

extern NSString * const kMRAddTenMinutesActionIdentifier;
extern NSString * const kMRDestroyTaskActionIdentifier;
extern NSString * const kMRTaskNotificationCategoryIdentifier;

@interface Task : NSManagedObject

@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSDate * dueDate;
@property (nonatomic) BOOL isDone;

+ (Task *)insertItemWithText:(NSString*)text dueDate:(NSDate *)dueDate inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;
- (BOOL)scheduleNotification;
- (void)markAsDone;
- (void)cancelNotification;
- (void)rescheduleNotification;

@end
