//
//  MRScrollView.m
//  Tackle
//
//  Created by Scott Bader on 1/1/15.
//  Copyright (c) 2015 Melody Road. All rights reserved.
//

#import "MRScrollView.h"

@implementation MRScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.delaysContentTouches = NO;
    }

    return self;
}

- (BOOL)touchesShouldCancelInContentView:(UIView *)view {
    if ([view isKindOfClass:UIButton.class]) {
        return YES;
    }

    return [super touchesShouldCancelInContentView:view];
}

@end
