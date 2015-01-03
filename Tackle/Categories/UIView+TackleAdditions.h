//
//  UIView+TackleAdditions.h
//  Tackle
//
//  Created by Scott Bader on 2/2/14.
//  Copyright (c) 2014 Melody Road. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (TackleAdditions)

- (CGFloat)angleOfView;
- (void)constraintsMatchSuperview;
- (void)horizontalConstraintsMatchSuperview;
- (void)verticalConstraintsMatchSuperview;
- (void)bottomConstraintMatchesSuperview;
- (void)topConstraintMatchesSuperview;
- (void)leadingConstraintMatchesSuperview;
- (void)trailingConstraintMatchesSuperview;
- (void)topConstraintMatchesSuperviewWithConstant:(CGFloat)constant;
- (void)bottomConstraintMatchesSuperviewWithConstant:(CGFloat)constant;
- (void)leadingConstraintMatchesSuperviewWithConstant:(CGFloat)constant;
- (void)trailingConstraintMatchesSuperviewWithConstant:(CGFloat)constant;
- (void)topConstraintMatchesView:(UIView *)view withConstant:(CGFloat)constant;
- (void)bottomConstraintMatchesView:(UIView *)view withConstant:(CGFloat)constant;
- (void)leadingConstraintMatchesView:(UIView *)view withConstant:(CGFloat)constant;
- (void)trailingConstraintMatchesView:(UIView *)view withConstant:(CGFloat)constant;
- (void)staticHeightConstraint:(CGFloat)height;
- (void)staticWidthConstraint:(CGFloat)width;
- (void)horizontalCenterConstraintMatchesSuperview;
- (void)verticalCenterConstraintMatchesSuperview;
- (void)horizontalCenterConstraintMatchesView:(UIView *)view;
- (void)verticalCenterConstraintMatchesView:(UIView *)view;
- (void)horizontalCenterConstraintMatchesView:(UIView *)view withMultiplier:(CGFloat)multiplier constant:(CGFloat)constant;
- (void)verticalCenterConstraintMatchesView:(UIView *)view withMultiplier:(CGFloat)multiplier constant:(CGFloat)constant;
- (void)addConstraintEqualToView:(UIView *)view inContainer:(UIView *)container withAttribute:(NSLayoutAttribute)attribute multiplier:(CGFloat)multiplier constant:(CGFloat)constant;
- (NSLayoutConstraint *)constraintEqualToView:(UIView *)view withAttribute:(NSLayoutAttribute)attribute multiplier:(CGFloat)mutliplier constant:(CGFloat)constant;
@end
