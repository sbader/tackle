//
//  NSDate+TackleAdditions.h
//  Tackle
//
//  Created by Scott Bader on 2/5/14.
//  Copyright (c) 2014 Melody Road. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (TackleAdditions)

- (NSString *)tackleString;
- (NSString *)tackleStringSinceDate:(NSDate *)date;
- (BOOL)isDayBeforeOrAfterDate:(NSDate *)date;

@end
