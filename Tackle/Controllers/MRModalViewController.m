//
//  MRModalViewController.m
//  Tackle
//
//  Created by Scott Bader on 1/1/15.
//  Copyright (c) 2015 Melody Road. All rights reserved.
//

#import "MRModalViewController.h"

@interface MRModalViewController ()

@property (nonatomic) UIImageView *snapshotView;
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
        self.view.backgroundColor = [UIColor whiteColor];
        [self setupSnapshotView];
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

    self.overlayView.backgroundColor = [UIColor colorWithRed:0.149 green:0.129 blue:0.169 alpha:0.650];

    [self.view addSubview:self.overlayView];

    [self.overlayView constraintsMatchSuperview];
}

- (void)setupSnapshotView {
    self.snapshotView = [[UIImageView alloc] init];
    self.snapshotView.translatesAutoresizingMaskIntoConstraints = NO;

    CALayer *layer = self.snapshotView.layer;
    layer.masksToBounds = NO;
    layer.shadowColor = [UIColor blackColor].CGColor;
    layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    layer.shadowOpacity = 0.5f;

    [self.view addSubview:self.snapshotView];

    [self.snapshotView constraintsMatchSuperview];
}

- (void)setupContentView {
    self.contentViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.contentViewController.view];

    [self.contentViewController.view horizontalConstraintsMatchSuperview];
    self.contentViewBottomConstraint = [self.contentViewController.view constraintEqualToView:self.view
                                                                                withAttribute:NSLayoutAttributeBottom
                                                                                   multiplier:1.0
                                                                                     constant:0];

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

    UIGraphicsBeginImageContextWithOptions(window.bounds.size, NO, 0);
    [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.snapshotView.image = image;

    [window addSubview:self.view];
    [self.view constraintsMatchSuperview];
    [self.view layoutIfNeeded];

    self.snapshotView.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.snapshotView.bounds].CGPath;

    [self.view removeConstraint:self.contentViewTopConstraint];
    [self.view addConstraint:self.contentViewBottomConstraint];

    [UIView animateWithDuration:0.2 animations:^{
        self.snapshotView.transform = CGAffineTransformMakeScale(0.925, 0.925);
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

    [UIView animateWithDuration:0.2 animations:^{
        self.snapshotView.transform = CGAffineTransformMakeScale(1.0, 1.0);
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
        [self.contentViewController mr_dismissViewControllerModallyAnimated:YES completion:nil];\
    }
}

@end
