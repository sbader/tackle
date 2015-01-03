//
//  MRModalViewController.h
//  Tackle
//
//  Created by Scott Bader on 1/1/15.
//  Copyright (c) 2015 Melody Road. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MRModalViewController : UIViewController

- (instancetype)initWithContentViewController:(UIViewController *)viewController;
- (void)presentModallyAnimated:(BOOL)animated completion:(void (^)(void))completion;
- (void)dismissModallyAnimated:(BOOL)animated completion:(void (^)(void))completion;

@end
