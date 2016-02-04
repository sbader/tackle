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

#import <mach/mach.h>

const BOOL kMRTesting = NO;

@interface MRAppDelegate ()

@property (nonatomic) MRRootViewController *rootController;
@property (strong) MRPersistenceController *persistenceController;

@end

@implementation MRAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.persistenceController = [[MRPersistenceController alloc] init];
    [self completeUserInterfaceWithApplication:application launchOptions:launchOptions];

    return YES;
}

- (void)completeUserInterfaceWithApplication:(UIApplication *)application launchOptions:(NSDictionary *)launchOptions {
    if (IS_OS_8_OR_LATER) {
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

        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:types
                                                                                        categories:categories]];
    }

    if (kMRTesting) {
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        [self addSampleData];
    }

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
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [self.persistenceController save];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [self.persistenceController save];
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

- (BOOL)addSampleData {
    [self removeAllTasks];

    [Task insertItemWithTitle:@"Leave for hockey game" dueDate:[NSDate dateWithTimeIntervalSinceNow:1800] identifier:[NSUUID UUID].UUIDString inManagedObjectContext:self.persistenceController.managedObjectContext];
    [Task insertItemWithTitle:@"Go for a walk" dueDate:[[NSCalendar currentCalendar] dateWithEra:1 year:2016 month:1 day:30 hour:11 minute:0 second:0 nanosecond:0] identifier:[NSUUID UUID].UUIDString inManagedObjectContext:self.persistenceController.managedObjectContext];
    [Task insertItemWithTitle:@"Work on designs for app" dueDate:[[NSCalendar currentCalendar] dateWithEra:1 year:2016 month:2 day:1 hour:11 minute:0 second:0 nanosecond:0] identifier:[NSUUID UUID].UUIDString inManagedObjectContext:self.persistenceController.managedObjectContext];
    [Task insertItemWithTitle:@"Pick up dry cleaning" dueDate:[[NSCalendar currentCalendar] dateWithEra:1 year:2016 month:1 day:30 hour:15 minute:0 second:0 nanosecond:0] identifier:[NSUUID UUID].UUIDString inManagedObjectContext:self.persistenceController.managedObjectContext];
    [Task insertItemWithTitle:@"Get to the gym" dueDate:[[NSCalendar currentCalendar] dateWithEra:1 year:2016 month:2 day:2 hour:14 minute:0 second:0 nanosecond:0] identifier:[NSUUID UUID].UUIDString inManagedObjectContext:self.persistenceController.managedObjectContext];
    [Task insertItemWithTitle:@"Pay the electricity bill" dueDate:[[NSCalendar currentCalendar] dateWithEra:1 year:2016 month:2 day:16 hour:10 minute:0 second:0 nanosecond:0] identifier:[NSUUID UUID].UUIDString inManagedObjectContext:self.persistenceController.managedObjectContext];
    [Task insertItemWithTitle:@"Go to the airport" dueDate:[[NSCalendar currentCalendar] dateWithEra:1 year:2016 month:3 day:2 hour:10 minute:0 second:0 nanosecond:0] identifier:[NSUUID UUID].UUIDString inManagedObjectContext:self.persistenceController.managedObjectContext];
    [Task insertItemWithTitle:@"Baseball game" dueDate:[[NSCalendar currentCalendar] dateWithEra:1 year:2016 month:4 day:3 hour:20 minute:37 second:0 nanosecond:0] identifier:[NSUUID UUID].UUIDString inManagedObjectContext:self.persistenceController.managedObjectContext];
    [Task insertItemWithTitle:@"File your taxes" dueDate:[[NSCalendar currentCalendar] dateWithEra:1 year:2016 month:4 day:18 hour:9 minute:0 second:0 nanosecond:0] identifier:[NSUUID UUID].UUIDString inManagedObjectContext:self.persistenceController.managedObjectContext];

    return YES;
}

- (void)removeAllTasks {
    NSFetchRequest *fetchRequest = [Task allTasksFetchRequestWithManagedObjectContext:self.persistenceController.managedObjectContext];
    [fetchRequest setIncludesPropertyValues:NO];

    NSError *error = nil;
    NSArray *tasks = [self.persistenceController.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    NSAssert(tasks != nil, @"Failed to execute fetch %@", error);

    for (Task *task in tasks) {
        [self.persistenceController.managedObjectContext deleteObject:task];
    }
}

#pragma mark - Utilities

- (void)displayFonts {
    for (NSString* family in [UIFont familyNames]) {
        NSLog(@"%@", family);

        for (NSString* name in [UIFont fontNamesForFamilyName: family]) {
            NSLog(@"  %@", name);
        }
    }
}

@end
