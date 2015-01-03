//
//  UIViewController+MRAdditions.m
//  Tackle
//
//  Created by Scott Bader on 1/1/15.
//  Copyright (c) 2015 Melody Road. All rights reserved.
//

#import "UIViewController+MRAdditions.h"

#import <objc/runtime.h>
#import "MRAppDelegate.h"
#import "MRModalViewController.h"

static const char* MRModalPresentedViewControllerAssociatedKey = "MRModalPresentedViewControllerAssociatedKey";
static const char* MRModalPresentingViewControllerAssociatedKey = "MRModalPresentingViewControllerAssociatedKey";

@implementation UIViewController (MRAdditions)
@dynamic modalPresentedViewController;
@dynamic modalPresentingViewController;

- (MRModalViewController *)modalPresentedViewController {
    return objc_getAssociatedObject(self, MRModalPresentedViewControllerAssociatedKey);
}

- (void)setModalPresentedViewController:(MRModalViewController *)modalPresentedViewController {
    objc_setAssociatedObject(self, MRModalPresentedViewControllerAssociatedKey, modalPresentedViewController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIViewController *)modalPresentingViewController {
    return objc_getAssociatedObject(self, MRModalPresentingViewControllerAssociatedKey);
}

- (void)setModalPresentingViewController:(UIViewController *)modalPresentingViewController {
    objc_setAssociatedObject(self, MRModalPresentingViewControllerAssociatedKey, modalPresentingViewController, OBJC_ASSOCIATION_ASSIGN);
}

- (void)mr_presentViewControllerModally:(UIViewController *)viewControllerToPresent animated:(BOOL)animated completion:(void (^)(void))completion {
    viewControllerToPresent.modalPresentingViewController = self;
    self.modalPresentedViewController = [[MRModalViewController alloc] initWithContentViewController:viewControllerToPresent];
    [self.modalPresentedViewController presentModallyAnimated:animated completion:completion];
}

- (void)mr_dismissViewControllerModallyAnimated:(BOOL)animated completion:(void (^)(void))completion {
    if (!self.modalPresentingViewController) {
        [self.modalPresentedViewController dismissModallyAnimated:animated completion:completion];
    }
    else {
        [self.modalPresentingViewController.modalPresentedViewController dismissModallyAnimated:YES completion:completion];
    }
}

@end
