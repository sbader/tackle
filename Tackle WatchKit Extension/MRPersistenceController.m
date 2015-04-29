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

@property (copy) void(^initCallback)();

- (void)initializeCoreData;

@end

@implementation MRPersistenceController

- (instancetype)initWithCallback:(void(^)())callback {
    self = [super init];

    if (self) {
        [self setInitCallback:callback];
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
    assert(mom);

    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    assert(coordinator);

    [self setManagedObjectContext:[[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType]];
    [self setPrivateContext:[[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType]];
    [[self privateContext] setPersistentStoreCoordinator:coordinator];
    [[self managedObjectContext] setParentContext:[self privateContext]];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSPersistentStoreCoordinator *psc = [[self privateContext] persistentStoreCoordinator];
        NSMutableDictionary *options = [NSMutableDictionary dictionary];
        options[NSMigratePersistentStoresAutomaticallyOption] = @YES;
        options[NSInferMappingModelAutomaticallyOption] = @YES;
        options[NSSQLitePragmasOption] = @{ @"journal_mode":@"DELETE" };

        NSURL *directory = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.TackleDataGroup"];
        NSURL *storeURL = [directory URLByAppendingPathComponent:@"Tackle.sqlite"];

        NSError *error = nil;
        assert([psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]);

        if (![self initCallback]) {
            return;
        }

        dispatch_sync(dispatch_get_main_queue(), ^{
            [self initCallback]();
        });
    });

}

- (void)save {
    if (![[self privateContext] hasChanges] && ![[self managedObjectContext] hasChanges]) return;

    [[self managedObjectContext] performBlockAndWait:^{
        NSError *error = nil;

        assert([[self managedObjectContext] save:&error]);

        [[self privateContext] performBlock:^{
            NSError *privateError = nil;
            assert([[self privateContext] save:&privateError]);
        }];
    }];
}

@end
