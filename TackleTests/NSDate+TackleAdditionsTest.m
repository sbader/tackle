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

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testIsWithinADayOfDate
{
    NSDate *startDate = [NSDate dateWithTimeIntervalSinceReferenceDate:21600];
    NSDate *compareDate = [NSDate dateWithTimeIntervalSinceReferenceDate:-21600];


    NSLog(@"startDate: %@, compareDate: %@", startDate, compareDate);
    XCTAssertTrue([compareDate isDayBeforeOrAfterDate:startDate]);

//    __block NSString *formattedDate;
//
//    NSDictionary *testDictionary = @{
//                                     @32: @"In 32 seconds",
//                                     @601: @"In 10 minutes 1 seconds",
//                                     @3599: @"In 59 minutes 59 seconds"
//                                     };
//
//    [testDictionary enumerateKeysAndObjectsUsingBlock:^(NSNumber *key, NSString *matchString, BOOL *stop) {
//        formattedDate = [[NSDate dateWithTimeInterval:[key floatValue] sinceDate:startDate] tackleStringSinceDate:startDate];
//        XCTAssertEqualObjects(formattedDate, matchString, @"%@ does not match %@", formattedDate, matchString);
//    }];

}

- (void)testDateWithinNextHourShouldShowMinutesAndSeconds
{
    NSDate *startDate = [NSDate date];

    __block NSString *formattedDate;

    NSDictionary *testDictionary = @{
                                     @32: @"In 32 seconds",
                                     @601: @"In 10 minutes 1 seconds",
                                     @3599: @"In 59 minutes 59 seconds"
                                    };

    [testDictionary enumerateKeysAndObjectsUsingBlock:^(NSNumber *key, NSString *matchString, BOOL *stop) {
        formattedDate = [[NSDate dateWithTimeInterval:[key floatValue] sinceDate:startDate] tackleStringSinceDate:startDate];
        XCTAssertEqualObjects(formattedDate, matchString, @"%@ does not match %@", formattedDate, matchString);
    }];
}

- (void)testDateWithinPastHourShouldShowMinutesAndSeconds
{
    NSDate *startDate = [NSDate date];

    __block NSString *formattedDate;

    NSDictionary *testDictionary = @{
                                     @44: @"44 seconds ago",
                                     @608: @"10 minutes 8 seconds ago",
                                     @3599: @"59 minutes 59 seconds ago"
                                     };

    [testDictionary enumerateKeysAndObjectsUsingBlock:^(NSNumber *key, NSString *matchString, BOOL *stop) {
        formattedDate = [[NSDate dateWithTimeInterval:-[key floatValue] sinceDate:startDate] tackleStringSinceDate:startDate];
        XCTAssertEqualObjects(formattedDate, matchString, @"%@ does not match %@", formattedDate, matchString);
    }];
}

- (void)testDateWithinPastDayShouldShowMinutesAndSeconds
{
    NSDate *startDate = [NSDate date];

    __block NSString *formattedDate;

    NSDictionary *testDictionary = @{
                                     @7222: @"2 hours ago",
                                     @10920: @"3 hours ago"
                                     };

    [testDictionary enumerateKeysAndObjectsUsingBlock:^(NSNumber *key, NSString *matchString, BOOL *stop) {
        formattedDate = [[NSDate dateWithTimeInterval:-[key floatValue] sinceDate:startDate] tackleStringSinceDate:startDate];
        XCTAssertEqualObjects(formattedDate, matchString, @"%@ does not match %@", formattedDate, matchString);
    }];
}

@end
