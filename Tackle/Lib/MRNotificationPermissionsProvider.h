//
//  MRNotificationPermissionsProvider.h
//  Tackle
//
//  Created by Scott Bader on 2/9/16.
//  Copyright © 2016 Melody Road. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kMRNotificationPermissionsRequestedKey;
extern NSString * const kMRSiriPermissionsRequestedKey;

@interface MRNotificationPermissionsProvider : NSObject

+ (instancetype)sharedInstance;
//- (BOOL)shouldRequestPermissions;
//- (BOOL)userNotificationsEnabled;
- (BOOL)notificationPermissionsAlreadyRequested;
- (void)setPermissionsRequested:(BOOL)requested;
- (void)registerNotificationPermissions;

- (void)checkUserNotificationsEnabled:(void (^)(BOOL enabled))completionHandler;
- (void)shouldRequestPermissionsWithCompletion:(void (^)(BOOL requestPermissions))completionHandler;
- (void)setupCategories;

- (BOOL)siriPermissionsAlreadyRequested;
- (void)setSiriPermissionsRequested:(BOOL)requested;
- (void)registerSiriPermissions;
- (BOOL)shouldRequestSiriPermissions;



@end
