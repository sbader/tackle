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

- (BOOL)isYesterday
{
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.day = -1;

    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *yesterday = [calendar dateByAddingComponents:dayComponent toDate:[[NSDate date] beginningOfDay] options:0];
    return [yesterday compare:[self beginningOfDay]] == NSOrderedSame;
}

- (BOOL)isToday
{
    NSDate *beginningOfToday = [[NSDate date] beginningOfDay];
    return [beginningOfToday compare:[self beginningOfDay]] == NSOrderedSame;
}

- (BOOL)isWithinAWeek
{
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.day = 7;

    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *week = [calendar dateByAddingComponents:dayComponent toDate:[[NSDate date] beginningOfDay] options:0];
    return [week compare:[self beginningOfDay]] == NSOrderedDescending;
}

- (BOOL)isTomorrow
{
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.day = 1;

    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *tomorrow = [calendar dateByAddingComponents:dayComponent toDate:[[NSDate date] beginningOfDay] options:0];
    return [tomorrow compare:[self beginningOfDay]] == NSOrderedSame;
}

- (NSDate *)beginningOfDay
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSMonthCalendarUnit|NSYearCalendarUnit|NSDayCalendarUnit) fromDate:self];

    return [calendar dateFromComponents:components];
}

- (NSString *)tackleString
{
    NSString *formattedString;
    NSTimeInterval timeInterval = [self timeIntervalSinceDate:[NSDate date]];

    if (timeInterval < 3600) {
        NSNumber *hours = [NSNumber numberWithInt:timeInterval/3600];
        NSNumber *minutes = [NSNumber numberWithInt:(timeInterval - [hours intValue] * 3600)/60];
        NSNumber *seconds = [NSNumber numberWithInt:(timeInterval - 60 * [minutes intValue] - 3600 * [hours intValue])];

        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setFormatWidth:2];
        [numberFormatter setPaddingCharacter:@"0"];
        formattedString = [NSString stringWithFormat:@"%@:%@", [numberFormatter stringFromNumber:minutes], [numberFormatter stringFromNumber:seconds]];
    }
    else if ([self isToday] || [self isTomorrow] || [self isYesterday]) {
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

@end
