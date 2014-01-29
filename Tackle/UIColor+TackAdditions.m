//
//  UIColor+TackAdditions.m
//  Tackle
//
//  Created by Scott Bader on 1/26/14.
//  Copyright (c) 2014 Melody Road. All rights reserved.
//

#import "UIColor+TackAdditions.h"

@implementation UIColor (TackAdditions)

+ (UIColor *)lightPlumColor
{
    return UIColorFromRGB(0xF5F1F7);
}

+ (UIColor *)darkPlumColor
{
    return UIColorFromRGB(0x1B1323);
}

+ (UIColor *)softGrayColor
{
    return UIColorFromRGB(0xBEB8C0);
}

+ (UIColor *)lightPlumGrayColor
{
    return UIColorFromRGB(0xACA8AF);
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

@end
