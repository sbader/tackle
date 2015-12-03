//
//  MRParentDataCoordinator.m
//  Tackle
//
//  Created by Scott Bader on 4/29/15.
//  Copyright (c) 2015 Melody Road. All rights reserved.
//

#import "MRParentDataCoordinator.h"

#import "MRTackleDataConstants.h"
#import <WatchKit/WatchKit.h>
#import <WatchConnectivity/WatchConnectivity.h>

@interface MRParentDataCoordinator() <WCSessionDelegate>

@property (nonatomic) WCSession *session;

@end

@implementation MRParentDataCoordinator

- (instancetype)init {
    self = [super init];

    if (self) {
        if ([WCSession isSupported]) {
            _session = [WCSession defaultSession];
            _session.delegate = self;
            [_session activateSession];
        }
    }

    return self;
}

- (void)notifyParentApplicationWithNotificationType:(NSString *)notificationType context:(id)context {
    NSDictionary *userInfo = @{
                               kMRDataNotificationTypeKey: notificationType,
                               kMRDataNotificationContextKey: context
                               };

    [self.session transferUserInfo:userInfo];
}

- (void)completeTask:(Task *)task withCompletion:(void(^)(NSError *error))completion {
    NSDictionary *context = @{
                              kMRDataNotificationTaskAttributeUniqueID: [self uniqueIDForTask:task]
                              };
    [self notifyParentApplicationWithNotificationType:kMRDataNotificationTypeTaskCompleted context:context];
    completion(nil);
}

- (void)updateTask:(Task *)task withCompletion:(void(^)(NSError *error))completion {
    NSDictionary *context = @{
                              kMRDataNotificationTaskAttributeTitle: task.title,
                              kMRDataNotificationTaskAttributeDueDate: task.dueDate,
                              kMRDataNotificationTaskAttributeUniqueID: [self uniqueIDForTask:task]
                              };
    [self notifyParentApplicationWithNotificationType:kMRDataNotificationTypeTaskUpdate context:context];
    completion(nil);
}

- (void)createTaskWithTitle:(NSString *)title dueDate:(NSDate *)dueDate completion:(void(^)(NSError *error))completion {
    NSDictionary *context = @{
                              kMRDataNotificationTaskAttributeTitle: title,
                              kMRDataNotificationTaskAttributeDueDate: dueDate
                              };

    [self notifyParentApplicationWithNotificationType:kMRDataNotificationTypeTaskCreate context:context];
    completion(nil);
}

- (NSString *)uniqueIDForTask:(Task *)task {
    return task.objectID.URIRepresentation.absoluteString;
}

#pragma mark - WCSessionDelegate

- (void)session:(WCSession *)session didReceiveUserInfo:(NSDictionary<NSString *,id> *)userInfo {
    
}

@end
