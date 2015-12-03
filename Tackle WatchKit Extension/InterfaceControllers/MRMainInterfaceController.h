//
//  InterfaceController.h
//  Tackle WatchKit Extension
//
//  Created by Scott Bader on 4/28/15.
//  Copyright (c) 2015 Melody Road. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>

extern NSString * const kMRDataUpdatedNotificationName;
extern NSString * const kMRInterfaceControllerContextTask;
extern NSString * const kMRInterfaceControllerContextPersistenceController;
extern NSString * const kMRInterfaceControllerContextDataReadingController;
extern NSString * const kMRInterfaceControllerContextConnectivityController;

@interface MRMainInterfaceController : WKInterfaceController

@end
