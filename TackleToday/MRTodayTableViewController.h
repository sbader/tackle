//
//  MRTodayTableViewController.h
//  Tackle
//
//  Created by Scott Bader on 1/8/15.
//  Copyright (c) 2015 Melody Road. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MRReadOnlyPersistenceController;

@interface MRTodayTableViewController : UITableViewController

- (instancetype)initWithPersistenceController:(MRReadOnlyPersistenceController *)persistenceController;

@end
