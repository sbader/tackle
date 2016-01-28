//
//  MRArchiveTableViewController.h
//  Tackle
//
//  Created by Scott Bader on 1/27/16.
//  Copyright © 2016 Melody Road. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MRPersistenceController;
@protocol MRArchiveTaskTableViewDelegate;

@interface MRArchiveTableViewController : UITableViewController

- (instancetype)initWithPersistenceController:(MRPersistenceController *)persistenceController;

@property (nonatomic) id<MRArchiveTaskTableViewDelegate> archiveTaskDelegate;

@end
