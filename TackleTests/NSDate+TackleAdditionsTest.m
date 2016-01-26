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
