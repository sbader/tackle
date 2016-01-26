//
//  MRTimeDateFormatter.m
//  Tackle
//
//  Created by Scott Bader on 2/5/14.
//  Copyright (c) 2014 Melody Road. All rights reserved.
//

#import "MRTimeDateFormatter.h"

@implementation MRTimeDateFormatter

NSString * const kCachedTimeDateFormatterKey = @"CachedTimeDateFormatterKey";

+ (MRTimeDateFormatter *)sharedInstance {
    NSMutableDictionary *threadDictionary = [[NSThread currentThread] threadDictionary];
    MRTimeDateFormatter *dateFormatter = [threadDictionary objectForKey:kCachedTimeDateFormatterKey];

    if (!dateFormatter) {
        dateFormatter = [[MRTimeDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterNoStyle];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];

        [threadDictionary setObject:dateFormatter forKey:kCachedTimeDateFormatterKey];
    }
    
    return dateFormatter;
}

@end
