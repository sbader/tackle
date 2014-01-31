//
//  TackTaskEditView.h
//  Tackle
//
//  Created by Scott Bader on 1/25/14.
//  Copyright (c) 2014 Melody Road. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TackTaskEditView : UIView

@property (strong, nonatomic) UITextField *textField;

@property (strong, nonatomic) UIButton *addTenMinutesButton;
@property (strong, nonatomic) UIButton *addOneHourButton;
@property (strong, nonatomic) UIButton *addOneDayButton;
@property (strong, nonatomic) UIButton *submitButton;
@property (strong, nonatomic) UIButton *dueDateButton;

@end
