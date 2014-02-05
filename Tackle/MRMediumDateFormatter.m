//
//  MRMediumDateFormatter.m
//  Tackle
//
//  Created by Scott Bader on 2/5/14.
//  Copyright (c) 2014 Melody Road. All rights reserved.
//

#import "MRMediumDateFormatter.h"

@implementation MRMediumDateFormatter

NSString * const kCachedMediumDateFormatterKey = @"CachedMediumDateFormatterKey";

+ (MRMediumDateFormatter *)sharedInstance
{
    NSMutableDictionary *threadDictionary = [[NSThread currentThread] threadDictionary];
    MRMediumDateFormatter *dateFormatter = [threadDictionary objectForKey:kCachedMediumDateFormatterKey];

    if (!dateFormatter) {
        NSString *formatString = [NSDateFormatter dateFormatFromTemplate:@"EEEE"
                                                                 options:0
                                                                  locale:[NSLocale currentLocale]];

        dateFormatter = [[MRMediumDateFormatter alloc] init];
        [dateFormatter setDateFormat:formatString];

        [threadDictionary setObject:dateFormatter forKey:kCachedMediumDateFormatterKey];
    }
    
    return dateFormatter;
}


@end
