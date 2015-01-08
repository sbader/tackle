//
//  MRPreviousTasksTableViewController.h
//  Tackle
//
//  Created by Scott Bader on 1/4/15.
//  Copyright (c) 2015 Melody Road. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MRTaskTableViewDelegate.h"

@protocol MRPreviousTaskTitleDelegate;

@interface MRPreviousTasksTableViewController : UITableViewController

@property (nonatomic) id<MRPreviousTaskTitleDelegate> taskDelegate;
- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

@end

@protocol MRPreviousTaskTitleDelegate <NSObject>

- (void)selectedPreviousTaskTitle:(NSString *)title;

@end