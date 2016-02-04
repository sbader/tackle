//
//  MRFullDateFormatter.h
//  Tackle
//
//  Created by Scott Bader on 2/4/16.
//  Copyright © 2016 Melody Road. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MRFullDateFormatter : NSObject

+ (instancetype)sharedFormatter;
- (NSString *)stringFromDate:(NSDate *)date;

@end
