//
//  MRHeartbeat.m
//  Tackle
//
//  Created by Scott Bader on 2/4/14.
//  Copyright (c) 2014 Melody Road. All rights reserved.
//

#import "MRHeartbeat.h"

const CGFloat kHeartbeatInterval = 0.1;
NSString * const kHeartbeatId = @"kHeartbeatId";
NSString * const kSlowHeartbeatId = @"kSlowHeartbeatId";

@interface MRHeartbeat ()

@property(nonatomic, strong) NSThread *timerThread;
@property(nonatomic, assign) NSInteger tick;

@end

@implementation MRHeartbeat

+ (MRHeartbeat *)heartbeatController
{
    static MRHeartbeat *heartbeat = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        heartbeat = [[self alloc] init];
        heartbeat.tick = 0;
        heartbeat.timerThread = [[NSThread alloc] initWithTarget:heartbeat selector:@selector(startTimerThread) object:nil];
        [heartbeat.timerThread start];
    });

    return heartbeat;
}


-(void)startTimerThread
{
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:kHeartbeatInterval
                                                  target:self
                                                selector:@selector(heartDidBeat:)
                                                userInfo:nil
                                                 repeats:YES];
    [runLoop run];

}


+ (NSString *)heartbeatId
{
    [MRHeartbeat heartbeatController];
    return kHeartbeatId;
}

+ (NSString *)slowHeartbeatId
{
    [MRHeartbeat heartbeatController];
    return kSlowHeartbeatId;
}

-(void)heartDidBeat:(NSTimer *)timer
{
    if (self.tick == 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kSlowHeartbeatId object:nil];
    }

    if (self.tick < 3) {
        self.tick++;
    }
    else {
        self.tick = 0;
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:kHeartbeatId object:nil];
}


@end
