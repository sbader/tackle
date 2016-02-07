//
//  MRTaskNotificationTableViewCell.h
//  Tackle
//
//  Created by Scott Bader on 2/6/16.
//  Copyright © 2016 Melody Road. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MRTaskNotificationTableViewCellDelegate;

@interface MRTaskNotificationTableViewCell : UITableViewCell

@property (weak) id<MRTaskNotificationTableViewCellDelegate> taskCellDelegate;

- (void)setTitle:(NSString *)title;
- (void)setDetail:(NSString *)detail;

@end

@protocol MRTaskNotificationTableViewCellDelegate <NSObject>

- (void)addTenMinutesButtonWasTappedWithCell:(MRTaskNotificationTableViewCell *)cell;
- (void)addOneHourButtonWasTappedWithCell:(MRTaskNotificationTableViewCell *)cell;
- (void)addOneDayButtonWasTappedWithCell:(MRTaskNotificationTableViewCell *)cell;
- (void)doneButtonWasTappedWithCell:(MRTaskNotificationTableViewCell *)cell;

@end
