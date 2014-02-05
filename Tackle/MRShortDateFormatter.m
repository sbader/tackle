//
//  MRShortDateFormatter.m
//  Tackle
//
//  Created by Scott Bader on 2/5/14.
//  Copyright (c) 2014 Melody Road. All rights reserved.
//

#import "MRShortDateFormatter.h"

@implementation MRShortDateFormatter

NSString * const kCachedShortDateFormatterKey = @"CachedShortDateFormatterKey";

+ (MRShortDateFormatter *)sharedInstance
{
    NSMutableDictionary *threadDictionary = [[NSThread currentThread] threadDictionary];
    MRShortDateFormatter *dateFormatter = [threadDictionary objectForKey:kCachedShortDateFormatterKey];

    if (!dateFormatter) {
        dateFormatter = [[MRShortDateFormatter alloc] init];
        [dateFormatter setDoesRelativeDateFormatting:YES];
        [dateFormatter setDateStyle:NSDateFormatterShortStyle];
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];

        [threadDictionary setObject:dateFormatter forKey:kCachedShortDateFormatterKey];
    }

    return dateFormatter;
}

@end
