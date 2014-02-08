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

- (void)testDateWithinHourShouldShowMinutesAndSeconds
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

@end
