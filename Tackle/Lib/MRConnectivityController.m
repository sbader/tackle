//
//  MRConnectivityController.m
//  Tackle
//
//  Created by Scott Bader on 8/10/15.
//  Copyright © 2015 Melody Road. All rights reserved.
//

#import "MRConnectivityController.h"

#import <WatchConnectivity/WatchConnectivity.h>
#import "MRPersistenceController.h"
#import "MRTackleDataConstants.h"
#import "Task.h"

@interface MRConnectivityController() <WCSessionDelegate>

@property (nonatomic) WCSession *session;
@property (nonatomic) MRPersistenceController *persistenceController;

@end

@implementation MRConnectivityController

- (instancetype)initWithPersistenceController:(MRPersistenceController *)persistenceController {
    self = [super init];

    if (self) {
        _persistenceController = persistenceController;

        if ([WCSession isSupported]) {
            self.session = [WCSession defaultSession];
            self.session.delegate = self;
            [self.session activateSession];
        }
    }

    return self;
}

- (void)sendNotificationWithType:(NSString *)type context:(NSDictionary *)context {
    NSDictionary *userInfo = @{
                               kMRDataNotificationTypeKey: type,
                               kMRDataNotificationContextKey: context
                               };

    [self.session transferUserInfo:userInfo];
//    NSLog(@"Sending UserInfo: %@", userInfo);
}

- (void)sendCompleteTaskNotificationWithTask:(Task *)task {
    NSDictionary *context = @{
                              kMRDataNotificationTaskAttributeIdentifier: task.identifier
                              };

    [self sendNotificationWithType:kMRDataNotificationTypeTaskCompleted context:context];
}

- (void)sendNewTaskNotificationWithTask:(Task *)task {
    NSDictionary *context = @{
                              kMRDataNotificationTaskAttributeIdentifier: task.identifier,
                              kMRDataNotificationTaskAttributeTitle: task.title,
                              kMRDataNotificationTaskAttributeDueDate: task.dueDate
                              };

    [self sendNotificationWithType:kMRDataNotificationTypeTaskCreate context:context];
}

- (void)sendUpdateTaskNotificationWithTask:(Task *)task {
    NSDictionary *context = @{
                              kMRDataNotificationTaskAttributeTitle: task.title,
                              kMRDataNotificationTaskAttributeDueDate: task.dueDate,
                              kMRDataNotificationTaskAttributeIdentifier: task.identifier
                              };

    [self sendNotificationWithType:kMRDataNotificationTypeTaskUpdate context:context];
}

- (void)insertTaskWithIdentifier:(NSString *)identifier title:(NSString *)title dueDate:(NSDate *)dueDate {
    Task *task = [Task insertItemWithTitle:title dueDate:dueDate identifier:identifier inManagedObjectContext:self.persistenceController.managedObjectContext];
    [self.persistenceController save];

    if ([self.delegate respondsToSelector:@selector(connectivityController:didAddTask:)]) {
        [self.delegate connectivityController:self didAddTask:task];
    }

    NSLog(@"Inserted Task with Identifier %@", identifier);
}

- (void)updateTaskWithIdentifier:(NSString *)identifier title:(NSString *)title dueDate:(NSDate *)dueDate {
    Task *task = [Task findTaskWithIdentifier:identifier inManagedObjectContext:self.persistenceController.managedObjectContext];

    task.title = title;
    task.dueDate = dueDate;

    [self.persistenceController save];

    if ([self.delegate respondsToSelector:@selector(connectivityController:didUpdateTask:)]) {
        [self.delegate connectivityController:self didUpdateTask:task];
    }

    NSLog(@"Updated Task with Identifier %@", identifier);
}

- (void)completeTaskWithIdentifier:(NSString *)identifier {
    Task *task = [Task findTaskWithIdentifier:identifier inManagedObjectContext:self.persistenceController.managedObjectContext];

    NSLog(@"found task with identifier: %@, title: %@, dueDate: %@", task.identifier, task.title, task.dueDate);

    task.isDone = YES;
    task.completedDate = [NSDate date];

    [self.persistenceController save];

    if ([self.delegate respondsToSelector:@selector(connectivityController:didCompleteTask:)]) {
        [self.delegate connectivityController:self didCompleteTask:task];
    }

    NSLog(@"Completed Task with Identifier %@", identifier);
}

#pragma mark - WCSession Delegate

- (void)session:(WCSession *)session didReceiveUserInfo:(NSDictionary<NSString *,id> *)userInfo {
    NSLog(@"DidReceiveUserInfo %@", userInfo);
    NSString *requestType = [userInfo objectForKey:kMRDataNotificationTypeKey];
    if (requestType) {
        if ([requestType isEqualToString:kMRDataNotificationTypeTaskCreate]) {
            NSDictionary *attributes = [userInfo objectForKey:kMRDataNotificationContextKey];
            NSString *title;
            NSString *identifier;
            NSDate *dueDate;
            if (attributes) {
                title = [attributes objectForKey:kMRDataNotificationTaskAttributeTitle];
                dueDate = [attributes objectForKey:kMRDataNotificationTaskAttributeDueDate];
                identifier = [attributes objectForKey:kMRDataNotificationTaskAttributeIdentifier];
            }

            if (title && dueDate && identifier) {
                [self insertTaskWithIdentifier:identifier title:title dueDate:dueDate];

                return;
            }
        }
        else if ([requestType isEqualToString:kMRDataNotificationTypeTaskUpdate]) {
            NSDictionary *attributes = [userInfo objectForKey:kMRDataNotificationContextKey];
            NSString *identifier;
            NSString *title;
            NSDate *dueDate;

            if (attributes) {
                identifier = [attributes objectForKey:kMRDataNotificationTaskAttributeIdentifier];
                title = [attributes objectForKey:kMRDataNotificationTaskAttributeTitle];
                dueDate = [attributes objectForKey:kMRDataNotificationTaskAttributeDueDate];
            }

            if (identifier && (title != nil || dueDate != nil)) {
                [self updateTaskWithIdentifier:identifier title:title dueDate:dueDate];
                return;
            }
        }
        else if ([requestType isEqualToString:kMRDataNotificationTypeTaskCompleted]) {
            NSDictionary *attributes = [userInfo objectForKey:kMRDataNotificationContextKey];
            NSString *identifier;
            if (attributes) {
                identifier = [attributes objectForKey:kMRDataNotificationTaskAttributeIdentifier];
                if (identifier) {
                    [self completeTaskWithIdentifier:identifier];
                }
            }
        }
    }
}

@end
