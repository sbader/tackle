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

@interface MRAppDelegate () <UNUserNotificationCenterDelegate>

@property (nonatomic) MRRootViewController *rootController;
@property (strong) MRPersistenceController *persistenceController;
@property (strong) MRTimer *timer;

@end

@implementation MRAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[UNUserNotificationCenter currentNotificationCenter] setDelegate:self];

    self.persistenceController = [[MRPersistenceController alloc] init];

    [self completeUserInterfaceWithApplication:application launchOptions:launchOptions];

    return YES;
}

- (void)completeUserInterfaceWithApplication:(UIApplication *)application launchOptions:(NSDictionary *)launchOptions {
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{
                                                              kMRNotificationPermissionsRequestedKey: @NO,
                                                              kMRSiriPermissionsRequestedKey: @NO
                                                              }];

    [self setupAppearance];
    [self setupWindow];
    [self setupRootViewController];
    [self.window makeKeyAndVisible];

    [[MRNotificationPermissionsProvider sharedInstance] setupCategories];
    [[MRNotificationProvider sharedProvider] rescheduleAllNotificationsWithManagedObjectContext:self.persistenceController.managedObjectContext];

    // TODO: - Handle notifications that have been delivered
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[MRNotificationProvider sharedProvider] rescheduleAllNotificationsWithManagedObjectContext:self.persistenceController.managedObjectContext];

    [self.rootController checkPermissions];

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
    if ([permissionsProvider notificationPermissionsAlreadyRequested]) {
        [permissionsProvider checkUserNotificationsEnabled:^(BOOL enabled) {
            if (!enabled) {
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
        }];
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

- (void)handleNotificationWithIdentifier:(NSString *)identifier {
    Task *task = [Task findTaskWithIdentifier:identifier
                       inManagedObjectContext:self.persistenceController.managedObjectContext];

    [self.rootController handleNotificationForTask:task];
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    [self handleNotificationWithIdentifier:notification.request.identifier];
    completionHandler(UNNotificationPresentationOptionNone);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    NSString *taskNotificationIdentifier = response.notification.request.identifier;
    NSString *action = response.actionIdentifier;

    Task *task = [Task findTaskWithTaskNotificationIdentifier:taskNotificationIdentifier
                                       inManagedObjectContext:self.persistenceController.managedObjectContext];

    MRLog(@"didReceiveNotificationResponse");

    if (task == nil) {
        MRLog(@"didReceiveNotificationResponse failed to find task with taskNotificationIdentifier: %@", taskNotificationIdentifier);
        completionHandler();
        return;
    }

    if ([action isEqualToString:kMRAddTenMinutesActionIdentifier]) {
        MRLog(@"didReceiveNotificationResponse task: %@, action: kMRAddTenMinutesActionIdentifier", task.title);

        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDate *date = [calendar dateByAddingUnit:NSCalendarUnitMinute value:10 toDate:[NSDate date] options:0];
        task.dueDate = date;

        [self.persistenceController save];
        [[MRNotificationProvider sharedProvider] rescheduleNotificationForTask:task];

        completionHandler();
    }
    else if ([action isEqualToString:kMRAddOneHourActionIdentifier]) {
        MRLog(@"didReceiveNotificationResponse task: %@, action: kMRAddOneHourActionIdentifier", task.title);

        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDate *date = [calendar dateByAddingUnit:NSCalendarUnitHour value:1 toDate:[NSDate date] options:0];
        task.dueDate = date;


        [self.persistenceController save];
        [[MRNotificationProvider sharedProvider] rescheduleNotificationForTask:task];

        completionHandler();
    }
    else if([action isEqualToString:kMRDestroyTaskActionIdentifier]) {
        MRLog(@"didReceiveNotificationResponse task: %@, action: kMRDestroyTaskActionIdentifier", task.title);

        task.isDone = YES;
        task.completedDate = [NSDate date];
        [[MRNotificationProvider sharedProvider] cancelNotificationForTask:task];

        Task *repeatedTask = [task createRepeatedTaskInManagedObjectContext:self.persistenceController.managedObjectContext];

        [self.persistenceController save];

        [[MRNotificationProvider sharedProvider] rescheduleNotificationForTask:repeatedTask];

        completionHandler();
    }
    else {
        MRLog(@"didReceiveNotificationResponse task: %@, action: unknownAction", task.title);

        completionHandler();
    }
}

@end
