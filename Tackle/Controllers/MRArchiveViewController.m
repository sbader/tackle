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

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Delete All", nil)
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self action:@selector(handleClearButton:)];

    self.tableViewController = [[MRArchiveTableViewController alloc] initWithPersistenceController:self.persistenceController];
    self.tableViewController.archiveTaskDelegate = self.archiveTaskDelegate;
    [self addChildViewController:self.tableViewController];
    [self.view addSubview:self.tableViewController.view];
    [self.tableViewController.view constraintsMatchSuperview];
}

- (void)handleClearButton:(id)sender {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Task"];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"isDone == YES"]];
    [fetchRequest setIncludesPropertyValues:NO];

    NSError *requestError = nil;
    NSArray *tasks = [self.persistenceController.managedObjectContext executeFetchRequest:fetchRequest error:&requestError];

    for (Task *task in tasks) {
        [self.persistenceController.managedObjectContext deleteObject:task];
    }

    [[self undoManager] setActionName:@"Clear Tasks"];
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (NSUndoManager *)undoManager {
    return self.persistenceController.managedObjectContext.undoManager;
}

@end
