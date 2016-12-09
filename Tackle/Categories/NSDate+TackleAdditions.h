//
//  NSDate+TackleAdditions.h
//  Tackle
//
//  Created by Scott Bader on 2/5/14.
//  Copyright (c) 2014 Melody Road. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (TackleAdditions)

- (BOOL)isDayBeforeDate:(NSDate *)date;
- (BOOL)isDayAfterDate:(NSDate *)date;
- (BOOL)isDayBeforeOrAfterDate:(NSDate *)date;
- (BOOL)isSameDayAsDate:(NSDate *)date;
- (BOOL)isToday;
- (BOOL)isTodayToDate:(NSDate *)date;
- (BOOL)isWithinAWeek;
- (BOOL)isWithinAWeekOfDate:(NSDate *)date;
- (BOOL)isTomorrow;
- (BOOL)isTomorrowToDate:(NSDate *)date;
- (BOOL)isCurrentYear;
- (BOOL)isSameYearAsDate:(NSDate *)date;
- (BOOL)isWeekday;
- (NSDate *)followingDay;
- (NSDate *)beginningOfDay;
- (NSDate *)beginningOfYear;
- (NSString *)tackleStringSinceDate:(NSDate *)date;
- (NSString *)tackleString;

@end

