//
//  MRTaskEditView.h
//  Tackle
//
//  Created by Scott Bader on 1/25/14.
//  Copyright (c) 2014 Melody Road. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MRTaskEditViewDelegate;

@interface MRTaskEditView : UIView

@property (assign, nonatomic) id <MRTaskEditViewDelegate> delegate;
@property (strong, nonatomic) UITextField *textField;
@property (strong, nonatomic) UIButton *addTenMinutesButton;
@property (strong, nonatomic) UIButton *addOneHourButton;
@property (strong, nonatomic) UIButton *addOneDayButton;
@property (strong, nonatomic) UIButton *submitButton;
@property (strong, nonatomic) UIButton *dueDateButton;
@property (strong, nonatomic) UIDatePicker *datePicker;
@property (strong, nonatomic) UIView *bottomButtonView;
@property (strong, nonatomic) NSDate *dueDate;

- (void)showBottomMaskView;
- (void)hideBottomMaskView;
- (void)resetContent;
- (void)setDueDate:(NSDate *)dueDate animated:(BOOL)animated;
- (void)showDatePickerAnimated:(BOOL)animated;
- (void)hideDatePickerAnimated:(BOOL)animated;

@end

@protocol MRTaskEditViewDelegate <NSObject>

@required

- (void)taskEditViewDidReturnWithText:(NSString *)text dueDate:(NSDate *)dueDate;

@end

