//
//  MRTaskNotification.h
//  Tackle
//
//  Created by Scott Bader on 7/30/17.
//  Copyright © 2017 Melody Road. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MRTaskNotification : NSObject

@property (nonatomic, nonnull) NSString *taskIdentifier;
@property (nonatomic) NSTimeInterval delay;

- (instancetype _Nonnull)initWithTaskIdentifier:(NSString *_Nonnull)taskIdentifier delay:(NSTimeInterval)delay;
- (NSString *_Nonnull)identifier;
+ (NSString *_Nullable)taskIdentifierFromTaskNotificationIdentifier:(NSString *_Nonnull)taskNotificationIdentifier;

@end
