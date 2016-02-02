//
//  MRNotificationTaskView.h
//  Tackle
//
//  Created by Scott Bader on 2/2/16.
//  Copyright © 2016 Melody Road. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MRNotificationTaskViewDelegate;

@interface MRNotificationTaskView : UIView

@property (weak) id<MRNotificationTaskViewDelegate> notificationTaskViewDelegate;
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UILabel *detailLabel;

@end

@protocol MRNotificationTaskViewDelegate <NSObject>

- (void)addTenMinutesButtonWasTappedWithView:(MRNotificationTaskView *)cell;
- (void)addOneHourButtonWasTappedWithView:(MRNotificationTaskView *)cell;
- (void)addOneDayButtonWasTappedWithView:(MRNotificationTaskView *)cell;
- (void)doneButtonWasTappedWithView:(MRNotificationTaskView *)cell;

@end