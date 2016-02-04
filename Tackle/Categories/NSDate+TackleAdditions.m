//
//  NSDate+TackleAdditions.m
//  Tackle
//
//  Created by Scott Bader on 2/5/14.
//  Copyright (c) 2014 Melody Road. All rights reserved.
//

#import "NSDate+TackleAdditions.h"

#import "MRShortDateFormatter.h"
#import "MRLongDateFormatter.h"
#import "MRMediumDateFormatter.h"
#import "MRTimeDateFormatter.h"

@implementation NSDate (TackleAdditions)

- (BOOL)isDayBeforeDate:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:date];
    components.day =  components.day -1;

    NSDate *dayBefore = [calendar dateFromComponents:components];

    NSDate *beginningOfDay = [self beginningOfDay];

    return [dayBefore compare:beginningOfDay] == NSOrderedSame;
}

- (BOOL)isDayAfterDate:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitMonth|NSCalendarUnitYear|NSCalendarUnitDay) fromDate:date];
    components.day = components.day + 1;

    NSDate *dayAfter = [calendar dateFromComponents:components];

    NSDate *beginningOfDay = [self beginningOfDay];

    return [dayAfter compare:beginningOfDay] == NSOrderedSame;
}

- (BOOL)isDayBeforeOrAfterDate:(NSDate *)date {
    return [self isDayBeforeDate:date] || [self isDayAfterDate:date];
}

- (BOOL)isSameDayAsDate:(NSDate *)date {
    NSDate *beginningOfDate = [date beginningOfDay];
    return [beginningOfDate compare:[self beginningOfDay]] == NSOrderedSame;
}

- (BOOL)isToday {
    NSDate *beginningOfToday = [[NSDate date] beginningOfDay];
    return [beginningOfToday compare:[self beginningOfDay]] == NSOrderedSame;
}

- (BOOL)isWithinAWeek {
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.day = 7;

    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *week = [calendar dateByAddingComponents:dayComponent toDate:[[NSDate date] beginningOfDay] options:0];
    return [week compare:[self beginningOfDay]] == NSOrderedDescending;
}

- (BOOL)isTomorrow {
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.day = 1;

    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *tomorrow = [calendar dateByAddingComponents:dayComponent toDate:[[NSDate date] beginningOfDay] options:0];
    return [tomorrow compare:[self beginningOfDay]] == NSOrderedSame;
}

- (NSDate *)beginningOfDay {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:self];
    NSDate *beginningOfDay = [calendar dateFromComponents:components];

    return beginningOfDay;
}

- (NSArray *)tackleStringComponentsSinceDate:(NSDate *)date {
    NSString *formattedString;
    NSTimeInterval timeInterval = ceil([self timeIntervalSinceDate:date]);

    NSString *firstComponent;
    NSString *secondComponent;

    if (timeInterval > -86400 && timeInterval < 0) {
        timeInterval = ABS(timeInterval);
        NSNumber *hours = [[NSNumber alloc] initWithInt:timeInterval/3600];
        NSNumber *minutes = [[NSNumber alloc] initWithInt:(timeInterval - ([hours integerValue] * 3600)) / 60];
        NSNumber *seconds = [[NSNumber alloc] initWithInt:timeInterval - 60 * [minutes integerValue] - 3600 * [hours integerValue]];

        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];

        if ([hours integerValue] > 0) {
            formattedString = [NSString stringWithFormat:@"%@ hours ago", [numberFormatter stringFromNumber:hours]];
        }
        else if ([minutes integerValue] > 0 && [seconds integerValue] > 0) {
            formattedString = [NSString stringWithFormat:@"%@ minutes %@ seconds ago", [numberFormatter stringFromNumber:minutes], [numberFormatter stringFromNumber:seconds]];
        }
        else if ([minutes integerValue] > 0) {
            formattedString = [NSString stringWithFormat:@"%@ minutes ago", [numberFormatter stringFromNumber:minutes]];
        }
        else {
            formattedString = [NSString stringWithFormat:@"%@ seconds ago", [numberFormatter stringFromNumber:seconds]];
        }

        firstComponent = formattedString;
    }
    else if (timeInterval < 3600) {
        NSNumber *hours = [[NSNumber alloc] initWithInteger:timeInterval/3600];
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];

        NSNumber *minutes;
        NSNumber *seconds;

        if (timeInterval < 60) {
            minutes = @(0);
            seconds = [[NSNumber alloc] initWithInteger:timeInterval - 60 * [minutes integerValue] - 3600 * [hours integerValue]];
        }
        else {
            NSInteger minutesInt = (timeInterval - ([hours integerValue] * 3600)) / 60;
            seconds = @(0);
            NSInteger sec = timeInterval - 60 * [minutes integerValue] - 3600 * [hours integerValue];

            if (sec > 0) {
                minutesInt = minutesInt + 1;
            }

            minutes = [[NSNumber alloc] initWithInteger:minutesInt];
        }

        if ([minutes integerValue] > 0 && [seconds integerValue] > 0) {
            formattedString = [NSString stringWithFormat:@"In %@ Minutes %@ Seconds", [numberFormatter stringFromNumber:minutes], [numberFormatter stringFromNumber:seconds]];
        }
        else if ([minutes integerValue] > 0) {
            formattedString = [NSString stringWithFormat:@"In %@ Minutes", [numberFormatter stringFromNumber:minutes]];
        }
        else {
            formattedString = [NSString stringWithFormat:@"In %@ Seconds", [numberFormatter stringFromNumber:seconds]];
        }
        firstComponent = formattedString;
    }
    else if ([self isSameDayAsDate:date]) {
        MRTimeDateFormatter *timeFormatter = [MRTimeDateFormatter sharedInstance];
        NSString *time = [timeFormatter stringFromDate:self];

        firstComponent = @"Today";
        secondComponent = time;
    }
    else if ([self isDayBeforeOrAfterDate:date]) {
        MRShortDateFormatter *formatter = [MRShortDateFormatter sharedInstance];
        NSString *relativeDay = [formatter stringFromDate:self];

        MRTimeDateFormatter *timeFormatter = [MRTimeDateFormatter sharedInstance];
        NSString *time = [timeFormatter stringFromDate:self];

        firstComponent = relativeDay;
        secondComponent = time;
    }
    else if([self isWithinAWeek]) {
        MRMediumDateFormatter *formatter = [MRMediumDateFormatter sharedInstance];
        NSString *weekday = [formatter stringFromDate:self];

        MRTimeDateFormatter *timeFormatter = [MRTimeDateFormatter sharedInstance];
        NSString *time = [timeFormatter stringFromDate:self];

        firstComponent = weekday;
        secondComponent = time;
    }
    else {
        MRLongDateFormatter *formatter = [MRLongDateFormatter sharedInstance];
        NSString *date = [formatter stringFromDate:self];

        MRTimeDateFormatter *timeFormatter = [MRTimeDateFormatter sharedInstance];
        NSString *time = [timeFormatter stringFromDate:self];

        firstComponent = date;
        secondComponent = time;
    }

    if (firstComponent && secondComponent) {
        return @[firstComponent, secondComponent];
    }
    else if (secondComponent) {
        return @[secondComponent];
    }
    else if (firstComponent) {
        return @[firstComponent];
    }

    return @[];
}

- (NSString *)tackleStringSinceDate:(NSDate *)date {
    NSString *formattedString;
    NSTimeInterval timeInterval = ceil([self timeIntervalSinceDate:date]);

    if (timeInterval > -86400 && timeInterval < 0) {
        timeInterval = ABS(timeInterval);
        NSInteger hours = timeInterval/3600;
        NSInteger minutes = (timeInterval - (hours * 3600)) / 60;
        NSInteger seconds = timeInterval - 60 * minutes - 3600 * hours;
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];

        if (hours > 0) {
            formattedString = [NSString stringWithFormat:@"%@ Hours Ago", [numberFormatter stringFromNumber:@(hours)]];
        }
        else if (minutes > 0 && seconds > 0) {
            formattedString = [NSString stringWithFormat:@"%@ Minutes %@ Seconds Ago", [numberFormatter stringFromNumber:@(minutes)], [numberFormatter stringFromNumber:@(seconds)]];
        }
        else if (minutes > 0) {
            formattedString = [NSString stringWithFormat:@"%@ Minutes Ago", [numberFormatter stringFromNumber:@(minutes)]];
        }
        else {
            formattedString = [NSString stringWithFormat:@"%@ Seconds Ago", [numberFormatter stringFromNumber:@(seconds)]];
        }
    }
    else if (timeInterval >= 0 && timeInterval < 3600) {
        NSInteger hours = timeInterval/3600;
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];

        NSInteger minutes = 0;
        NSInteger seconds = 0;

        if (timeInterval < 60) {
            seconds = timeInterval;
        }
        else {
            minutes = (timeInterval - (hours * 3600)) / 60;
            seconds = timeInterval - 60 * minutes - 3600 * hours;
        }

        if (minutes > 0 && seconds > 0) {
            formattedString = [NSString stringWithFormat:@"In %@ Minutes %@ Seconds", [numberFormatter stringFromNumber:@(minutes)], [numberFormatter stringFromNumber:@(seconds)]];
        }
        else if (minutes > 0) {
            formattedString = [NSString stringWithFormat:@"In %@ Minutes", [numberFormatter stringFromNumber:@(minutes)]];
        }
        else {
            formattedString = [NSString stringWithFormat:@"In %@ Seconds", [numberFormatter stringFromNumber:@(seconds)]];
        }
    }
    else if ([self isSameDayAsDate:date]) {
        MRTimeDateFormatter *timeFormatter = [MRTimeDateFormatter sharedInstance];
        NSString *time = [timeFormatter stringFromDate:self];

        formattedString = [NSString stringWithFormat:@"%@", time];
    }
    else if ([self isDayBeforeOrAfterDate:date]) {
        MRShortDateFormatter *formatter = [MRShortDateFormatter sharedInstance];
        NSString *relativeDay = [formatter stringFromDate:self];

        MRTimeDateFormatter *timeFormatter = [MRTimeDateFormatter sharedInstance];
        NSString *time = [timeFormatter stringFromDate:self];

        formattedString = [NSString stringWithFormat:@"%@ at %@", relativeDay, time];
    }
    else if([self isWithinAWeek]) {
        MRMediumDateFormatter *formatter = [MRMediumDateFormatter sharedInstance];
        NSString *weekday = [formatter stringFromDate:self];

        MRTimeDateFormatter *timeFormatter = [MRTimeDateFormatter sharedInstance];
        NSString *time = [timeFormatter stringFromDate:self];

        formattedString = [NSString stringWithFormat:@"%@ at %@", weekday, time];
    }
    else {
        MRLongDateFormatter *formatter = [MRLongDateFormatter sharedInstance];
        NSString *date = [formatter stringFromDate:self];

        MRTimeDateFormatter *timeFormatter = [MRTimeDateFormatter sharedInstance];
        NSString *time = [timeFormatter stringFromDate:self];

        formattedString = [NSString stringWithFormat:@"%@ at %@", date, time];
    }

    return formattedString;
}

- (NSString *)tackleString {
    return [self tackleStringSinceDate:[NSDate date]];
}

@end
