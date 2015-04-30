//
//  MRParentDataCoordinator.h
//  Tackle
//
//  Created by Scott Bader on 4/29/15.
//  Copyright (c) 2015 Melody Road. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Task.h"

@interface MRParentDataCoordinator : NSObject

- (void)completeTask:(Task *)task withCompletion:(void(^)(NSError *error))completion;
- (void)updateTask:(Task *)task withCompletion:(void(^)(NSError *error))completion;
- (void)createTaskWithTitle:(NSString *)title dueDate:(NSDate *)dueDate completion:(void(^)(NSError *error))completion;

@end
