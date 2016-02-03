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
    return [self systemFontOfSize:20.0 weight:UIFontWeightRegular];
}

+ (UIFont *)fontForFormLabel {
    return [self systemFontOfSize:16.0 weight:UIFontWeightRegular];
}

+ (UIFont *)fontForBarTitle {
    return [self systemFontOfSize:18.0 weight:UIFontWeightSemibold];
}

+ (UIFont *)fontForBarButtonItemStandardStyle {
    return [self systemFontOfSize:18.0 weight:UIFontWeightRegular];
}

+ (UIFont *)fontForBarButtonItemDoneStyle {
    return [self systemFontOfSize:18.0 weight:UIFontWeightMedium];
}

+ (UIFont *)fontForCalendarWeekday {
    return [self systemFontOfSize:11.0 weight:UIFontWeightRegular];
}

+ (UIFont *)fontForCalendarDayOfMonth {
    return [self systemFontOfSize:22.0 weight:UIFontWeightMedium];
}

+ (UIFont *)fontForCalendarMonth {
    return [self systemFontOfSize:13.0 weight:UIFontWeightRegular];
}

+ (UIFont *)fontForFormButtons {
    return [self systemFontOfSize:19.0 weight:UIFontWeightMedium];
}

+ (UIFont *)fontForFormTextField {
    return [self systemFontOfSize:20.0 weight:UIFontWeightRegular];
}

+ (UIFont *)fontForLargeFormButtons {
    return [self systemFontOfSize:22.0 weight:UIFontWeightRegular];
}

+ (UIFont *)fontForInfoLabel {
    return [self systemFontOfSize:18.0 weight:UIFontWeightMedium];
}

+ (UIFont *)fontForTableViewTextLabel {
    return [self systemFontOfSize:20.0 weight:UIFontWeightMedium];
}

+ (UIFont *)fontForTableViewDetailLabel {
    return [self systemFontOfSize:14.0 weight:UIFontWeightRegular];
}

+ (UIFont *)fontForTableViewSectionHeader {
    return [self systemFontOfSize:12.0 weight:UIFontWeightMedium];
}

+ (UIFont *)fontForCreditsTextLabel {
    return [self systemFontOfSize:18.0 weight:UIFontWeightRegular];
}

+ (UIFont *)fontForCreditsLinks {
    return [self systemFontOfSize:18.0 weight:UIFontWeightRegular];
}


+ (UIFont *)fontForCreditsBottomText {
    return [self systemFontOfSize:18.0 weight:UIFontWeightRegular];
}

+ (UIFont *)fontForCreditsVersionText {
    return [self systemFontOfSize:18.0 weight:UIFontWeightMedium];
}

+ (UIFont *)fontForModalTitleLabel {
    return [self systemFontOfSize:20.0 weight:UIFontWeightMedium];
}

+ (UIFont *)fontForModalCloseButton {
    return [self systemFontOfSize:22.0 weight:UIFontWeightLight];
}

+ (UIFont *)fontForModalButton {
    return [self systemFontOfSize:22.0 weight:UIFontWeightSemibold];
}

+ (UIFont *)fontForModalDoneButton {
    return [self systemFontOfSize:22.0 weight:UIFontWeightSemibold];
}

+ (UIFont *)fontForModalTaskDoneButton {
    return [self systemFontOfSize:14.0 weight:UIFontWeightSemibold];
}

+ (UIFont *)fontForModalTaskTimeButtons {
    return [self systemFontOfSize:14.0 weight:UIFontWeightRegular];
}

@end
