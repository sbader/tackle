//
//  MRAddTimeTableViewController.h
//  Tackle
//
//  Created by Scott Bader on 12/28/14.
//  Copyright (c) 2014 Melody Road. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MRTimeInterval.h"
@protocol MRTaskEditTableViewDelegate;

@interface MRTaskEditTableViewController : UITableViewController

@property (nonatomic) id<MRTaskEditTableViewDelegate> delegate;

- (instancetype)initWithDoneButtonEnabled:(BOOL)doneButtonEnabled previousTasksEnabled:(BOOL)previousTasksEnabled managedObjectContext:(NSManagedObjectContext *)managedObjectContext;

@end

@protocol MRTaskEditTableViewDelegate <NSObject>

- (void)selectedDone;
- (void)selectedTimeInterval:(MRTimeInterval *)timeInterval;
- (void)selectedPreviousTaskTitle:(NSString *)title;

@end
