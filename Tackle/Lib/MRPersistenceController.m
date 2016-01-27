//
//  MRPersistenceController.m
//  Tackle
//
//  Created by Scott Bader on 4/28/15.
//  Copyright (c) 2015 Melody Road. All rights reserved.
//

#import "MRPersistenceController.h"

@interface MRPersistenceController ()

@property (strong, readwrite) NSManagedObjectContext *managedObjectContext;
@property (strong) NSManagedObjectContext *privateContext;

- (void)initializeCoreData;

@end

@implementation MRPersistenceController

- (instancetype)init {
    self = [super init];

    if (self) {
        [self initializeCoreData];
    }

    return self;
}

- (void)initializeCoreData {
    if ([self managedObjectContext]) {
        return;
    }

    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Tackle" withExtension:@"momd"];
    NSManagedObjectModel *mom = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    NSAssert(mom, @"Managed object model could not be initialized");

    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    NSAssert(coordinator, @"Persistent Store Coordinator could not be initialized");

    [self setManagedObjectContext:[[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType]];
    [self.managedObjectContext setPersistentStoreCoordinator:coordinator];

    NSPersistentStoreCoordinator *psc = self.managedObjectContext.persistentStoreCoordinator;
    NSMutableDictionary *options = [NSMutableDictionary dictionary];
    options[NSMigratePersistentStoresAutomaticallyOption] = @YES;
    options[NSInferMappingModelAutomaticallyOption] = @YES;
    options[NSSQLitePragmasOption] = @{ @"journal_mode":@"DELETE" };


    NSArray *paths = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL *directory = [paths lastObject];
    NSURL *storeURL = [directory URLByAppendingPathComponent:@"Tackle.sqlite"];

    NSError *error = nil;
    NSPersistentStore *store = [psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error];
    NSAssert(store, @"Could not add persistent store");
}

- (void)save {
    if (![self.managedObjectContext hasChanges]) {
        return;
    }

    [[self managedObjectContext] performBlockAndWait:^{
        NSError *error = nil;
        NSAssert([[self managedObjectContext] save:&error], @"Error saving main managed object context");
    }];
}

@end
