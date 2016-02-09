//
//  MRArchiveViewController.m
//  Tackle
//
//  Created by Scott Bader on 1/27/16.
//  Copyright © 2016 Melody Road. All rights reserved.
//

#import "MRArchiveViewController.h"

#import "MRPersistenceController.h"
#import "MRArchiveTableViewController.h"
#import "Task.h"

@interface MRArchiveViewController ()

@property (nonatomic) MRPersistenceController *persistenceController;
@property (nonatomic) MRArchiveTableViewController *tableViewController;

@end

@implementation MRArchiveViewController

- (instancetype)initWithPersistenceController:(MRPersistenceController *)persistenceController {
    self = [super init];

    if (self) {
        _persistenceController = persistenceController;
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = NSLocalizedString(@"Archive List Title", nil);
    self.view.backgroundColor = [UIColor grayBackgroundColor];

    self.tableViewController = [[MRArchiveTableViewController alloc] initWithPersistenceController:self.persistenceController];
    self.tableViewController.archiveTaskDelegate = self.archiveTaskDelegate;
    [self addChildViewController:self.tableViewController];
    [self.view addSubview:self.tableViewController.view];
    [self.tableViewController.view constraintsMatchSuperview];

    [self addObservers];
}

- (void)dealloc {
    [self removeObservers];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self countAndDisplayBarButtonItemForArchivedTasksAnimated:NO];
}

- (void)addObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(managedObjectContextDidChange:)
                                                 name:NSManagedObjectContextObjectsDidChangeNotification
                                               object:self.persistenceController.managedObjectContext];
}

- (void)removeObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)handleClearButton:(id)sender {
    NSFetchRequest *fetchRequest = [Task archivedTasksFetchRequestWithManagedObjectContext:self.persistenceController.managedObjectContext];
    [fetchRequest setIncludesPropertyValues:NO];

    NSError *error = nil;
    NSArray *tasks = [self.persistenceController.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    NSAssert(tasks != nil, @"Failed to execute fetch %@", error);

    for (Task *task in tasks) {
        [self.persistenceController.managedObjectContext deleteObject:task];
    }

    [[self undoManager] setActionName:@"Clear Tasks"];
    [self.persistenceController save];
    [self countAndDisplayBarButtonItemForArchivedTasksAnimated:YES];
}

- (UIBarButtonItem *)deleteAllBarButtonItem {
    return [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Delete All", nil)
                                            style:UIBarButtonItemStylePlain
                                           target:self action:@selector(handleClearButton:)];
}

- (void)countAndDisplayBarButtonItemForArchivedTasksAnimated:(BOOL)animated {
    NSFetchRequest *fetchRequest = [Task archivedTasksFetchRequestWithManagedObjectContext:self.persistenceController.managedObjectContext];
    [fetchRequest setFetchLimit:5];

    NSError *error = nil;
    NSInteger count = [self.persistenceController.managedObjectContext countForFetchRequest:fetchRequest error:&error];
    NSAssert(error == nil, @"Could not get count for fetch request: %@", error);

    if (count > 0) {
        [self.navigationItem setRightBarButtonItems:@[[self deleteAllBarButtonItem]] animated:animated];
    }
    else {
        [self.navigationItem setRightBarButtonItems:@[] animated:animated];
    }
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (NSUndoManager *)undoManager {
    return self.persistenceController.managedObjectContext.undoManager;
}

- (void)managedObjectContextDidChange:(id)sender {
    [self countAndDisplayBarButtonItemForArchivedTasksAnimated:YES];
}

@end
