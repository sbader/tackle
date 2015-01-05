//
//  MRTaskTableViewDelegate.h
//  Tackle
//
//  Created by Scott Bader on 1/4/15.
//  Copyright (c) 2015 Melody Road. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Task.h"

@protocol MRTaskTableViewDelegate <NSObject>

- (void)selectedTask:(Task *)task;

@optional

- (void)completedTask:(Task *)task;

@end