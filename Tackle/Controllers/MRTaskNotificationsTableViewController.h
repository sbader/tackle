//
//  MRTaskNotificationsTableViewController.h
//  Tackle
//
//  Created by Scott Bader on 2/6/16.
//  Copyright © 2016 Melody Road. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Task;
@class MRPersistenceController;
@protocol MRTaskNotificationsTableViewControllerDelegate;

@interface MRTaskNotificationsTableViewController : UITableViewController

@property (weak) id<MRTaskNotificationsTableViewControllerDelegate> taskNotificationTableViewControllerDelegate;;
- (instancetype)initWithPersistenceController:(MRPersistenceController *)persistenceController;
- (void)displayTask:(Task *)task;

@end

@protocol MRTaskNotificationsTableViewControllerDelegate <NSObject>

- (void)addTenMinutesForTask:(Task *)task;
- (void)addOneHourForTask:(Task *)task;
- (void)addOneDayForTask:(Task *)task;
- (void)completedTask:(Task *)task;

@end