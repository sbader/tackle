//
//  MRNotificationProvider.h
//  Tackle
//
//  Created by Scott Bader on 1/8/15.
//  Copyright (c) 2015 Melody Road. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Task.h"

@interface MRNotificationProvider : NSObject

+ (instancetype)sharedProvider;
- (void)rescheduleAllNotificationsWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;
- (void)rescheduleNotificationForTask:(Task *)task;
- (void)scheduleNotificationForTask:(Task *)task;
- (void)cancelNotificationForTask:(Task *)task;

@end
