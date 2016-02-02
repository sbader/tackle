//
//  MRNotificationsTaskListViewController.h
//  Tackle
//
//  Created by Scott Bader on 2/2/16.
//  Copyright © 2016 Melody Road. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MRPersistenceController;
@class Task;
@protocol MRNotificationsTaskListDelegate;

@interface MRNotificationsTaskListViewController : UIViewController

@property (weak) id<MRNotificationsTaskListDelegate> notificationsTaskListDelegate;
- (instancetype)initWithPersistenceController:(MRPersistenceController *)persistenceController;
- (void)displayTask:(Task *)task;

@end

@protocol MRNotificationsTaskListDelegate <NSObject>

- (void)addTenMinutesForTask:(Task *)task;
- (void)addOneHourForTask:(Task *)task;
- (void)addOneDayForTask:(Task *)task;
- (void)completedTask:(Task *)task;

@end
