//
//  MRUpcomingFormatter.m
//  Tackle
//
//  Created by Scott Bader on 2/5/14.
//  Copyright (c) 2014 Melody Road. All rights reserved.
//

#import "MRUpcomingFormatter.h"

@implementation MRUpcomingFormatter

NSString * const kCachedUpcomingFormatterKey = @"CachedUpcomingFormatterKey";

+ (MRUpcomingFormatter *)sharedInstance
{
    NSMutableDictionary *threadDictionary = [[NSThread currentThread] threadDictionary];
    MRUpcomingFormatter *formatter = [threadDictionary objectForKey:kCachedUpcomingFormatterKey];

    if (!formatter) {
        formatter = [[MRUpcomingFormatter alloc] init];
        [threadDictionary setObject:formatter forKey:kCachedUpcomingFormatterKey];
    }

    return formatter;
}

@end
