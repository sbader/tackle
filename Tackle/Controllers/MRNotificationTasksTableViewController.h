//
//  MRNotificationTasksTableViewController.h
//  Tackle
//
//  Created by Scott Bader on 1/30/16.
//  Copyright © 2016 Melody Road. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Task.h"

@class MRPersistenceController;
@protocol MRNotificationTasksTableViewDelegate;

@interface MRNotificationTasksTableViewController : UITableViewController

@property (weak) id<MRNotificationTasksTableViewDelegate> notificationTasksTableViewDelegate;

- (instancetype)initWithPersistenceController:(MRPersistenceController *)persistenceController;
- (void)displayTask:(Task *)task;

@end

@protocol MRNotificationTasksTableViewDelegate <NSObject>

- (void)addTenMinutesForTask:(Task *)task;
- (void)addOneHourForTask:(Task *)task;
- (void)addOneDayForTask:(Task *)task;
- (void)completedTask:(Task *)task;

@end