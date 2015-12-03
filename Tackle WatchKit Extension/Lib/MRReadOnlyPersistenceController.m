//
//  MRPersistenceController.m
//  Tackle
//
//  Created by Scott Bader on 4/28/15.
//  Copyright (c) 2015 Melody Road. All rights reserved.
//

#import "MRReadOnlyPersistenceController.h"

@interface MRReadOnlyPersistenceController ()

@property (strong, readwrite) NSManagedObjectContext *managedObjectContext;

@property (copy) void(^initCallback)();

- (void)initializeCoreData;

@end

@implementation MRReadOnlyPersistenceController

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
    [[self managedObjectContext] setPersistentStoreCoordinator:coordinator];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSPersistentStoreCoordinator *psc = [[self managedObjectContext] persistentStoreCoordinator];
        NSMutableDictionary *options = [NSMutableDictionary dictionary];
        options[NSMigratePersistentStoresAutomaticallyOption] = @YES;
        options[NSInferMappingModelAutomaticallyOption] = @YES;
        options[NSSQLitePragmasOption] = @{ @"journal_mode":@"DELETE" };


        NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        NSURL *storeURL = [documentsURL URLByAppendingPathComponent:@"Tackle.sqlite"];

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

@end
