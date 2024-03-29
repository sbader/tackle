//
//  MRTaskTableViewController.h
//  Tackle
//
//  Created by Scott Bader on 12/27/14.
//  Copyright (c) 2014 Melody Road. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MRTaskTableViewDelegate.h"
#import "MRPersistenceController.h"

@class Task;

@interface MRTaskTableViewController : UITableViewController

- (instancetype)initWithPersistenceController:(MRPersistenceController *)persistenceController;
- (void)refreshTasks;

@property (nonatomic) id<MRTaskTableViewDelegate> taskDelegate;

@end