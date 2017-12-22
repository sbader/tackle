//
//  MRTimer.m
//  Tackle
//
//  Created by Scott Bader on 2/10/16.
//  Copyright © 2016 Melody Road. All rights reserved.
//

#import "MRTimer.h"

@interface MRTimer ()

@property (nonatomic) NSTimer *timer;

@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic) NSTimeInterval interval;
@property (nonatomic, copy) void (^repeatedBlock)(void);

@end

@implementation MRTimer

- (instancetype)initWithStartDate:(NSDate *)startDate interval:(NSTimeInterval)interval repeatedBlock:(void (^)(void))repeatedBlock {
    self = [super init];

    if (self) {
        _startDate = startDate;
        _interval = interval;
        _repeatedBlock = repeatedBlock;
    }

    return self;
}

- (void)startTimer {
    self.timer = [[NSTimer alloc] initWithFireDate:self.startDate
                                          interval:self.interval
                                            target:self
                                          selector:@selector(timerDidFire:)
                                          userInfo:nil
                                           repeats:YES];

    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
}

- (void)cancel {
    [self.timer invalidate];
}

- (void)timerDidFire:(NSTimer *)timer {
    if (self.repeatedBlock) {
        self.repeatedBlock();
    }
}

@end
