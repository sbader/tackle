//
//  UIImage+TackleAdditions.m
//  Tackle
//
//  Created by Scott Bader on 2/1/16.
//  Copyright © 2016 Melody Road. All rights reserved.
//

#import "UIImage+TackleAdditions.h"

@implementation UIImage (TackleAdditions)

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

@end
