//
//  Task.h
//  Tackle
//
//  Created by Scott Bader on 1/22/14.
//  Copyright (c) 2014 Melody Road. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Task : NSManagedObject

@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSDate * dueDate;
@property (nonatomic) BOOL isDone;


- (BOOL)scheduleNotification;
- (void)markAsDone;
- (void)cancelNotification;
- (void)rescheduleNotification;

@end
