//
//  MRTodayTableViewController.h
//  Tackle
//
//  Created by Scott Bader on 1/8/15.
//  Copyright (c) 2015 Melody Road. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MRTodayTableViewController : UITableViewController

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end
