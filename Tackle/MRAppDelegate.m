//
//  MRAppDelegate.m
//  Tackle
//
//  Created by Scott Bader on 1/22/14.
//  Copyright (c) 2014 Melody Road. All rights reserved.
//

#import "MRAppDelegate.h"

#import "Task.h"
#import "MRRootViewController.h"
#import "MRNotificationProvider.h"
#import "MRPersistenceController.h"
#import "MRDatePickerProvider.h"
#import "MRTimer.h"
#import "MRNotificationPermissionsProvider.h"

@interface MRAppDelegate ()

@property (nonatomic) MRRootViewController *rootController;
@property (strong) MRPersistenceController *persistenceController;
@property (strong) MRTimer *timer;

@end

@implementation MRAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.persistenceController = [[MRPersistenceController alloc] init];
    [self completeUserInterfaceWithApplication:application launchOptions:launchOptions];

    return YES;
}

- (void)completeUserInterfaceWithApplication:(UIApplication *)application launchOptions:(NSDictionary *)launchOptions {
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{
                                                              kMRNotificationPermissionsRequestedKey: @NO
                                                              }];

    [self setupAppearance];
    [self setupWindow];
    [self setupRootViewController];
    [self.window makeKeyAndVisible];

    [[MRNotificationProvider sharedProvider] rescheduleAllNotificationsWithManagedObjectContext:self.persistenceController.managedObjectContext];

    UILocalNotification *notification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (notification) {
        [self handleLocalNotification:notification];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[MRNotificationProvider sharedProvider] rescheduleAllNotificationsWithManagedObjectContext:self.persistenceController.managedObjectContext];

    [self.rootController checkNotificationPermissions];

    if (application.applicationState != UIApplicationStateBackground) {
        [self startNotificationsTimer];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [self.persistenceController save];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [self.persistenceController save];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [self stopNotificationsTimer];
}

- (void)startNotificationsTimer {
    MRNotificationPermissionsProvider *permissionsProvider = [MRNotificationPermissionsProvider sharedInstance];
    if ([permissionsProvider notificationPermissionsAlreadyRequested] && ![permissionsProvider userNotificationsEnabled]) {
        self.timer = [[MRTimer alloc] init];

        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:(NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute) fromDate:[NSDate date]];
        components.minute += 1;

        __block id blockSelf = self;

        self.timer = [[MRTimer alloc] initWithStartDate:[calendar dateFromComponents:components] interval:60 repeatedBlock:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [blockSelf checkPassedTasks];
            });
        }];

        [self.timer startTimer];
    }
}

- (void)stopNotificationsTimer {
    if (self.timer) {
        [self.timer cancel];
        self.timer = nil;
    }
}

- (void)checkPassedTasks {
    NSFetchRequest *fetchRequest = [Task passedOpenTasksFetchRequestWithManagedObjectContext:self.persistenceController.managedObjectContext];
    [fetchRequest setSortDescriptors:@[[[NSSortDescriptor alloc] initWithKey:@"dueDate" ascending:YES]]];
    [fetchRequest setFetchLimit:1];
    NSError *error;
    NSArray *tasks = [self.persistenceController.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (tasks.count > 0) {
        [self.rootController handleNotificationForTask:tasks[0]];
    }
}

- (void)setupWindow {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor grayBackgroundColor];
}

- (void)setupRootViewController {
    self.rootController = [[MRRootViewController alloc] initWithPersistenceController:self.persistenceController];
    [self.window setRootViewController:self.rootController];
}

- (void)setupAppearance {
    NSDictionary *barTitleTextAttributes = @{
                                             NSForegroundColorAttributeName: [UIColor grayTextColor],
                                             NSFontAttributeName: [UIFont fontForBarTitle]
                                             };

    UINavigationBar *navigationBar = [UINavigationBar appearance];
    navigationBar.backgroundColor = [UIColor grayNavigationBarBackgroundColor];
    navigationBar.barTintColor = [UIColor grayNavigationBarBackgroundColor];
    navigationBar.translucent = NO;
    navigationBar.titleTextAttributes = barTitleTextAttributes;

    UIBarButtonItem *barButtonItem = [UIBarButtonItem appearance];

    NSDictionary *barButtonTitleTextAttributes = @{
                                                   NSFontAttributeName: [UIFont fontForBarButtonItemStandardStyle]
                                                   };

    [barButtonItem setTitleTextAttributes:barButtonTitleTextAttributes forState:UIControlStateNormal];

    UIView *view = [UIView appearance];
    view.tintColor = [UIColor plumTintColor];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    [self handleLocalNotification:notification];
}

- (void)handleLocalNotification:(UILocalNotification *)notification {
    NSString *taskIdentifier = [notification.userInfo objectForKey:@"identifier"];
    Task *task = [Task findTaskWithIdentifier:taskIdentifier inManagedObjectContext:self.persistenceController.managedObjectContext];
    [self.rootController handleNotificationForTask:task];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)())completionHandler {
    NSString *taskIdentifier = [notification.userInfo objectForKey:@"identifier"];

    Task *task = [Task findTaskWithIdentifier:taskIdentifier inManagedObjectContext:self.persistenceController.managedObjectContext];

    if ([identifier isEqualToString:kMRAddTenMinutesActionIdentifier]) {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDate *date = [calendar dateByAddingUnit:NSCalendarUnitMinute value:10 toDate:[NSDate date] options:0];
        task.dueDate = date;

        [self.persistenceController save];
        [[MRNotificationProvider sharedProvider] rescheduleNotificationForTask:task];

        completionHandler();
    }
    else if ([identifier isEqualToString:kMRAddOneHourActionIdentifier]) {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDate *date = [calendar dateByAddingUnit:NSCalendarUnitHour value:1 toDate:[NSDate date] options:0];
        task.dueDate = date;


        [self.persistenceController save];
        [[MRNotificationProvider sharedProvider] rescheduleNotificationForTask:task];

        completionHandler();
    }
    else if([identifier isEqualToString:kMRDestroyTaskActionIdentifier]) {
        task.isDone = YES;
        task.completedDate = [NSDate date];
        [[MRNotificationProvider sharedProvider] cancelNotificationForTask:task];

        [self.persistenceController save];

        completionHandler();
    }
    else {
        NSLog(@"Cannot handle action with identifier %@", identifier);
        completionHandler();
    }
}

@end
