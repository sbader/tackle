//
//  MRPreviousTasksTableViewController.h
//  Tackle
//
//  Created by Scott Bader on 1/4/15.
//  Copyright (c) 2015 Melody Road. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MRTaskTableViewDelegate.h"

@interface MRPreviousTasksTableViewController : UITableViewController

@property (nonatomic) id<MRTaskTableViewDelegate> taskDelegate;
- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

@end
