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

- (void)notifyParentApplicationWithNotificationType:(NSString *)notificationType context:(id)context {
    NSDictionary *userInfo = @{
                               kMRDataNotificationTypeKey: notificationType,
                               kMRDataNotificationContextKey: context
                               };

    [WKInterfaceController openParentApplication:userInfo reply:^(NSDictionary *replyInfo, NSError *error) {
    }];
}

- (void)updateTask:(Task *)task withCompletion:(void(^)(NSError *))completion {
}

- (void)createTask:(Task *)task withCompletion:(void(^)(NSError *))completion {
}



@end
