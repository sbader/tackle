//
//  MRNotificationsModalViewController.h
//  Tackle
//
//  Created by Scott Bader on 1/30/16.
//  Copyright © 2016 Melody Road. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Task.h"

@class MRPersistenceController;
@protocol MRTaskAlertingDelegate;

@interface MRNotificationsModalViewController : UIViewController

@property (weak) id<MRTaskAlertingDelegate> taskAlertingDelegate;

- (instancetype)initWithPersistenceController:(MRPersistenceController *)persistenceController;
- (void)displayTask:(Task *)task;

@end

@protocol MRTaskAlertingDelegate <NSObject>

- (void)editedAlertedTask:(Task *)task;
- (void)completedAlertedTask:(Task *)task;

@end