//
//  MRRepeatIntervalPickerViewController.h
//  Tackle
//
//  Created by Scott Bader on 8/23/17.
//  Copyright © 2017 Melody Road. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"

@protocol MRRepeatIntervalPickerControllerDelegate;

@interface MRRepeatIntervalPickerViewController : UIViewController

@property (nonatomic) id<MRRepeatIntervalPickerControllerDelegate> delegate;

- (instancetype)initWithRepeatInterval:(TaskRepeatInterval)repeatInterval;

@end

@protocol MRRepeatIntervalPickerControllerDelegate

- (void)didSelectRepeatInterval:(TaskRepeatInterval)repeatInterval;

@end
