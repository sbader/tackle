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
#import "MRTackleDataConstants.h"
#import "MRPersistenceController.h"
#import "MRConnectivityController.h"

@interface MRAppDelegate () <MRConnectivityControllerDelegate>

@property (nonatomic) MRRootViewController *rootController;
@property (strong) MRPersistenceController *persistenceController;
@property (strong) MRConnectivityController *connectivityController;

@end

@implementation MRAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.persistenceController = [[MRPersistenceController alloc] init];
    self.connectivityController = [[MRConnectivityController alloc] initWithPersistenceController:self.persistenceController];
    self.connectivityController.delegate = self;
    [self completeUserInterfaceWithApplication:application launchOptions:launchOptions];

    return YES;
}

- (void)completeUserInterfaceWithApplication:(UIApplication *)application launchOptions:(NSDictionary *)launchOptions {
    if (IS_OS_8_OR_LATER) {
        UIUserNotificationType types = UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound;

        UIMutableUserNotificationAction *tenMinutesAction = [[UIMutableUserNotificationAction alloc] init];
        tenMinutesAction.identifier = kMRAddTenMinutesActionIdentifier;
        tenMinutesAction.destructive = NO;
        tenMinutesAction.title = @"Add 10 Minutes";
        tenMinutesAction.activationMode = UIUserNotificationActivationModeBackground;
        tenMinutesAction.authenticationRequired = NO;

        UIMutableUserNotificationAction *destroyAction = [[UIMutableUserNotificationAction alloc] init];
        destroyAction.identifier = kMRDestroyTaskActionIdentifier;
        destroyAction.destructive = YES;
        destroyAction.title = @"Done";
        destroyAction.activationMode = UIUserNotificationActivationModeBackground;
        destroyAction.authenticationRequired = NO;

        UIMutableUserNotificationCategory *category = [[UIMutableUserNotificationCategory alloc] init];
        category.identifier = kMRTaskNotificationCategoryIdentifier;

        [category setActions:@[tenMinutesAction, destroyAction] forContext:UIUserNotificationActionContextMinimal];
        [category setActions:@[tenMinutesAction, destroyAction] forContext:UIUserNotificationActionContextDefault];

        NSSet *categories = [[NSSet alloc] initWithObjects:category, nil];

        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:types
                                                                                        categories:categories]];
    }

    BOOL testing = NO;
    if (testing) {
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

- (void)setupWindow {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor grayBackgroundColor];
}

- (void)setupRootViewController {
    self.rootController = [[MRRootViewController alloc] initWithPersistenceController:self.persistenceController connectivityController:self.connectivityController];
    [self.window setRootViewController:self.rootController];
}

- (void)setupAppearance {
    NSDictionary *barTitleTextAttributes = @{
                                             NSForegroundColorAttributeName: [UIColor grayTextColor],
                                             NSFontAttributeName: [UIFont fontForBarTitle]
                                             };

    UINavigationBar *navigationBar = [UINavigationBar appearance];
    navigationBar.backgroundColor = [UIColor grayNavigationBarBackgroundColor];
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

    NSLog(@"handleActionWithIdentifier:%@ uniqueId:%@ task:%@", identifier, taskIdentifier, task.title);

    if ([identifier isEqualToString:kMRAddTenMinutesActionIdentifier]) {
        task.dueDate = [NSDate dateWithTimeIntervalSinceNow:600];

        [self.persistenceController save];
        [[MRNotificationProvider sharedProvider] rescheduleNotificationForTask:task];

        [self.connectivityController sendUpdateTaskNotificationWithTask:task];

        NSLog(@"addTenMinutes");

        completionHandler();
    }
    else if([identifier isEqualToString:kMRDestroyTaskActionIdentifier]) {
        task.isDone = YES;
        task.completedDate = [NSDate date];
        [[MRNotificationProvider sharedProvider] cancelNotificationForTask:task];

        [self.persistenceController save];

        [self.connectivityController sendCompleteTaskNotificationWithTask:task];

        NSLog(@"destroyTask");

        completionHandler();
    }
    else {
        NSLog(@"Cannot handle action with identifier %@", identifier);
        completionHandler();
    }
}

- (BOOL)addSampleData {
    [self removeAllTasks];

    [Task insertItemWithTitle:@"Mets" dueDate:[NSDate dateWithTimeIntervalSinceNow:14400] identifier:[NSUUID UUID].UUIDString inManagedObjectContext:self.persistenceController.managedObjectContext];
    [Task insertItemWithTitle:@"Renew Apple developer program membership" dueDate:[NSDate dateWithTimeIntervalSinceNow:72000] identifier:[NSUUID UUID].UUIDString inManagedObjectContext:self.persistenceController.managedObjectContext];
    [Task insertItemWithTitle:@"Pay Cobra" dueDate:[NSDate dateWithTimeIntervalSinceNow:86400] identifier:[NSUUID UUID].UUIDString inManagedObjectContext:self.persistenceController.managedObjectContext];
    [Task insertItemWithTitle:@"Go to party" dueDate:[NSDate dateWithTimeIntervalSinceNow:172800] identifier:[NSUUID UUID].UUIDString inManagedObjectContext:self.persistenceController.managedObjectContext];
    [Task insertItemWithTitle:@"Work on presentation for developer event" dueDate:[NSDate dateWithTimeIntervalSinceNow:171000] identifier:[NSUUID UUID].UUIDString inManagedObjectContext:self.persistenceController.managedObjectContext];
//    [Task insertItemWithTitle:@"Developer event" dueDate:[NSDate dateWithTimeIntervalSinceNow:220000] inManagedObjectContext:self.persistenceController.managedObjectContext];
//    [Task insertItemWithTitle:@"Read about Objective-C and learn how to work with the Responder Chain" dueDate:[NSDate dateWithTimeIntervalSinceNow:240000] inManagedObjectContext:self.persistenceController.managedObjectContext];
//    [Task insertItemWithTitle:@"Leave for the Islanders game" dueDate:[NSDate dateWithTimeIntervalSinceNow:280000] inManagedObjectContext:self.persistenceController.managedObjectContext];
//    [Task insertItemWithTitle:@"Go to office party" dueDate:[NSDate dateWithTimeIntervalSinceNow:290000] inManagedObjectContext:self.persistenceController.managedObjectContext];

    [self.persistenceController save];
    return YES;
}

- (void)removeAllTasks {
    NSFetchRequest *allTasks = [[NSFetchRequest alloc] init];
    [allTasks setEntity:[NSEntityDescription entityForName:@"Task" inManagedObjectContext:self.persistenceController.managedObjectContext]];
    [allTasks setIncludesPropertyValues:NO]; //only fetch the managedObjectID

    NSError *requestError = nil;
    NSArray *tasks = [self.persistenceController.managedObjectContext executeFetchRequest:allTasks error:&requestError];

    [tasks enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self.persistenceController.managedObjectContext deleteObject:obj];
    }];
}

- (void)listAllTaskIDS {
    NSFetchRequest *allTasks = [[NSFetchRequest alloc] init];
    [allTasks setEntity:[NSEntityDescription entityForName:@"Task" inManagedObjectContext:self.persistenceController.managedObjectContext]];
    [allTasks setIncludesPropertyValues:NO]; //only fetch the managedObjectID

    NSError *requestError = nil;
    NSArray *tasks = [self.persistenceController.managedObjectContext executeFetchRequest:allTasks error:&requestError];

    [tasks enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Task *task = (Task *)obj;
        NSLog(@"app: %@", task.objectID.URIRepresentation.absoluteString);
    }];
}

- (void)loadTaskWithObjectIDString:(NSString *)objectIDString {
    Task *task = [Task findTaskWithUniqueId:objectIDString inManagedObjectContext:self.persistenceController.managedObjectContext];
    if (task) {
        [self.rootController handleNotificationForTask:task];
    }
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    NSString *base64URLString = [url lastPathComponent];
    NSData *data = [[NSData alloc] initWithBase64EncodedString:base64URLString options:0];
    NSString *urlString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

    [self loadTaskWithObjectIDString:urlString];
    

    return YES;
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

#pragma mark - Connectivity Controller Delegate

- (void)connectivityController:(MRConnectivityController *)connectivityController didAddTask:(Task *)task {
    [[MRNotificationProvider sharedProvider] rescheduleAllNotificationsWithManagedObjectContext:self.persistenceController.managedObjectContext];
}

- (void)connectivityController:(MRConnectivityController *)connectivityController didCompleteTask:(Task *)task {
    [[MRNotificationProvider sharedProvider] rescheduleAllNotificationsWithManagedObjectContext:self.persistenceController.managedObjectContext];
}

- (void)connectivityController:(MRConnectivityController *)connectivityController didUpdateTask:(Task *)task {
    [[MRNotificationProvider sharedProvider] rescheduleAllNotificationsWithManagedObjectContext:self.persistenceController.managedObjectContext];
}

@end
