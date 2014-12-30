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
    NSDictionary *textAttributes = @{
                                     NSForegroundColorAttributeName: [UIColor plumTintColor],
                                     NSFontAttributeName: [UIFont effraMediumWithSize:25.0]
                                     };

    UINavigationBar *navigationBar = [UINavigationBar appearance];
    navigationBar.backgroundColor = [UIColor grayNavigationBarBackgroundColor];
    navigationBar.translucent = NO;
    navigationBar.titleTextAttributes = textAttributes;


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
    Task *task = [self findTaskWithUniqueId:[notification.userInfo objectForKey:@"uniqueId"]];
    if ([identifier isEqualToString:kMRAddTenMinutesActionIdentifier]) {
        task.dueDate = [NSDate dateWithTimeIntervalSinceNow:600];

        __block NSError *error;
        [task.managedObjectContext performBlock:^{
            [task.managedObjectContext save:&error];
        }];

        [task rescheduleNotification];
        completionHandler();
    }
    else if([identifier isEqualToString:kMRDestroyTaskActionIdentifier]) {
        [task setIsDone:YES];
        [task cancelNotification];

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

- (Task *)findTaskWithUniqueId:(NSString *)uniqueId {
    NSManagedObjectID *managedObjectId = [self.persistentStoreCoordinator managedObjectIDForURIRepresentation:[NSURL URLWithString:uniqueId]];
    return (Task *)[self.managedObjectContext objectWithID:managedObjectId];
}

- (BOOL)addSampleData {
    [self removeAllTasks];

    [Task insertItemWithText:@"Islanders" dueDate:[NSDate dateWithTimeIntervalSinceNow:14400] inManagedObjectContext:self.managedObjectContext];
    [Task insertItemWithText:@"Renew Apple developer program membership" dueDate:[NSDate dateWithTimeIntervalSinceNow:72000] inManagedObjectContext:self.managedObjectContext];
    [Task insertItemWithText:@"Pay Cobra" dueDate:[NSDate dateWithTimeIntervalSinceNow:86400] inManagedObjectContext:self.managedObjectContext];
    [Task insertItemWithText:@"Go to party" dueDate:[NSDate dateWithTimeIntervalSinceNow:172800] inManagedObjectContext:self.managedObjectContext];
    [Task insertItemWithText:@"Work on presentation for developer event" dueDate:[NSDate dateWithTimeIntervalSinceNow:171000] inManagedObjectContext:self.managedObjectContext];
    [Task insertItemWithText:@"Developer event" dueDate:[NSDate dateWithTimeIntervalSinceNow:220000] inManagedObjectContext:self.managedObjectContext];
    [Task insertItemWithText:@"Read about Objective-C and learn how to work with the Responder Chain" dueDate:[NSDate dateWithTimeIntervalSinceNow:240000] inManagedObjectContext:self.managedObjectContext];
    [Task insertItemWithText:@"Leave for the Islanders game" dueDate:[NSDate dateWithTimeIntervalSinceNow:280000] inManagedObjectContext:self.managedObjectContext];
    [Task insertItemWithText:@"Go to office party" dueDate:[NSDate dateWithTimeIntervalSinceNow:290000] inManagedObjectContext:self.managedObjectContext];

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

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
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

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Tackle" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Tackle.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
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

@end
