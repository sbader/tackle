//
//  MRTodayTableViewCell.m
//  Tackle
//
//  Created by Scott Bader on 1/8/15.
//  Copyright (c) 2015 Melody Road. All rights reserved.
//

#import "MRTodayTableViewCell.h"

#import "UIView+TackleAdditions.h"
#import <NotificationCenter/NotificationCenter.h>

@implementation MRTodayTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        self.layoutMargins = UIEdgeInsetsZero;
        self.preservesSuperviewLayoutMargins = NO;
        self.selectionStyle = UITableViewCellSelectionStyleDefault;

        self.selectedBackgroundView = [[UIView alloc] init];
        self.selectedBackgroundView.backgroundColor = [UIColor colorWithWhite:0.75 alpha:0.1];


        self.taskLabel = [[UILabel alloc] init];
        self.taskLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.taskLabel.textColor = [UIColor whiteColor];
        self.taskLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        [self.contentView addSubview:self.taskLabel];

        self.timeLabel = [[UILabel alloc] init];
        self.timeLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.timeLabel.textColor = [UIColor whiteColor];
        self.timeLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
        [self.contentView addSubview:self.timeLabel];

        [self setupConstraints];
    }

    return self;
}

- (void)setupConstraints {
    [self.taskLabel topConstraintMatchesSuperviewWithConstant:10.0];
    [self.taskLabel leadingConstraintMatchesSuperviewWithConstant:8.0];
    [self.taskLabel trailingConstraintMatchesSuperviewWithConstant:-8.0];

    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.timeLabel
                                                                 attribute:NSLayoutAttributeTop
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.taskLabel
                                                                 attribute:NSLayoutAttributeBottom
                                                                multiplier:1.0
                                                                  constant:4.0]];

    [self.timeLabel trailingConstraintMatchesSuperviewWithConstant:-8.0];
    [self.timeLabel leadingConstraintMatchesSuperviewWithConstant:8.0];
    [self.timeLabel bottomConstraintMatchesSuperviewWithConstant:-10.0];
}

@end
