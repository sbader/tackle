//
//  UIView+TackleAdditions.m
//  Tackle
//
//  Created by Scott Bader on 2/2/14.
//  Copyright (c) 2014 Melody Road. All rights reserved.
//

#import "UIView+TackleAdditions.h"

@implementation UIView (TackleAdditions)

- (CGFloat)angleOfView {
    return atan2(self.transform.b, self.transform.a);
}

- (void)horizontalConstraintsMatchSuperview {
    [self.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|"
                                                                           options:0
                                                                           metrics:0
                                                                             views:@{
                                                                                     @"view": self
                                                                                     }]];
//    [self.superview addConstraints:@[
//                                     [NSLayoutConstraint constraintWithItem:self
//                                                                  attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual
//                                                                     toItem:self.superview
//                                                                  attribute:NSLayoutAttributeLeading
//                                                                 multiplier:1.0
//                                                                   constant:0],
//                                     [NSLayoutConstraint constraintWithItem:self
//                                                                  attribute:NSLayoutAttributeTrailing
//                                                                  relatedBy:NSLayoutRelationEqual
//                                                                     toItem:self.superview
//                                                                  attribute:NSLayoutAttributeTrailing
//                                                                 multiplier:1.0
//                                                                   constant:0]
//                                     ]];

}

- (void)verticalConstraintsMatchSuperview {
    [self.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|"
                                                                           options:0
                                                                           metrics:0
                                                                             views:@{
                                                                                     @"view": self
                                                                                     }]];
//    [self.superview addConstraints:@[
//                                     [NSLayoutConstraint constraintWithItem:self
//                                                                  attribute:NSLayoutAttributeTop
//                                                                  relatedBy:NSLayoutRelationEqual
//                                                                     toItem:self.superview
//                                                                  attribute:NSLayoutAttributeTop
//                                                                 multiplier:1.0
//                                                                   constant:0],
//                                     [NSLayoutConstraint constraintWithItem:self
//                                                                  attribute:NSLayoutAttributeBottom
//                                                                  relatedBy:NSLayoutRelationEqual
//                                                                     toItem:self.superview
//                                                                  attribute:NSLayoutAttributeBottom
//                                                                 multiplier:1.0
//                                                                   constant:0]
//                                     ]];
//
}

- (void)constraintsMatchSuperview {
    [self horizontalConstraintsMatchSuperview];
    [self verticalConstraintsMatchSuperview];
}

@end
