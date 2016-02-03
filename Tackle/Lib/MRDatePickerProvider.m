//
//  MRDatePickerProvider.m
//  Tackle
//
//  Created by Scott Bader on 2/3/16.
//  Copyright © 2016 Melody Road. All rights reserved.
//

#import "MRDatePickerProvider.h"

@interface MRDatePickerProvider ()

@end

@implementation MRDatePickerProvider

+ (instancetype)sharedInstance {
    static MRDatePickerProvider *instance;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });

    return instance;
}

- (instancetype)init {
    self = [super init];

    if (self) {
        self.datePicker = [[UIDatePicker alloc] init];
        self.datePicker.translatesAutoresizingMaskIntoConstraints = NO;
        self.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        self.datePicker.minimumDate = [NSDate date];
        self.datePicker.minuteInterval = 5;
    }

    return self;
}

@end
