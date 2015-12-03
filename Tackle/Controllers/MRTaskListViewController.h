//
//  MRTaskListViewController.h
//  Tackle
//
//  Created by Scott Bader on 12/27/14.
//  Copyright (c) 2014 Melody Road. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MRPersistenceController.h"

@class Task;
@class MRConnectivityController;

@interface MRTaskListViewController : UIViewController

- (instancetype)initWithPersistenceController:(MRPersistenceController *)persistenceController connectivityController:(MRConnectivityController *)connectivityController;
- (void)handleNotificationForTask:(Task *)task;
- (void)refreshTasks;

@end
