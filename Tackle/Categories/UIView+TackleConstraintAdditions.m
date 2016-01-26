//
//  UIView+TackleAdditions.m
//  Tackle
//
//  Created by Scott Bader on 2/2/14.
//  Copyright (c) 2014 Melody Road. All rights reserved.
//

#import "UIView+TackleConstraintAdditions.h"

@implementation UIView (TackleConstraintAdditions)

- (void)horizontalConstraintsMatchSuperview {
    [self.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|"
                                                                           options:0
                                                                           metrics:0
                                                                             views:@{
                                                                                     @"view": self
                                                                                     }]];
}

- (void)verticalConstraintsMatchSuperview {
    [self.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|"
                                                                           options:0
                                                                           metrics:0
                                                                             views:@{
                                                                                     @"view": self
                                                                                     }]];
}

- (void)constraintsMatchSuperview {
    [self horizontalConstraintsMatchSuperview];
    [self verticalConstraintsMatchSuperview];
}

- (void)staticHeightConstraint:(CGFloat)height {
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1.0
                                                      constant:height]];
}

- (void)staticWidthConstraint:(CGFloat)width {
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                    multiplier:1.0
                                                      constant:width]];
}

- (void)topConstraintMatchesSuperview {
    [self topConstraintMatchesSuperviewWithConstant:0];
}

- (void)bottomConstraintMatchesSuperview {
    [self bottomConstraintMatchesSuperviewWithConstant:0];
}

- (void)leadingConstraintMatchesSuperview {
    [self leadingConstraintMatchesSuperviewWithConstant:0];
}

- (void)trailingConstraintMatchesSuperview {
    [self trailingConstraintMatchesSuperviewWithConstant:0];
}

- (void)topConstraintMatchesSuperviewWithConstant:(CGFloat)constant {
    [self topConstraintMatchesView:self.superview withConstant:constant];
}

- (void)bottomConstraintMatchesSuperviewWithConstant:(CGFloat)constant {
    [self bottomConstraintMatchesView:self.superview withConstant:constant];
}

- (void)leadingConstraintMatchesSuperviewWithConstant:(CGFloat)constant {
    [self leadingConstraintMatchesView:self.superview withConstant:constant];
}

- (void)trailingConstraintMatchesSuperviewWithConstant:(CGFloat)constant {
    [self trailingConstraintMatchesView:self.superview withConstant:constant];
}

- (void)horizontalCenterConstraintMatchesSuperview {
    [self addConstraintEqualToView:self.superview inContainer:self.superview withAttribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
}

- (void)verticalCenterConstraintMatchesSuperview {
    [self addConstraintEqualToView:self.superview inContainer:self.superview withAttribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
}

- (void)topConstraintMatchesView:(UIView *)view withConstant:(CGFloat)constant {
    [self addConstraintEqualToView:view inContainer:self.superview withAttribute:NSLayoutAttributeTop multiplier:1.0 constant:constant];
}

- (void)bottomConstraintMatchesView:(UIView *)view withConstant:(CGFloat)constant {
    [self addConstraintEqualToView:view inContainer:self.superview withAttribute:NSLayoutAttributeBottom multiplier:1.0 constant:constant];
}

- (void)leadingConstraintMatchesView:(UIView *)view {
    [self leadingConstraintMatchesView:view withConstant:0.0];
}

- (void)leadingConstraintMatchesView:(UIView *)view withConstant:(CGFloat)constant {
    [self addConstraintEqualToView:view inContainer:self.superview withAttribute:NSLayoutAttributeLeading multiplier:1.0 constant:constant];
}

- (void)trailingConstraintMatchesView:(UIView *)view {
    [self trailingConstraintMatchesView:view withConstant:0.0];
}

- (void)trailingConstraintMatchesView:(UIView *)view withConstant:(CGFloat)constant {
    [self addConstraintEqualToView:view inContainer:self.superview withAttribute:NSLayoutAttributeTrailing multiplier:1.0 constant:constant];
}

- (void)horizontalCenterConstraintMatchesView:(UIView *)view {
    [self horizontalCenterConstraintMatchesView:view withMultiplier:1.0 constant:0];
}

- (void)horizontalCenterConstraintMatchesView:(UIView *)view withMultiplier:(CGFloat)multiplier constant:(CGFloat)constant {
    [self addConstraintEqualToView:view inContainer:self.superview withAttribute:NSLayoutAttributeCenterX multiplier:multiplier constant:constant];
}

- (void)verticalCenterConstraintMatchesView:(UIView *)view {
    [self verticalCenterConstraintMatchesView:view withMultiplier:1.0 constant:0];
}

- (void)verticalCenterConstraintMatchesView:(UIView *)view withMultiplier:(CGFloat)multiplier constant:(CGFloat)constant {
    [self addConstraintEqualToView:view inContainer:self.superview withAttribute:NSLayoutAttributeCenterY multiplier:multiplier constant:constant];
}

- (void)addConstraintEqualToView:(UIView *)view inContainer:(UIView *)container withAttribute:(NSLayoutAttribute)attribute multiplier:(CGFloat)multiplier constant:(CGFloat)constant {
    [container addConstraint:[self constraintEqualToView:view withAttribute:attribute multiplier:multiplier constant:constant]];
}

- (void)addConstraintEqualToView:(UIView *)view inContainer:(UIView *)container withAttribute:(NSLayoutAttribute)attribute relatedAttribute:(NSLayoutAttribute)relatedAttribute multiplier:(CGFloat)multiplier constant:(CGFloat)constant {
    [container addConstraint:[self constraintEqualToView:view withAttribute:attribute relatedAttribute:relatedAttribute multiplier:multiplier constant:constant]];
}

- (NSLayoutConstraint *)constraintEqualToView:(UIView *)view withAttribute:(NSLayoutAttribute)attribute multiplier:(CGFloat)multiplier constant:(CGFloat)constant {
    return [self constraintEqualToView:view
                         withAttribute:attribute
                      relatedAttribute:attribute
                            multiplier:multiplier
                              constant:constant];
}

- (NSLayoutConstraint *)constraintEqualToView:(UIView *)view withAttribute:(NSLayoutAttribute)attribute relatedAttribute:(NSLayoutAttribute)relatedAttribute multiplier:(CGFloat)multiplier constant:(CGFloat)constant {
    return [NSLayoutConstraint constraintWithItem:self
                                        attribute:attribute
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:view
                                        attribute:relatedAttribute
                                       multiplier:multiplier
                                         constant:constant];
}


@end
