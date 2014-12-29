//
//  UIColor+TackleAdditions.h
//  Tackle
//
//  Created by Scott Bader on 1/26/14.
//  Copyright (c) 2014 Melody Road. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (TackleAdditions)

//RGB color macro
//Usage: UIColorFromRGB(0xAE66CC);
#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//RGB color macro with alpha
//Usage: UIColorFromRGBWithAlpha(0xAE66CC, 0.8);
#define UIColorFromRGBWithAlpha(rgbValue,a) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

+ (UIColor *)lightPlumColor;
+ (UIColor *)darkPlumColor;
+ (UIColor *)softGrayColor;
+ (UIColor *)midGrayColor;
+ (UIColor *)lightPlumGrayColor;
+ (UIColor *)lightOpaqueGrayColor;
+ (UIColor *)midOpaqueGrayColor;
+ (UIColor *)lightOpaquePlumColor;


+ (UIColor *)offWhiteBackgroundColor;
+ (UIColor *)plumTintColor;
+ (UIColor *)grayBorderColor;
+ (UIColor *)grayTextColor;
+ (UIColor *)grayBackgroundColor;
+ (UIColor *)grayNavigationBarBackgroundColor;
+ (UIColor *)lightGrayFormBackgroundColor;

@end
