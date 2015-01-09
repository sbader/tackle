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

@interface MRAppDelegate ()

@property (nonatomic) MRRootViewController *rootController;

@end

@implementation MRAppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
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

    UILocalNotification *notification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (notification) {
        [self handleLocalNotification:notification];
    }

    return YES;
}

- (void)setupWindow {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor grayBackgroundColor];
}

- (void)setupRootViewController {
    self.rootController = [[MRRootViewController alloc] initWithManagedObjectContext:self.managedObjectContext];
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
    NSString *urlString = [notification.userInfo objectForKey:@"uniqueId"];
    NSManagedObjectID *managedObjectId = [self.persistentStoreCoordinator managedObjectIDForURIRepresentation:[NSURL URLWithString:urlString]];
    Task *task = (Task *)[self.managedObjectContext objectWithID:managedObjectId];
    [self.rootController handleNotificationForTask:task];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)())completionHandler {
    Task *task = [Task findTaskWithUniqueId:[notification.userInfo objectForKey:@"uniqueId"] inManagedObjectContext:self.managedObjectContext];
    if ([identifier isEqualToString:kMRAddTenMinutesActionIdentifier]) {
        task.dueDate = [NSDate dateWithTimeIntervalSinceNow:600];

        __block NSError *error;
        [task.managedObjectContext performBlock:^{
            [task.managedObjectContext save:&error];
        }];

        [[MRNotificationProvider sharedProvider] rescheduleNotificationForTask:task];
        completionHandler();
    }
    else if([identifier isEqualToString:kMRDestroyTaskActionIdentifier]) {
        task.isDone = YES;
        [[MRNotificationProvider sharedProvider] cancelNotificationForTask:task];

        __block NSError *error;
        [task.managedObjectContext performBlock:^{
            [task.managedObjectContext save:&error];
        }];
        completionHandler();
    }
    else {
        NSLog(@"Cannot handle action with identifier %@", identifier);
    }
}

- (BOOL)addSampleData {
    [self removeAllTasks];

    [Task insertItemWithTitle:@"Islanders" dueDate:[NSDate dateWithTimeIntervalSinceNow:14400] inManagedObjectContext:self.managedObjectContext];
    [Task insertItemWithTitle:@"Renew Apple developer program membership" dueDate:[NSDate dateWithTimeIntervalSinceNow:72000] inManagedObjectContext:self.managedObjectContext];
    [Task insertItemWithTitle:@"Pay Cobra" dueDate:[NSDate dateWithTimeIntervalSinceNow:86400] inManagedObjectContext:self.managedObjectContext];
    [Task insertItemWithTitle:@"Go to party" dueDate:[NSDate dateWithTimeIntervalSinceNow:172800] inManagedObjectContext:self.managedObjectContext];
    [Task insertItemWithTitle:@"Work on presentation for developer event" dueDate:[NSDate dateWithTimeIntervalSinceNow:171000] inManagedObjectContext:self.managedObjectContext];
    [Task insertItemWithTitle:@"Developer event" dueDate:[NSDate dateWithTimeIntervalSinceNow:220000] inManagedObjectContext:self.managedObjectContext];
    [Task insertItemWithTitle:@"Read about Objective-C and learn how to work with the Responder Chain" dueDate:[NSDate dateWithTimeIntervalSinceNow:240000] inManagedObjectContext:self.managedObjectContext];
    [Task insertItemWithTitle:@"Leave for the Islanders game" dueDate:[NSDate dateWithTimeIntervalSinceNow:280000] inManagedObjectContext:self.managedObjectContext];
    [Task insertItemWithTitle:@"Go to office party" dueDate:[NSDate dateWithTimeIntervalSinceNow:290000] inManagedObjectContext:self.managedObjectContext];

    NSError *error = nil;

    [self.managedObjectContext save:&error];
    return YES;
}

- (void)removeAllTasks {
    NSFetchRequest *allTasks = [[NSFetchRequest alloc] init];
    [allTasks setEntity:[NSEntityDescription entityForName:@"Task" inManagedObjectContext:self.managedObjectContext]];
    [allTasks setIncludesPropertyValues:NO]; //only fetch the managedObjectID

    NSError *requestError = nil;
    NSArray *tasks = [self.managedObjectContext executeFetchRequest:allTasks error:&requestError];

    [tasks enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self.managedObjectContext deleteObject:obj];
    }];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    NSString *base64URLString = [url lastPathComponent];
    NSData *data = [[NSData alloc] initWithBase64EncodedString:base64URLString options:0];
    NSString *urlString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    Task *task = [Task findTaskWithUniqueId:urlString inManagedObjectContext:self.managedObjectContext];
    if (task) {
        [self.rootController handleNotificationForTask:task];
    }

    return YES;
}

#pragma mark - Core Data stack

- (NSManagedObjectContext *)managedObjectContext {
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Tackle" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }

    NSURL *directory = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.TackleDataGroup"];
    NSURL *storeURL = [directory  URLByAppendingPathComponent:@"Tackle.sqlite"];

    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
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

#pragma mark - WatchKit

- (void)application:(UIApplication *)application handleWatchKitExtensionRequest:(NSDictionary *)userInfo reply:(void(^)(NSDictionary *replyInfo))reply{
    // Receives text input result from the WatchKit app extension.
    NSLog(@"User Info: %@", userInfo);

    // Sends a confirmation message to the WatchKit app extension that the text input result was received.
    reply(@{@"Confirmation" : @"Text was received."});
}


@end
