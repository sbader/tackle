//
//  MRAddTimeTableViewController.h
//  Tackle
//
//  Created by Scott Bader on 12/28/14.
//  Copyright (c) 2014 Melody Road. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MRTimeInterval.h"
@protocol MRTimeIntervalSelectionDelegate;

@interface MRAddTimeTableViewController : UITableViewController

@property (nonatomic) id<MRTimeIntervalSelectionDelegate> timeIntervalDelegate;

@end

@protocol MRTimeIntervalSelectionDelegate <NSObject>

- (void)selectedTimeInterval:(MRTimeInterval *)timeInterval;

@end
