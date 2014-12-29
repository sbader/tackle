//
//  MRTimeInterval.h
//  Tackle
//
//  Created by Scott Bader on 12/29/14.
//  Copyright (c) 2014 Melody Road. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MRTimeInterval : NSObject

@property (nonatomic) NSCalendarUnit unit;
@property (nonatomic) NSUInteger interval;
@property (nonatomic) NSString *name;

+ (instancetype)timeIntervalWithName:(NSString *)name unit:(NSCalendarUnit)unit interval:(NSUInteger)interval;

@end
