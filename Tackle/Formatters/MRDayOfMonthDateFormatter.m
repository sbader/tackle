//
//  MRDayOfMonthDateFormatter.m
//  Tackle
//
//  Created by Scott Bader on 12/28/14.
//  Copyright (c) 2014 Melody Road. All rights reserved.
//

#import "MRDayOfMonthDateFormatter.h"

@implementation MRDayOfMonthDateFormatter

+ (instancetype)sharedFormatter {
    static MRDayOfMonthDateFormatter *formatter;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[self alloc] init];
        formatter.dateFormat = @"d";
    });

    return formatter;
}

@end
