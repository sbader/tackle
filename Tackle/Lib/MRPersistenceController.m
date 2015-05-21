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
@property (nonatomic) BOOL initializeAsynchronously;
@property (copy) void(^initCallback)();

- (void)initializeCoreData;

@end

@implementation MRPersistenceController

- (instancetype)init {
    self = [super init];

    if (self) {
        _initializeAsynchronously = NO;
        [self initializeCoreData];
    }

    return self;
}

- (instancetype)initWithCallback:(void(^)())callback {
    self = [super init];

    if (self) {
        _initializeAsynchronously = YES;
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
    NSAssert(mom, @"Managed object model could not be initialized");

    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    NSAssert(coordinator, @"Persistent Store Coordinator could not be initialized");

    [self setManagedObjectContext:[[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType]];
    [self setPrivateContext:[[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType]];
    [[self privateContext] setPersistentStoreCoordinator:coordinator];

    [[self managedObjectContext] setParentContext:self.privateContext];

    void (^setupPersistentStoreCoordinator)() = ^{
        NSPersistentStoreCoordinator *psc = [[self privateContext] persistentStoreCoordinator];
        NSMutableDictionary *options = [NSMutableDictionary dictionary];
        options[NSMigratePersistentStoresAutomaticallyOption] = @YES;
        options[NSInferMappingModelAutomaticallyOption] = @YES;
        options[NSSQLitePragmasOption] = @{ @"journal_mode":@"DELETE" };

        NSURL *directory = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.TackleDataGroup"];
        NSURL *storeURL = [directory URLByAppendingPathComponent:@"Tackle.sqlite"];

        NSError *error = nil;
        BOOL success = [psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error];
        NSAssert(success, @"Could not add persistent store");

        if (![self initCallback]) {
            return;
        }

        dispatch_sync(dispatch_get_main_queue(), ^{
            [self initCallback]();
        });
    };

    if (self.initializeAsynchronously) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            setupPersistentStoreCoordinator();
        });
    }
    else {
        setupPersistentStoreCoordinator();
    }
}

- (void)save {
    if (![[self privateContext] hasChanges] && ![[self managedObjectContext] hasChanges]) {
        return;
    }

    [[self managedObjectContext] performBlockAndWait:^{
        NSError *error = nil;

        NSAssert([[self managedObjectContext] save:&error], @"Error saving main managed object context");

        [[self privateContext] performBlock:^{
            NSError *privateError = nil;
            NSAssert([[self privateContext] save:&privateError], @"Error saving private managed object context");
        }];
    }];
}

@end
