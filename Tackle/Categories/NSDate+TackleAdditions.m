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
#import "MRFullDateFormatter.h"

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
    return [self isTodayToDate:[NSDate date]];
}

- (BOOL)isTodayToDate:(NSDate *)date {
    NSDate *beginningOfToday = [date beginningOfDay];
    return [beginningOfToday compare:[self beginningOfDay]] == NSOrderedSame;
}

- (BOOL)isWithinAWeek {
    return [self isWithinAWeekOfDate:[NSDate date]];
}

- (BOOL)isWithinAWeekOfDate:(NSDate *)date {
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.day = 7;

    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *week = [calendar dateByAddingComponents:dayComponent toDate:[date beginningOfDay] options:0];

    return [[date beginningOfDay] compare:[self beginningOfDay]] == NSOrderedAscending && [week compare:[self beginningOfDay]] == NSOrderedDescending;
}

- (BOOL)isTomorrow {
    return [self isTomorrowToDate:[NSDate date]];
}

- (BOOL)isTomorrowToDate:(NSDate *)date {
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.day = 1;

    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *tomorrow = [calendar dateByAddingComponents:dayComponent toDate:[date beginningOfDay] options:0];
    return [tomorrow compare:[self beginningOfDay]] == NSOrderedSame;
}

- (BOOL)isCurrentYear {
    return [self isSameDayAsDate:[NSDate date]];
}

- (BOOL)isSameYearAsDate:(NSDate *)date {
    return [[date beginningOfYear] compare:[self beginningOfYear]] == NSOrderedSame;
}

- (NSDate *)beginningOfDay {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:self];
    NSDate *beginningOfDay = [calendar dateFromComponents:components];

    return beginningOfDay;
}

- (NSDate *)beginningOfYear {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear) fromDate:self];
    NSDate *beginningOfYear = [calendar dateFromComponents:components];

    return beginningOfYear;
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
            formattedString = [NSString stringWithFormat:NSLocalizedString(@"Hours Ago Format", nil), [numberFormatter stringFromNumber:@(hours)]];
        }
        else if (minutes > 0 && seconds > 0) {
            formattedString = [NSString stringWithFormat:NSLocalizedString(@"Minutes And Seconds Ago Format", nil), [numberFormatter stringFromNumber:@(minutes)], [numberFormatter stringFromNumber:@(seconds)]];
        }
        else if (minutes > 0) {
            formattedString = [NSString stringWithFormat:NSLocalizedString(@"Minutes Ago Format", nil), [numberFormatter stringFromNumber:@(minutes)]];
        }
        else {
            formattedString = [NSString stringWithFormat:NSLocalizedString(@"Seconds Ago Format", nil), [numberFormatter stringFromNumber:@(seconds)]];
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
            formattedString = [NSString stringWithFormat:NSLocalizedString(@"Minutes And Seconds In Future Format", nil), [numberFormatter stringFromNumber:@(minutes)], [numberFormatter stringFromNumber:@(seconds)]];
        }
        else if (minutes > 0) {
            formattedString = [NSString stringWithFormat:NSLocalizedString(@"Minutes In Future Format", nil), [numberFormatter stringFromNumber:@(minutes)]];
        }
        else {
            formattedString = [NSString stringWithFormat:NSLocalizedString(@"Seconds In Future Format", nil), [numberFormatter stringFromNumber:@(seconds)]];
        }
    }
    else if ([self isSameDayAsDate:date]) {
        MRTimeDateFormatter *timeFormatter = [MRTimeDateFormatter sharedInstance];
        NSString *time = [timeFormatter stringFromDate:self];

        formattedString = time;
    }
    else if ([self isDayBeforeOrAfterDate:date]) {
        MRShortDateFormatter *formatter = [MRShortDateFormatter sharedInstance];
        NSString *relativeDay = [formatter stringFromDate:self];

        MRTimeDateFormatter *timeFormatter = [MRTimeDateFormatter sharedInstance];
        NSString *time = [timeFormatter stringFromDate:self];

        formattedString = [NSString stringWithFormat:NSLocalizedString(@"Full Time And Date Format", nil), relativeDay, time];
    }
    else if ([self isWithinAWeekOfDate:date]) {
        MRMediumDateFormatter *formatter = [MRMediumDateFormatter sharedInstance];
        NSString *weekday = [formatter stringFromDate:self];

        MRTimeDateFormatter *timeFormatter = [MRTimeDateFormatter sharedInstance];
        NSString *time = [timeFormatter stringFromDate:self];

        formattedString = [NSString stringWithFormat:NSLocalizedString(@"Full Time And Date Format", nil), weekday, time];
    }
    else if ([self isSameYearAsDate:date]) {
        MRLongDateFormatter *formatter = [MRLongDateFormatter sharedInstance];
        NSString *date = [formatter stringFromDate:self];

        MRTimeDateFormatter *timeFormatter = [MRTimeDateFormatter sharedInstance];
        NSString *time = [timeFormatter stringFromDate:self];

        formattedString = [NSString stringWithFormat:NSLocalizedString(@"Full Time And Date Format", nil), date, time];
    }
    else {
        MRFullDateFormatter *formatter = [MRFullDateFormatter sharedFormatter];
        NSString *date = [formatter stringFromDate:self];

        formattedString = date;
    }

    return formattedString;
}

- (NSString *)tackleString {
    return [self tackleStringSinceDate:[NSDate date]];
}

@end
