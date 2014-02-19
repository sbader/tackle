//
//  MRDateFormatter.m
//  Tackle
//
//  Created by Scott Bader on 1/26/14.
//  Copyright (c) 2014 Melody Road. All rights reserved.
//

#import "MRLongDateFormatter.h"

@implementation MRLongDateFormatter

NSString * const kCachedLongDateFormatterKey = @"CachedLongDateFormatterKey";

+ (MRLongDateFormatter *)sharedInstance
{
    NSMutableDictionary *threadDictionary = [[NSThread currentThread] threadDictionary];
    MRLongDateFormatter *dateFormatter = [threadDictionary objectForKey:kCachedLongDateFormatterKey];

    if (!dateFormatter) {
        NSString *formatString = [NSDateFormatter dateFormatFromTemplate:@"EEEEMMMd"
                                                                 options:0
                                                                  locale:[NSLocale currentLocale]];

        dateFormatter = [[MRLongDateFormatter alloc] init];
        [dateFormatter setDateFormat:formatString];

        [threadDictionary setObject:dateFormatter forKey:kCachedLongDateFormatterKey];
    }

    return dateFormatter;
}

@end
