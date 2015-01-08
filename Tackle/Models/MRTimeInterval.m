//
//  MRTimeInterval.m
//  Tackle
//
//  Created by Scott Bader on 12/29/14.
//  Copyright (c) 2014 Melody Road. All rights reserved.
//

#import "MRTimeInterval.h"

@implementation MRTimeInterval

+ (instancetype)timeIntervalWithName:(NSString *)name icon:(UIImage *)icon unit:(NSCalendarUnit)unit interval:(NSUInteger)interval {
    MRTimeInterval *timeInterval = [[MRTimeInterval alloc] init];
    timeInterval.name = name;
    timeInterval.unit = unit;
    timeInterval.interval = interval;
    timeInterval.icon = icon;

    return timeInterval;
}

@end
