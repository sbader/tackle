//
//  MRNotificationPermissionsProvider.m
//  Tackle
//
//  Created by Scott Bader on 2/9/16.
//  Copyright © 2016 Melody Road. All rights reserved.
//

#import "MRNotificationPermissionsProvider.h"

#import "Task.h"

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

- (instancetype)init {
    self = [super init];

    if (self) {
    }

    return self;
}

- (BOOL)shouldRequestPermissions {
    return ![self userNotificationsEnabled] && ![[NSUserDefaults standardUserDefaults] boolForKey:kMRNotificationPermissionsRequestedKey];
}

- (BOOL)userNotificationsEnabled {
    UIUserNotificationSettings *settings = [[UIApplication sharedApplication] currentUserNotificationSettings];
    return settings.types & (UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound);
}

- (void)permissionsRequested {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kMRNotificationPermissionsRequestedKey];
}

- (void)registerNotificationPermissions {
    UIUserNotificationType types = UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound;

    UIMutableUserNotificationAction *tenMinutesAction = [[UIMutableUserNotificationAction alloc] init];
    tenMinutesAction.identifier = kMRAddTenMinutesActionIdentifier;
    tenMinutesAction.destructive = NO;
    tenMinutesAction.title = NSLocalizedString(@"Notification Action Add 10 Minutes", nil);
    tenMinutesAction.activationMode = UIUserNotificationActivationModeBackground;
    tenMinutesAction.authenticationRequired = NO;

    UIMutableUserNotificationAction *oneHourAction = [[UIMutableUserNotificationAction alloc] init];
    oneHourAction.identifier = kMRAddOneHourActionIdentifier;
    oneHourAction.destructive = NO;
    oneHourAction.title = NSLocalizedString(@"Notification Action Add 1 Hour", nil);
    oneHourAction.activationMode = UIUserNotificationActivationModeBackground;
    oneHourAction.authenticationRequired = NO;

    UIMutableUserNotificationAction *destroyAction = [[UIMutableUserNotificationAction alloc] init];
    destroyAction.identifier = kMRDestroyTaskActionIdentifier;
    destroyAction.destructive = YES;
    destroyAction.title = NSLocalizedString(@"Notification Action Done", nil);
    destroyAction.activationMode = UIUserNotificationActivationModeBackground;
    destroyAction.authenticationRequired = NO;

    UIMutableUserNotificationCategory *category = [[UIMutableUserNotificationCategory alloc] init];
    category.identifier = kMRTaskNotificationCategoryIdentifier;

    [category setActions:@[destroyAction, tenMinutesAction] forContext:UIUserNotificationActionContextMinimal];
    [category setActions:@[destroyAction, tenMinutesAction, oneHourAction] forContext:UIUserNotificationActionContextDefault];

    NSSet *categories = [[NSSet alloc] initWithObjects:category, nil];

    [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:types
                                                                                    categories:categories]];

}


@end
