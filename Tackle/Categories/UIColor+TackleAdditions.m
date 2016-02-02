//
//  UIColor+TackleAdditions.m
//  Tackle
//
//  Created by Scott Bader on 1/26/14.
//  Copyright (c) 2014 Melody Road. All rights reserved.
//

#import "UIColor+TackleAdditions.h"

@implementation UIColor (TackleAdditions)

+ (UIColor *)offWhiteBackgroundColor {
    return UIColorFromRGB(0xEBEBEB);
}

+ (UIColor *)darkenedOffWhiteBackgroundColor {
    return UIColorFromRGB(0xA8A8A8);
}

+ (UIColor *)plumTintColor {
    return UIColorFromRGB(0x786292);
}

+ (UIColor *)grayBorderColor {
    return UIColorFromRGB(0xCACACA);
}

+ (UIColor *)grayTextColor {
    return UIColorFromRGB(0x3B3B3B);
}

+ (UIColor *)grayBackgroundColor {
    return UIColorFromRGB(0x3B3B3B);
}

+ (UIColor *)grayNavigationBarBackgroundColor {
    return UIColorFromRGB(0xDADADC);
}

+ (UIColor *)lightGrayFormBackgroundColor {
    return UIColorFromRGB(0xDADADC);
}

+ (UIColor *)destructiveColor {
    return UIColorFromRGB(0x9F4545);
}

+ (UIColor *)darkGrayBackgroundColor {
    return UIColorFromRGB(0x1A1A1A);
}

+ (UIColor *)modalOverlayColor {
    return [UIColor colorWithRed:0.149 green:0.129 blue:0.169 alpha:1.0];
}

@end
