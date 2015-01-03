//
//  MRDatePickerViewController.h
//  Tackle
//
//  Created by Scott Bader on 12/30/14.
//  Copyright (c) 2014 Melody Road. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MRDatePickerViewControllerDelegate;

@interface MRDatePickerViewController : UIViewController

@property (nonatomic) id<MRDatePickerViewControllerDelegate> delegate;

- (instancetype)initWithDate:(NSDate *)date;

@end

@protocol MRDatePickerViewControllerDelegate

- (void)didSelectDate:(NSDate *)date;

@end