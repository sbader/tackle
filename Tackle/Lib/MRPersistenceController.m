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

    if (!modelURL) {
        NSLog(@"Managed object model could not be initialized");
        return;
    }

    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    if (!coordinator) {
         NSLog(@"Persistent Store Coordinator could not be initialized");
        return;
    }

    [self setManagedObjectContext:[[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType]];
    self.managedObjectContext.undoManager = [[NSUndoManager alloc] init];
    [self.managedObjectContext setPersistentStoreCoordinator:coordinator];

    NSPersistentStoreCoordinator *psc = self.managedObjectContext.persistentStoreCoordinator;
    NSMutableDictionary *options = [NSMutableDictionary dictionary];
    options[NSMigratePersistentStoresAutomaticallyOption] = @YES;
    options[NSInferMappingModelAutomaticallyOption] = @YES;
    options[NSSQLitePragmasOption] = @{
                                       @"journal_mode": @"WAL"
                                       };

    NSURL *directory = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory
                                                              inDomain:NSUserDomainMask
                                                     appropriateForURL:nil
                                                                create:YES
                                                                 error:NULL];

    NSURL *storeURL = [directory URLByAppendingPathComponent:@"Tackle.sqlite"];

    NSError *error = nil;
    NSPersistentStore *store = [psc addPersistentStoreWithType:NSSQLiteStoreType
                                                                         configuration:nil
                                                                                   URL:storeURL
                                                                               options:options
                                                                                 error:&error];

    if (!store) {
        NSLog(@"Could not add persistent store");
    }
}

- (void)save {
    if (![self.managedObjectContext hasChanges]) {
        return;
    }

    [[self managedObjectContext] performBlockAndWait:^{
        NSError *error __attribute__((unused)) = nil;
        [[self managedObjectContext] save:&error];

        if (error) {
            NSLog(@"Error saving main managed object context %@", error.localizedDescription);
        }
    }];
}

@end
