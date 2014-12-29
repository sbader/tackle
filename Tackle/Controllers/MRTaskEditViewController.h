//
//  MRTaskEditViewController.h
//  Tackle
//
//  Created by Scott Bader on 12/27/14.
//  Copyright (c) 2014 Melody Road. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Task.h"

@interface MRTaskEditViewController : UIViewController

- (instancetype)initWithTitle:(NSString *)title dueDate:(NSDate *)dueDate;

@end
