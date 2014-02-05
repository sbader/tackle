//
//  UIView+TackleAdditions.m
//  Tackle
//
//  Created by Scott Bader on 2/2/14.
//  Copyright (c) 2014 Melody Road. All rights reserved.
//

#import "UIView+TackleAdditions.h"

@implementation UIView (TackleAdditions)

- (CGFloat)angleOfView
{
    return atan2(self.transform.b, self.transform.a);
}

@end