//
//  MRRootViewController.h
//  Tackle
//
//  Created by Scott Bader on 12/27/14.
//  Copyright (c) 2014 Melody Road. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MRPersistenceController.h"

@class Task;

@interface MRRootViewController : UIViewController

- (instancetype)initWithPersistenceController:(MRPersistenceController *)persistenceController;
- (void)handleNotificationForTask:(Task *)task;
- (void)refreshTasks;
- (void)checkPermissions;

@end
