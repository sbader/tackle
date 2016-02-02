//
//  MRNotificationTaskTableViewCell.h
//  Tackle
//
//  Created by Scott Bader on 1/30/16.
//  Copyright © 2016 Melody Road. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MRNotificationTaskTableViewCellDelegate;

@interface MRNotificationTaskTableViewCell : UITableViewCell

@property (weak) id<MRNotificationTaskTableViewCellDelegate> taskCellDelegate;

@end

@protocol MRNotificationTaskTableViewCellDelegate <NSObject>

- (void)addTenMinutesButtonWasTappedWithCell:(MRNotificationTaskTableViewCell *)cell;
- (void)addOneHourButtonWasTappedWithCell:(MRNotificationTaskTableViewCell *)cell;
- (void)addOneDayButtonWasTappedWithCell:(MRNotificationTaskTableViewCell *)cell;
- (void)doneButtonWasTappedWithCell:(MRNotificationTaskTableViewCell *)cell;

@end
