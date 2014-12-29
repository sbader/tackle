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

@end
