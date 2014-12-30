//
//  MRHorizontalButton.m
//  Tackle
//
//  Created by Scott Bader on 12/28/14.
//  Copyright (c) 2014 Melody Road. All rights reserved.
//

#import "MRHorizontalButton.h"

@implementation MRHorizontalButton

- (void)layoutSubviews {
    [super layoutSubviews];

    UIImageView *imageView = [self imageView];
    UILabel *label = [self titleLabel];

    CGRect imageFrame = imageView.frame;
    CGRect labelFrame = label.frame;

    labelFrame.origin.x = 0 + 20;
    imageFrame.origin.x = self.frame.size.width - imageFrame.size.width - 20;

    imageView.frame = imageFrame;
    label.frame = labelFrame;
}

@end
