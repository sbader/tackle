//
//  MRTaskTableViewController.h
//  Tackle
//
//  Created by Scott Bader on 12/27/14.
//  Copyright (c) 2014 Melody Road. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Task;
@protocol MRTaskEditingDelegate;

@interface MRTaskTableViewController : UITableViewController

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

@property (nonatomic) id<MRTaskEditingDelegate> taskEditingDelegate;

@end

@protocol MRTaskEditingDelegate <NSObject>

- (void)editTask:(Task *)task;

@end