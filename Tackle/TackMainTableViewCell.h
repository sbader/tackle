//
//  TackMainTableViewCell.h
//  Tackle
//
//  Created by Scott Bader on 1/22/14.
//  Copyright (c) 2014 Melody Road. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Task.h"

@protocol TackMainTableViewCellDelegate;

@interface TackMainTableViewCell : UITableViewCell

@property (strong, nonatomic) Task *task;

@property (assign, nonatomic) id <TackMainTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *taskTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *dueDateLabel;

- (void)updateTask:(Task *)task;
- (IBAction)markAsDone:(id)sender;

@end

@protocol TackMainTableViewCellDelegate <NSObject>

@optional

- (void)markAsDone:(TackMainTableViewCell *)cell;

@end
