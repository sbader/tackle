//
//  MRRootViewController.m
//  Tackle
//
//  Created by Scott Bader on 12/27/14.
//  Copyright (c) 2014 Melody Road. All rights reserved.
//

#import "MRRootViewController.h"

#import "Task.h"
#import "MRTaskListViewController.h"
#import "MRNotificationPermissionsProvider.h"

@interface MRRootViewController ()

@property (nonatomic) MRTaskListViewController *taskListController;
@property (nonatomic) MRPersistenceController *persistenceController;
@property (nonatomic) UINavigationController *navigationController;

@end

@implementation MRRootViewController

- (instancetype)initWithPersistenceController:(MRPersistenceController *)persistenceController {
    self = [super init];

    if (self) {
        _persistenceController = persistenceController;

        self.taskListController = [[MRTaskListViewController alloc] initWithPersistenceController:self.persistenceController];
        self.navigationController = [[UINavigationController alloc] initWithRootViewController:self.taskListController];
        
        [self addChildViewController:self.navigationController];
        [self.view addSubview:self.navigationController.view];
    }

    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    if ([[MRNotificationPermissionsProvider sharedInstance] shouldRequestPermissions]) {
        [self displayNotificationPermissionsRequestPriming];
    }
//    else if (![[MRNotificationPermissionsProvider sharedInstance] userNotificationsEnabled]) {
//        [self displayNotificationPermissionsNeededMessage];
//    }
}

- (void)displayNotificationPermissionsRequestPriming {
    [[MRNotificationPermissionsProvider sharedInstance] permissionsRequested];

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Notifications Priming Title", nil)
                                                                             message:NSLocalizedString(@"Notifications Priming Text", nil)
                                                                      preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *disallowAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Dont’t Allow", nil)
                                                             style:UIAlertActionStyleCancel
                                                           handler:nil];

    __block id blockSelf = self;

    UIAlertAction *allowAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Allow", nil)
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *action) {
                                                            [blockSelf requestNotificationPermissions];
                                                        }];

    [alertController addAction:disallowAction];
    [alertController addAction:allowAction];

    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)displayNotificationPermissionsNeededMessage {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Notifications Needed Title", nil)
                                                                             message:NSLocalizedString(@"Notifications Needed Text", nil)
                                                                      preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *disallowAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Close", nil)
                                                             style:UIAlertActionStyleCancel
                                                           handler:nil];

    __block id blockSelf = self;

    UIAlertAction *allowAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Open Settings", nil)
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *action) {
                                                            [blockSelf openSettingsApp];
                                                        }];

    [alertController addAction:disallowAction];
    [alertController addAction:allowAction];

    [self presentViewController:alertController animated:YES completion:nil];

}

- (void)requestNotificationPermissions {
    [[MRNotificationPermissionsProvider sharedInstance] registerNotificationPermissions];
}

- (void)openSettingsApp {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}

- (void)handleNotificationForTask:(Task *)task {
    [self.taskListController handleNotificationForTask:task];
}

- (void)refreshTasks {
    [self.taskListController refreshTasks];
}

@end
