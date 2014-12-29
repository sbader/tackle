//
//  UIColor+TackleAdditions.m
//  Tackle
//
//  Created by Scott Bader on 1/26/14.
//  Copyright (c) 2014 Melody Road. All rights reserved.
//

#import "UIColor+TackleAdditions.h"

@implementation UIColor (TackleAdditions)

+ (UIColor *)lightPlumColor
{
    return UIColorFromRGB(0xF3F3F4);
}

+ (UIColor *)darkPlumColor
{
    return UIColorFromRGB(0x120D17);
}

+ (UIColor *)softGrayColor
{
    return UIColorFromRGB(0xBEB8C0);
}

+ (UIColor *)lightPlumGrayColor
{
    return UIColorFromRGB(0xACA8AF);
}

+ (UIColor *)midGrayColor
{
    return UIColorFromRGB(0xE7E6E8);
}

+ (UIColor *)lightOpaqueGrayColor
{
    return UIColorFromRGBWithAlpha(0x645F67, 50.0f);
}

+ (UIColor *)midOpaqueGrayColor
{
    return UIColorFromRGBWithAlpha(0x4E4752, 33.0f);
}

+ (UIColor *)lightOpaquePlumColor
{
    return UIColorFromRGBWithAlpha(0xCFC5D5, 75.0f);
}

# pragma mark - New Colors

+ (UIColor *)offWhiteBackgroundColor {
    return UIColorFromRGB(0xEBEBEB);
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

@end
