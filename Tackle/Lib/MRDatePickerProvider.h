//
//  MRDatePickerProvider.h
//  Tackle
//
//  Created by Scott Bader on 2/3/16.
//  Copyright © 2016 Melody Road. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MRDatePickerProvider : NSObject

+ (instancetype)sharedInstance;
@property (nonatomic) UIDatePicker *datePicker;

@end
