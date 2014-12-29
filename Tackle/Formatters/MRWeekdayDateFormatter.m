//
//  MRDayOfWeekDateFormatter.m
//  Tackle
//
//  Created by Scott Bader on 12/28/14.
//  Copyright (c) 2014 Melody Road. All rights reserved.
//

#import "MRWeekdayDateFormatter.h"

@implementation MRWeekdayDateFormatter

+ (instancetype)sharedFormatter {
    static MRWeekdayDateFormatter *formatter;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[self alloc] init];
        formatter.dateFormat = @"cccc";
    });

    return formatter;
}

@end
