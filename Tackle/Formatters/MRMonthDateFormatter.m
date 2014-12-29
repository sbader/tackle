//
//  MRMonthDateFormatter.m
//  Tackle
//
//  Created by Scott Bader on 12/29/14.
//  Copyright (c) 2014 Melody Road. All rights reserved.
//

#import "MRMonthDateFormatter.h"

@implementation MRMonthDateFormatter

+ (instancetype)sharedFormatter {
    static MRMonthDateFormatter *formatter;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[self alloc] init];
        formatter.dateFormat = @"LLL";
    });

    return formatter;
}

@end
