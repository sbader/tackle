//
//  MRAppDelegate.m
//  Tackle
//
//  Created by Scott Bader on 1/22/14.
//  Copyright (c) 2014 Melody Road. All rights reserved.
//

#import "MRAppDelegate.h"

#import "MRMainViewController.h"
#import "Task.h"

@implementation MRAppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [self addSampleData];
    [self setupWindow];
    [self setupMainViewController];
    [self.window makeKeyAndVisible];

    UILocalNotification *notification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (notification) {
        [self handleLocalNotification:notification];
    }

    return YES;
}

- (void)setupWindow
{
    CGSize mainScreenSize = [[UIScreen mainScreen] bounds].size;
    [self setWindow:[[UIWindow alloc] initWithFrame:CGRectMake(0, 0, mainScreenSize.width, mainScreenSize.height)]];
    [self.window setBackgroundColor:[UIColor whiteColor]];
}

- (void)setupMainViewController
{
    self.mainViewController = [[MRMainViewController alloc] initWithManagedObjectContext:self.managedObjectContext];
    [self.window setRootViewController:self.mainViewController];
//    [controller.view setFrame:CGRectMake(0, 0, self.window.frame.size.width, self.window.frame.size.height)];
    [self.mainViewController.view setFrame:CGRectMake(0, 0, self.window.frame.size.width, 100.0f)];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    [self handleLocalNotification:notification];
}

- (void)handleLocalNotification:(UILocalNotification *)notification
{
    NSString *urlString = [notification.userInfo objectForKey:@"uniqueId"];
    NSManagedObjectID *managedObjectId = [self.persistentStoreCoordinator managedObjectIDForURIRepresentation:[NSURL URLWithString:urlString]];
    Task *task = (Task *)[self.managedObjectContext objectWithID:managedObjectId];
    [self.mainViewController selectTask:task];
}

- (BOOL)addSampleData
{
    NSFetchRequest *allTasks = [[NSFetchRequest alloc] init];
    [allTasks setEntity:[NSEntityDescription entityForName:@"Task" inManagedObjectContext:self.managedObjectContext]];
    [allTasks setIncludesPropertyValues:NO]; //only fetch the managedObjectID

    NSError *requestError = nil;
    NSArray *tasks = [self.managedObjectContext executeFetchRequest:allTasks error:&requestError];

    [tasks enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self.managedObjectContext deleteObject:obj];
    }];

    [Task insertItemWithText:@"Prepare Expenses" dueDate:[NSDate dateWithTimeIntervalSinceNow:7200] inManagedObjectContext:self.managedObjectContext];
    [Task insertItemWithText:@"Renew Apple Developer Program Membership" dueDate:[NSDate dateWithTimeIntervalSinceNow:96000] inManagedObjectContext:self.managedObjectContext];
    [Task insertItemWithText:@"Read more about Objective-C" dueDate:[NSDate dateWithTimeIntervalSinceNow:72000] inManagedObjectContext:self.managedObjectContext];
    [Task insertItemWithText:@"Schedule a physical" dueDate:[NSDate dateWithTimeIntervalSinceNow:172800] inManagedObjectContext:self.managedObjectContext];
    [Task insertItemWithText:@"Work on Tackle" dueDate:[NSDate dateWithTimeIntervalSinceNow:171000] inManagedObjectContext:self.managedObjectContext];
    [Task insertItemWithText:@"Go to anniversary party" dueDate:[NSDate dateWithTimeIntervalSinceNow:220000] inManagedObjectContext:self.managedObjectContext];
    [Task insertItemWithText:@"Dinner with family" dueDate:[NSDate dateWithTimeIntervalSinceNow:240000] inManagedObjectContext:self.managedObjectContext];
    [Task insertItemWithText:@"Watch hockey" dueDate:[NSDate dateWithTimeIntervalSinceNow:280000] inManagedObjectContext:self.managedObjectContext];
    [Task insertItemWithText:@"Clean apartment" dueDate:[NSDate dateWithTimeIntervalSinceNow:290000] inManagedObjectContext:self.managedObjectContext];
    [Task insertItemWithText:@"Watch Archer" dueDate:[NSDate dateWithTimeIntervalSinceNow:300000] inManagedObjectContext:self.managedObjectContext];

    NSError *error = nil;

    [self.managedObjectContext save:&error];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
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
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Tackle" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
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
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - Utilities

- (void)displayFonts
{
    for (NSString* family in [UIFont familyNames]) {
        NSLog(@"%@", family);

        for (NSString* name in [UIFont fontNamesForFamilyName: family]) {
            NSLog(@"  %@", name);
        }
    }
}

@end
