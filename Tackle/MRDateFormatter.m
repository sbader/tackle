//
//  MRDateFormatter.m
//  Tackle
//
//  Created by Scott Bader on 1/26/14.
//  Copyright (c) 2014 Melody Road. All rights reserved.
//

#import "MRDateFormatter.h"

@implementation MRDateFormatter

NSString * const kCachedDateFormatterKey = @"CachedDateFormatterKey";

+ (NSDateFormatter *)sharedInstance
{
    NSMutableDictionary *threadDictionary = [[NSThread currentThread] threadDictionary];
    NSDateFormatter *dateFormatter = [threadDictionary objectForKey:kCachedDateFormatterKey];

    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];

        [dateFormatter setDoesRelativeDateFormatting:YES];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        [dateFormatter setDateStyle:NSDateFormatterShortStyle];

        [threadDictionary setObject:dateFormatter forKey:kCachedDateFormatterKey];
    }

    return dateFormatter;
}

@end
