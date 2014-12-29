//
//  MRHeartbeat.h
//  Tackle
//
//  Created by Scott Bader on 2/4/14.
//  Copyright (c) 2014 Melody Road. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kHeartbeatId;

@interface MRHeartbeat : NSObject

@property(nonatomic, strong) NSTimer *timer;

+ (MRHeartbeat *)heartbeatController;
+ (NSString *)heartbeatId;
+ (NSString *)slowHeartbeatId;

@end
