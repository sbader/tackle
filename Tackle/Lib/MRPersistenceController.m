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

@end

@implementation MRPersistenceController

- (instancetype)init {
    self = [super init];

    if (self) {
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Tackle" withExtension:@"momd"];
        NSManagedObjectModel *mom = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
        NSAssert(mom, @"Managed object model could not be initialized");
        
        NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
        NSAssert(coordinator, @"Persistent Store Coordinator could not be initialized");
        
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
        NSPersistentStore *store __attribute__((unused)) = [psc addPersistentStoreWithType:NSSQLiteStoreType
                                                                             configuration:nil
                                                                                       URL:storeURL
                                                                                   options:options
                                                                                     error:&error];

        NSAssert(store, @"Could not add persistent store");
    }

    return self;
}

- (void)save {
    if (![self.managedObjectContext hasChanges]) {
        NSLog(@"MRPersistenceController save - managedObjectContext - hasChanges:NO");
        return;
    }

    [[self managedObjectContext] performBlockAndWait:^{
        NSError *error = nil;
        [[self managedObjectContext] save:&error];
        NSLog(@"MRPersistenceController save - managedObjectContext - saved");
        NSAssert(error == nil, @"Error saving main managed object context");
    }];
}

@end
