//
//  MRDateCollectionViewCell.m
//  Tackle
//
//  Created by Scott Bader on 12/28/14.
//  Copyright (c) 2014 Melody Road. All rights reserved.
//

#import "MRDateCollectionViewCell.h"

#import "MRMonthDateFormatter.h"
#import "MRWeekdayDateFormatter.h"
#import "MRDayOfMonthDateFormatter.h"

@interface MRDateCollectionViewCell ()

@property (nonatomic) UILabel *dayOfMonthLabel;
@property (nonatomic) UILabel *weekdayLabel;
@property (nonatomic) UILabel *monthLabel;
@property (nonatomic) UIView *separator;

@end

@implementation MRDateCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    if (self) {
        UIView *backgroundView = [[UIView alloc] init];
        backgroundView.backgroundColor = [UIColor offWhiteBackgroundColor];
        self.backgroundView = backgroundView;

        UIView *selectedView = [[UIView alloc] init];
        selectedView.backgroundColor = [UIColor grayBorderColor];
        self.selectedBackgroundView = selectedView;

//        self.contentView.backgroundColor = [UIColor offWhiteBackgroundColor];
        [self setupDayOfMonthLabel];
        [self setupWeekdayLabel];
        [self setupMonthLabel];
        [self setupSeparator];
        [self setupConstrants];
    }

    return self;
}

- (void)setupDayOfMonthLabel {
    self.dayOfMonthLabel = [[UILabel alloc] init];
    self.dayOfMonthLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.dayOfMonthLabel.textColor = [UIColor plumTintColor];
    self.dayOfMonthLabel.font = [UIFont fontForCalendarDayOfMonth];
    self.dayOfMonthLabel.textAlignment = NSTextAlignmentCenter;

    [self.contentView addSubview:self.dayOfMonthLabel];
    [self.dayOfMonthLabel horizontalConstraintsMatchSuperview];
}

- (void)setupWeekdayLabel {
    self.weekdayLabel = [[UILabel alloc] init];
    self.weekdayLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.weekdayLabel.textColor = [UIColor grayTextColor];
    self.weekdayLabel.font = [UIFont fontForCalendarWeekday];
    self.weekdayLabel.textAlignment = NSTextAlignmentCenter;

    [self.contentView addSubview:self.weekdayLabel];
    [self.weekdayLabel horizontalConstraintsMatchSuperview];
}

- (void)setupMonthLabel {
    self.monthLabel = [[UILabel alloc] init];
    self.monthLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.monthLabel.textColor = [UIColor grayTextColor];
    self.monthLabel.font = [UIFont fontForCalendarMonth];
    self.monthLabel.textAlignment = NSTextAlignmentCenter;

    [self.contentView addSubview:self.monthLabel];
    [self.monthLabel horizontalConstraintsMatchSuperview];
}

- (void)setupSeparator {
    self.separator = [[UIView alloc] init];
    self.separator.translatesAutoresizingMaskIntoConstraints = NO;
    self.separator.backgroundColor = [UIColor grayBorderColor];
    [self.contentView addSubview:self.separator];

    [self.separator verticalConstraintsMatchSuperview];
}

- (void)setupConstrants {
    [self.contentView addCompactConstraints:@[
                                              @"month.top = view.top + 7",
                                              @"weekday.bottom = view.bottom - 7",
                                              @"dayOfMonth.centerY = view.centerY",
                                              @"separator.trailing = view.trailing",
                                              @"separator.width = 1",
                                              ]
                                    metrics:@{}
                                      views:@{
                                              @"weekday": self.weekdayLabel,
                                              @"month": self.monthLabel,
                                              @"dayOfMonth": self.dayOfMonthLabel,
                                              @"separator": self.separator,
                                              @"view": self.contentView
                                              }];
}

- (void)setDate:(NSDate *)date {
    self.dayOfMonthLabel.text = [[MRDayOfMonthDateFormatter sharedFormatter] stringFromDate:date];
    self.weekdayLabel.text = [[MRWeekdayDateFormatter sharedFormatter] stringFromDate:date];
    self.monthLabel.text = [[MRMonthDateFormatter sharedFormatter] stringFromDate:date];
}

@end
