//
//  NSDate+TackleAdditions.m
//  Tackle
//
//  Created by Scott Bader on 2/5/14.
//  Copyright (c) 2014 Melody Road. All rights reserved.
//

#import "NSDate+TackleAdditions.h"

#import "MRShortDateFormatter.h"
#import "MRLongDateFormatter.h"
#import "MRMediumDateFormatter.h"

@implementation NSDate (TackleAdditions)

- (NSString *)tackleString
{
    MRShortDateFormatter *formatter = [MRShortDateFormatter sharedInstance];
//    MRLongDateFormatter *formatter = [MRLongDateFormatter sharedInstance];
//    MRMediumDateFormatter *formatter = [MRMediumDateFormatter sharedInstance];
    return [formatter stringFromDate:self];
}

@end
