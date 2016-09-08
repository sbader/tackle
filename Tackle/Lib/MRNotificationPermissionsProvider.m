//
//  MRNotificationPermissionsProvider.m
//  Tackle
//
//  Created by Scott Bader on 2/9/16.
//  Copyright © 2016 Melody Road. All rights reserved.
//

#import "MRNotificationPermissionsProvider.h"

#import "Task.h"

@import UserNotifications;

NSString * const kMRNotificationPermissionsRequestedKey = @"NotificationPermissionsRequested";

@implementation MRNotificationPermissionsProvider

+ (instancetype)sharedInstance {
    static MRNotificationPermissionsProvider *instance;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });

    return instance;
}

- (void)shouldRequestPermissionsWithCompletion:(void (^)(BOOL requestPermissions))completionHandler {
    if (self.notificationPermissionsAlreadyRequested) {
        return;
    }

    [self checkUserNotificationsEnabled:^(BOOL enabled) {
        completionHandler(!enabled);
    }];
}

- (BOOL)notificationPermissionsAlreadyRequested {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kMRNotificationPermissionsRequestedKey];
}

- (void)checkUserNotificationsEnabled:(void (^)(BOOL enabled))completionHandler {
    [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        BOOL isEnabled = settings.soundSetting == UNNotificationSettingEnabled ||
                         settings.alertSetting == UNNotificationSettingEnabled ||
                         settings.badgeSetting;

        completionHandler(isEnabled);
    }];
}

- (void)setPermissionsRequested:(BOOL)requested {
    [[NSUserDefaults standardUserDefaults] setBool:requested forKey:kMRNotificationPermissionsRequestedKey];
}

- (void)setupCategories {
    UNNotificationAction *tenMinuteAction = [UNNotificationAction actionWithIdentifier:kMRAddTenMinutesActionIdentifier
                                                                                 title:NSLocalizedString(@"Notification Action Add 10 Minutes", nil)
                                                                               options:UNNotificationActionOptionNone];

    UNNotificationAction *oneHourAction = [UNNotificationAction actionWithIdentifier:kMRAddOneHourActionIdentifier
                                                                               title:NSLocalizedString(@"Notification Action Add 1 Hour", nil)
                                                                             options:UNNotificationActionOptionNone];

    UNNotificationAction *destroyAction = [UNNotificationAction actionWithIdentifier:kMRDestroyTaskActionIdentifier
                                                                               title:NSLocalizedString(@"Notification Action Done", nil)
                                                                             options:UNNotificationActionOptionDestructive];

    UNNotificationCategory *category = [UNNotificationCategory categoryWithIdentifier:kMRTaskNotificationCategoryIdentifier
                                                                              actions:@[destroyAction, tenMinuteAction, oneHourAction]
                                                                    intentIdentifiers:@[]
                                                                              options:UNNotificationCategoryOptionCustomDismissAction];

    NSSet *categories = [[NSSet alloc] initWithObjects:category, nil];
    [[UNUserNotificationCenter currentNotificationCenter] setNotificationCategories:categories];
    os_log(OS_LOG_DEFAULT, "Setup categories");
}

- (void)registerNotificationPermissions {
    UNAuthorizationOptions options = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
    [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:options completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            os_log(OS_LOG_DEFAULT, "Granted");
        }
    }];
}


@end
