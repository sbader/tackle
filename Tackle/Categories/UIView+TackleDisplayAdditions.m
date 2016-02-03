//
//  UIView+TackleDisplayAdditions.m
//  Tackle
//
//  Created by Scott Bader on 2/3/16.
//  Copyright © 2016 Melody Road. All rights reserved.
//

#import "UIView+TackleDisplayAdditions.h"

@implementation UIView (TackleDisplayAdditions)

- (void)applyTackleLayerDisplay {
    self.layer.cornerRadius = 10.0;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0.85;
    self.layer.shadowRadius = 3.0;
    self.layer.shadowOffset = CGSizeMake(-2.0, 2.0);
    self.clipsToBounds = YES;
}

@end
