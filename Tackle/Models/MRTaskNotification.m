//
//  MRTaskNotification.m
//  Tackle
//
//  Created by Scott Bader on 7/30/17.
//  Copyright © 2017 Melody Road. All rights reserved.
//

#import "MRTaskNotification.h"

@implementation MRTaskNotification

- (instancetype _Nonnull)initWithTaskIdentifier:(NSString *_Nonnull)taskIdentifier delay:(NSTimeInterval)delay {
    self = [super init];

    if (self) {
        _taskIdentifier = taskIdentifier;
        _delay = delay;
    }

    return self;
}

- (NSString *_Nonnull)identifier {
    return [[NSString alloc] initWithFormat:@"%@:%f", self.taskIdentifier, self.delay];
}

+ (NSString *_Nullable)taskIdentifierFromTaskNotificationIdentifier:(NSString *_Nonnull)taskNotificationIdentifier {
    return [taskNotificationIdentifier componentsSeparatedByString:@":"].firstObject;
}

@end
