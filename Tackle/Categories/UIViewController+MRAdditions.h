//
//  UIViewController+MRAdditions.h
//  Tackle
//
//  Created by Scott Bader on 1/1/15.
//  Copyright (c) 2015 Melody Road. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MRModalViewController;

@interface UIViewController (MRAdditions)

@property (nonatomic, readonly) MRModalViewController *modalPresentedViewController;
@property (nonatomic, readonly) UIViewController *modalPresentingViewController;

- (void)mr_presentViewControllerModally:(UIViewController *)viewControllerToPresent animated:(BOOL)animated completion:(void (^)(void))completion;
- (void)mr_dismissViewControllerModallyAnimated:(BOOL)animated completion:(void (^)(void))completion;


@end
