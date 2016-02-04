//
//  MRFullDateFormatter.m
//  Tackle
//
//  Created by Scott Bader on 2/4/16.
//  Copyright © 2016 Melody Road. All rights reserved.
//

#import "MRFullDateFormatter.h"

@implementation MRFullDateFormatter

+ (instancetype)sharedFormatter {
    static MRFullDateFormatter *formatter;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[self alloc] init];
        [formatter setLocalizedDateFormatFromTemplate:@"jjmmMMMMdy"];
    });

    return formatter;
}


@end
