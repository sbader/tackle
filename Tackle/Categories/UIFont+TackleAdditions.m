//
//  UIFont+TackleAdditions.m
//  Tackle
//
//  Created by Scott Bader on 1/25/14.
//  Copyright (c) 2014 Melody Road. All rights reserved.
//

#import "UIFont+TackleAdditions.h"

@implementation UIFont (TackleAdditions)

+ (UIFont *)adonisRegularWithSize:(CGFloat)size {
    return [UIFont fontWithName:@"Adonis-Regular" size:size];
}

+ (UIFont *)effraRegularWithSize:(CGFloat)size {
    return [UIFont fontWithName:@"Effra-Regular" size:size];
}

+ (UIFont *)effraLightWithSize:(CGFloat)size {
    return [UIFont fontWithName:@"Effra-Light" size:size];
}

+ (UIFont *)effraMediumWithSize:(CGFloat)size {
    return [UIFont fontWithName:@"Effra-Medium" size:size];
}

@end
