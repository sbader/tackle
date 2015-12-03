//
//  MRConnectivityController.h
//  Tackle
//
//  Created by Scott Bader on 8/10/15.
//  Copyright © 2015 Melody Road. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Task;
@class MRPersistenceController;
@protocol MRConnectivityControllerDelegate;

@interface MRConnectivityController : NSObject

@property (nonatomic) id<MRConnectivityControllerDelegate> delegate;
- (instancetype)initWithPersistenceController:(MRPersistenceController *)persistenceController;

- (void)sendCompleteTaskNotificationWithTask:(Task *)task;
- (void)sendNewTaskNotificationWithTask:(Task *)task;
- (void)sendUpdateTaskNotificationWithTask:(Task *)task;

@end

@protocol MRConnectivityControllerDelegate <NSObject>

@optional

- (void)connectivityController:(MRConnectivityController *)connectivityController didAddTask:(Task *)task;
- (void)connectivityController:(MRConnectivityController *)connectivityController didUpdateTask:(Task *)task;
- (void)connectivityController:(MRConnectivityController *)connectivityController didCompleteTask:(Task *)task;

@end

