//
//  MRTaskEditViewController.h
//  Tackle
//
//  Created by Scott Bader on 12/27/14.
//  Copyright (c) 2014 Melody Road. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Task.h"

@protocol MRTaskEditingDelegate;

@interface MRTaskEditViewController : UIViewController

- (instancetype)initWithTitle:(NSString *)title dueDate:(NSDate *)dueDate managedObjectContext:(NSManagedObjectContext *)managedObjectContext;

@property (nonatomic) id<MRTaskEditingDelegate> delegate;

@end

@protocol MRTaskEditingDelegate <NSObject>

- (void)editedTaskTitle:(NSString *)title dueDate:(NSDate *)dueDate;
- (void)completedTask;

@end
