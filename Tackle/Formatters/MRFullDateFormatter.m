//
//  MRFullDateFormatter.m
//  Tackle
//
//  Created by Scott Bader on 2/4/16.
//  Copyright © 2016 Melody Road. All rights reserved.
//

#import "MRFullDateFormatter.h"

@interface MRFullDateFormatter ()

@property (nonatomic) NSDateFormatter *dateFormatter;
@property (nonatomic) NSDateFormatter *timeFormatter;

@end

@implementation MRFullDateFormatter

+ (instancetype)sharedFormatter {
    static MRFullDateFormatter *formatter;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[self alloc] init];
        formatter.dateFormatter = [[NSDateFormatter alloc] init];
        [formatter.dateFormatter setLocalizedDateFormatFromTemplate:@"MMMMdy"];

        formatter.timeFormatter = [[NSDateFormatter alloc] init];
        [formatter.timeFormatter setDateStyle:NSDateFormatterNoStyle];
        [formatter.timeFormatter setTimeStyle:NSDateFormatterShortStyle];
    });

    return formatter;
}

- (NSString *)stringFromDate:(NSDate *)date {
    NSString *dateString = [self.dateFormatter stringFromDate:date];
    NSString *timeString = [self.timeFormatter stringFromDate:date];
    return [NSString stringWithFormat:NSLocalizedString(@"Full Time And Date Format", nil), dateString, timeString];
}

@end
