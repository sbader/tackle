//
//  UIFont+TackleAdditions.m
//  Tackle
//
//  Created by Scott Bader on 1/25/14.
//  Copyright (c) 2014 Melody Road. All rights reserved.
//

#import "UIFont+TackleAdditions.h"

@implementation UIFont (TackleAdditions)

+ (UIFont *)avenirNextRegularWithSize:(CGFloat)size {
    return [UIFont fontWithName:@"AvenirNext-Regular" size:size];
}

+ (UIFont *)avenirNextMediumWithSize:(CGFloat)size {
    return [UIFont fontWithName:@"AvenirNext-Medium" size:size];
}

+ (UIFont *)avenirNextDemiBoldWithSize:(CGFloat)size {
    return [UIFont fontWithName:@"AvenirNext-DemiBold" size:size];
}

+ (UIFont *)fontForFormTableViewCellTextLabel {
    return [self avenirNextRegularWithSize:20.0];
}

+ (UIFont *)fontForFormLabel {
    return [self avenirNextRegularWithSize:16.0];
}

+ (UIFont *)fontForBarTitle {
    return [self avenirNextDemiBoldWithSize:18.0];
}

+ (UIFont *)fontForBarButtonItemStandardStyle {
    return [self avenirNextRegularWithSize:18.0];
}

+ (UIFont *)fontForBarButtonItemDoneStyle {
    return [self avenirNextMediumWithSize:18.0];
}

+ (UIFont *)fontForCalendarWeekday {
    return [self avenirNextRegularWithSize:11.0];
}

+ (UIFont *)fontForCalendarDayOfMonth {
    return [self avenirNextMediumWithSize:22.0];
}

+ (UIFont *)fontForCalendarMonth {
    return [self avenirNextRegularWithSize:13.0];
}

+ (UIFont *)fontForFormButtons {
    return [self avenirNextMediumWithSize:19.0];
}

+ (UIFont *)fontForFormTextField {
    return [self avenirNextRegularWithSize:20.0];
}

+ (UIFont *)fontForLargeFormButtons {
    return [self avenirNextRegularWithSize:22.0];
}

+ (UIFont *)fontForInfoLabel {
    return [self avenirNextMediumWithSize:18.0];
}

+ (UIFont *)fontForTableViewTextLabel {
    return [self avenirNextMediumWithSize:20.0];
}

+ (UIFont *)fontForTableViewDetailLabel {
    return [self avenirNextRegularWithSize:14.0];
}

+ (UIFont *)fontForTableViewSectionHeader {
    return [self avenirNextMediumWithSize:12.0];
}

@end
