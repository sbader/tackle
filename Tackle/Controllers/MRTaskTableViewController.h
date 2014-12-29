//
//  MRTaskTableViewController.h
//  Tackle
//
//  Created by Scott Bader on 12/27/14.
//  Copyright (c) 2014 Melody Road. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Task;
@protocol MRTaskTableViewDelegate;

@interface MRTaskTableViewController : UITableViewController

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

@property (nonatomic) id<MRTaskTableViewDelegate> taskDelegate;

@end

@protocol MRTaskTableViewDelegate <NSObject>

- (void)selectedTask:(Task *)task;
- (void)completedTask:(Task *)task;

@end