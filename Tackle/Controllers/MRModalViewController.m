//
//  MRModalViewController.m
//  Tackle
//
//  Created by Scott Bader on 1/1/15.
//  Copyright (c) 2015 Melody Road. All rights reserved.
//

#import "MRModalViewController.h"

@interface MRModalViewController ()

@property (nonatomic) UIViewController *contentViewController;
@property (nonatomic) UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic) NSLayoutConstraint *contentViewBottomConstraint;
@property (nonatomic) NSLayoutConstraint *contentViewTopConstraint;
@property (nonatomic) UIView *overlayView;

@end

@implementation MRModalViewController

- (instancetype)initWithContentViewController:(UIViewController *)viewController {
    self = [super init];

    if (self) {
        self.contentViewController = viewController;
        self.view.translatesAutoresizingMaskIntoConstraints = NO;
        self.view.backgroundColor = [UIColor clearColor];
        [self setupOverlayView];
        [self setupContentView];

        self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        [self.overlayView addGestureRecognizer:self.tapGestureRecognizer];
    }

    return self;
}

- (void)setupOverlayView {
    self.overlayView = [[UIView alloc] init];
    self.overlayView.translatesAutoresizingMaskIntoConstraints = NO;

    self.overlayView.backgroundColor = [UIColor modalOverlayColor];
    self.overlayView.alpha = 0.0;

    [self.view addSubview:self.overlayView];

    [self.overlayView constraintsMatchSuperview];
}

- (void)setupContentView {
    self.contentViewController.view.translatesAutoresizingMaskIntoConstraints = NO;

    UIView *contentView = self.contentViewController.view;

    [self.view addSubview:contentView];

    [self.view addConstraint:[contentView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor]];

    [self.view addConstraint:[contentView.widthAnchor constraintLessThanOrEqualToConstant:400.0]];
    NSLayoutConstraint *screenWidthConstraint = [contentView.widthAnchor constraintEqualToConstant:[UIScreen mainScreen].bounds.size.width - 20.0];
    screenWidthConstraint.priority = UILayoutPriorityDefaultHigh;
    [self.view addConstraint:screenWidthConstraint];


    self.contentViewBottomConstraint = [self.contentViewController.view constraintEqualToView:self.view
                                                                                withAttribute:NSLayoutAttributeBottom
                                                                                   multiplier:1.0
                                                                                     constant:-10.0];

    self.contentViewTopConstraint = [NSLayoutConstraint constraintWithItem:self.contentViewController.view
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.view
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:0];
    [self.view addConstraint:self.contentViewTopConstraint];
}

- (void)presentModallyAnimated:(BOOL)animated completion:(void (^)(void))completion {
    id<UIApplicationDelegate> appDelegate = [UIApplication sharedApplication].delegate;
    UIWindow *window = appDelegate.window;

    [window addSubview:self.view];
    [self.view constraintsMatchSuperview];
    [self.view layoutIfNeeded];

    [self.view removeConstraint:self.contentViewTopConstraint];
    [self.view addConstraint:self.contentViewBottomConstraint];

    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        window.subviews.firstObject.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
        self.overlayView.alpha = 0.65;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
    }];
}

- (void)dismissModallyAnimated:(BOOL)animated completion:(void (^)(void))completion {
    [self.view removeConstraint:self.contentViewBottomConstraint];
    [self.view addConstraint:self.contentViewTopConstraint];

    id<UIApplicationDelegate> appDelegate = [UIApplication sharedApplication].delegate;
    UIWindow *window = appDelegate.window;

    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        window.subviews.firstObject.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
        self.overlayView.alpha = 0.0;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        if (completion) {
            completion();
        }
    }];
}

#pragma mark - Handlers

- (void)handleTapGesture:(id)sender {
    if (self.contentViewController.modalPresentingViewController) {
        [self.contentViewController mr_dismissViewControllerModallyAnimated:YES completion:nil];
    }
}

@end
