//
//  NotificationController.m
//  Tackle WatchKit Extension
//
//  Created by Scott Bader on 4/28/15.
//  Copyright (c) 2015 Melody Road. All rights reserved.
//

#import "NotificationController.h"


@interface NotificationController()

@property (weak) IBOutlet WKInterfaceLabel *titleLabel;

@end


@implementation NotificationController

- (instancetype)init {
    self = [super init];
    if (self){
    }
    return self;
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}


//- (void)didReceiveLocalNotification:(UILocalNotification *)localNotification withCompletion:(void (^)(WKUserNotificationInterfaceType))completionHandler {
//    NSLog(@"received local notification");
//    completionHandler(WKUserNotificationInterfaceTypeDefault);
//}

@end



