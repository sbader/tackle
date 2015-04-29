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

@implementation MRParentDataCoordinator

- (void)notifyParentApplicationWithNotificationType:(NSString *)notificationType context:(id)context completion:(void(^)(NSError *error))completion {
    NSDictionary *userInfo = @{
                               kMRDataNotificationTypeKey: notificationType,
                               kMRDataNotificationContextKey: context
                               };

    [WKInterfaceController openParentApplication:userInfo reply:^(NSDictionary *replyInfo, NSError *error) {
        if (error) {
            completion(error);
            return;
        }

        NSString *success = [replyInfo objectForKey:kMRDataNotificationResponseTypeKey];
        if (success) {
            if ([success isEqualToString:kMRDataNotificationResponseSuccess]) {
                completion(nil);
            }
            else {
                NSDictionary *errorInfo = @{
                                            NSLocalizedDescriptionKey: @"Parent application returned an error on save"
                                            };

                error = [NSError errorWithDomain:@"com.melodyroad.Tackle" code:-1001 userInfo:errorInfo];
                completion(error);
            }

        }
        else {
            NSDictionary *errorInfo = @{
                                        NSLocalizedDescriptionKey: @"No response returned from parent application"
                                        };

            error = [NSError errorWithDomain:@"com.melodyroad.Tackle" code:-1001 userInfo:errorInfo];
            completion(error);
        }
    }];
}

- (void)completeTask:(Task *)task withCompletion:(void(^)(NSError *error))completion {
    NSDictionary *context = @{
                              kMRDataNotificationTaskAttributeUniqueID: [self uniqueIDForTask:task]
                              };
    [self notifyParentApplicationWithNotificationType:kMRDataNotificationTypeTaskCompleted context:context completion:^(NSError *error) {
        completion(error);
    }];
}

- (void)updateTask:(Task *)task withCompletion:(void(^)(NSError *error))completion {
    NSDictionary *context = @{
                              kMRDataNotificationTaskAttributeTitle: task.title,
                              kMRDataNotificationTaskAttributeDueDate: task.dueDate,
                              kMRDataNotificationTaskAttributeUniqueID: [self uniqueIDForTask:task]
                              };
    [self notifyParentApplicationWithNotificationType:kMRDataNotificationTypeTaskUpdate context:context completion:^(NSError *error) {
        completion(error);
    }];
}

- (void)createTask:(Task *)task withCompletion:(void(^)(NSError *error))completion {
    NSDictionary *context = @{
                              kMRDataNotificationTaskAttributeTitle: task.title,
                              kMRDataNotificationTaskAttributeDueDate: task.dueDate
                              };

    [self notifyParentApplicationWithNotificationType:kMRDataNotificationTypeTaskCreate context:context completion:^(NSError *error) {
        completion(error);
    }];
}

- (NSString *)uniqueIDForTask:(Task *)task {
    return task.objectID.URIRepresentation.absoluteString;
}


@end
