//
//  MRTimer.h
//  Tackle
//
//  Created by Scott Bader on 2/10/16.
//  Copyright © 2016 Melody Road. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MRTimer : NSObject

- (instancetype)initWithStartDate:(NSDate *)startDate interval:(NSTimeInterval)interval repeatedBlock:(void (^)())repeatedBlock;
- (void)startTimer;
- (void)cancel;

@end
