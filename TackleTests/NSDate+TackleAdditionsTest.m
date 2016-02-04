//
//  NSDate+TackleAdditionsTest.m
//  Tackle
//
//  Created by Scott Bader on 2/8/14.
//  Copyright (c) 2014 Melody Road. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface NSDate_TackleAdditionsTest : XCTestCase

@end

@implementation NSDate_TackleAdditionsTest

- (void)testIsWithinADayOfDate {
    NSDate *startDate = [NSDate dateWithTimeIntervalSinceReferenceDate:21600];

    XCTAssertFalse([[NSDate dateWithTimeIntervalSinceReferenceDate:-95000] isDayBeforeOrAfterDate:startDate]);
    XCTAssertTrue([[NSDate dateWithTimeIntervalSinceReferenceDate:-21600] isDayBeforeOrAfterDate:startDate]);
    XCTAssertTrue([[NSDate dateWithTimeIntervalSinceReferenceDate:108000] isDayBeforeOrAfterDate:startDate]);
    XCTAssertFalse([[NSDate dateWithTimeIntervalSinceReferenceDate:200000] isDayBeforeOrAfterDate:startDate]);
}

- (void)testDateWithinNextHourShouldShowMinutesAndSeconds {
    NSDate *startDate = [NSDate date];

    __block NSString *formattedDate;

    NSDictionary *testDictionary = @{
                                     @32: @"In 32 Seconds",
                                     @601: @"In 10 Minutes 1 Seconds",
                                     @3599: @"In 59 Minutes 59 Seconds"
                                    };

    [testDictionary enumerateKeysAndObjectsUsingBlock:^(NSNumber *key, NSString *matchString, BOOL *stop) {
        formattedDate = [[NSDate dateWithTimeInterval:[key floatValue] sinceDate:startDate] tackleStringSinceDate:startDate];
        XCTAssertEqualObjects(formattedDate, matchString);
    }];
}

- (void)testDateLaterInDayAfterHourShouldShowFullTime {
    NSDate *startDate = [[NSCalendar currentCalendar] dateBySettingHour:0 minute:1 second:0 ofDate:[NSDate date] options:0];
    NSDate *date = [[NSCalendar currentCalendar] dateBySettingHour:23 minute:1 second:0 ofDate:startDate options:0];
    XCTAssertEqualObjects([date tackleStringSinceDate:startDate], @"11:01 PM");
}

- (void)testDateAfterCurrentDateShouldShowFullTimeAndDate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *startDate = [formatter dateFromString:@"2016-01-02 1:22"];
    NSDate *futureDate = [formatter dateFromString:@"2016-02-03 12:22"];
    
    XCTAssertEqualObjects([futureDate tackleStringSinceDate:startDate], @"February 3 at 12:22 PM");
}

- (void)testDateAfterCurrentDateDifferentYearShouldShowFullTimeAndDateWithYear {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *startDate = [formatter dateFromString:@"2016-01-02 1:22"];
    NSDate *futureDate = [formatter dateFromString:@"2018-11-04 12:27"];

    XCTAssertEqualObjects([futureDate tackleStringSinceDate:startDate], @"November 4, 2018 at 12:27 PM");
}

- (void)testDateBeforeCurrentDateSameYearShouldShowFullTimeAndDate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *startDate = [formatter dateFromString:@"2016-03-12 1:22"];
    NSDate *earlierDate = [formatter dateFromString:@"2016-01-03 12:27"];

    XCTAssertEqualObjects([earlierDate tackleStringSinceDate:startDate], @"January 3 at 12:27 PM");
}


- (void)testDateBeforeCurrentDateDifferentYearShouldShowFullTimeAndDateWithYear {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *startDate = [formatter dateFromString:@"2016-01-02 1:22"];
    NSDate *earlierDate = [formatter dateFromString:@"2014-10-04 12:27"];

    XCTAssertEqualObjects([earlierDate tackleStringSinceDate:startDate], @"October 4, 2014 at 12:27 PM");
}

- (void)testDateWithinPastHourShouldShowMinutesAndSeconds {
    NSDate *startDate = [NSDate date];

    __block NSString *formattedDate;

    NSDictionary *testDictionary = @{
                                     @44: @"44 Seconds Ago",
                                     @608: @"10 Minutes 8 Seconds Ago",
                                     @3599: @"59 Minutes 59 Seconds Ago"
                                     };

    [testDictionary enumerateKeysAndObjectsUsingBlock:^(NSNumber *key, NSString *matchString, BOOL *stop) {
        formattedDate = [[NSDate dateWithTimeInterval:-[key floatValue] sinceDate:startDate] tackleStringSinceDate:startDate];
        XCTAssertEqualObjects(formattedDate, matchString);
    }];
}

- (void)testDateWithinPastDayShouldShowMinutesAndSeconds {
    NSDate *startDate = [NSDate date];

    __block NSString *formattedDate;

    NSDictionary *testDictionary = @{
                                     @7222: @"2 Hours Ago",
                                     @10920: @"3 Hours Ago"
                                     };

    [testDictionary enumerateKeysAndObjectsUsingBlock:^(NSNumber *key, NSString *matchString, BOOL *stop) {
        formattedDate = [[NSDate dateWithTimeInterval:-[key floatValue] sinceDate:startDate] tackleStringSinceDate:startDate];
        XCTAssertEqualObjects(formattedDate, matchString);
    }];
}

@end
