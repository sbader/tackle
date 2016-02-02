//
//  MRNotificationTaskView.m
//  Tackle
//
//  Created by Scott Bader on 2/2/16.
//  Copyright © 2016 Melody Road. All rights reserved.
//

#import "MRNotificationTaskView.h"

@interface MRNotificationTaskView ()

@property (nonatomic) UIView *buttonsContainer;

@end

@implementation MRNotificationTaskView

- (instancetype)init {
    self = [super init];

    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;

        [self setupTitleLabel];
        [self setupDetailLabel];
        [self setupButtons];
        [self setupConstraints];
    }

    return self;
}

- (void)setupTitleLabel {
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.titleLabel.textColor = [UIColor grayTextColor];
    self.titleLabel.font = [UIFont fontForTableViewTextLabel];

    [self addSubview:self.titleLabel];
}

- (void)setupDetailLabel {
    self.detailLabel = [[UILabel alloc] init];
    self.detailLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.detailLabel.numberOfLines = 1;
    self.detailLabel.textColor = [UIColor grayTextColor];
    self.detailLabel.font = [UIFont fontForTableViewDetailLabel];

    [self addSubview:self.detailLabel];
}

- (void)setupButtons {
    self.buttonsContainer = [[UIView alloc] init];
    self.buttonsContainer.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:self.buttonsContainer];

    UIButton *addTenButton = [UIButton buttonWithType:UIButtonTypeSystem];
    addTenButton.translatesAutoresizingMaskIntoConstraints = NO;
    addTenButton.titleLabel.font = [UIFont fontForModalTaskTimeButtons];
    [addTenButton setTitle:NSLocalizedString(@"+ 10 Minutes", nil) forState:UIControlStateNormal];
    addTenButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [addTenButton addTarget:self action:@selector(addTenMinutesButtonWasTapped:) forControlEvents:UIControlEventTouchUpInside];

    UIButton *addHourButton = [UIButton buttonWithType:UIButtonTypeSystem];
    addHourButton.translatesAutoresizingMaskIntoConstraints = NO;
    addHourButton.titleLabel.font = [UIFont fontForModalTaskTimeButtons];
    [addHourButton setTitle:NSLocalizedString(@"+ 1 Hour", nil) forState:UIControlStateNormal];
    addHourButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [addHourButton addTarget:self action:@selector(addOneHourButtonWasTapped:) forControlEvents:UIControlEventTouchUpInside];

    UIButton *addDayButton = [UIButton buttonWithType:UIButtonTypeSystem];
    addDayButton.translatesAutoresizingMaskIntoConstraints = NO;
    addDayButton.titleLabel.font = [UIFont fontForModalTaskTimeButtons];
    [addDayButton setTitle:NSLocalizedString(@"+ 1 Day", nil) forState:UIControlStateNormal];
    addDayButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [addDayButton addTarget:self action:@selector(addOneDayButtonWasTapped:) forControlEvents:UIControlEventTouchUpInside];

    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeSystem];
    doneButton.translatesAutoresizingMaskIntoConstraints = NO;
    [doneButton setTitle:NSLocalizedString(@"Notification Task Done", nil) forState:UIControlStateNormal];
    doneButton.titleLabel.font = [UIFont fontForModalTaskDoneButton];
    doneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [doneButton addTarget:self action:@selector(doneButtonWasTapped:) forControlEvents:UIControlEventTouchUpInside];

    [self.buttonsContainer addSubview:addTenButton];
    [self.buttonsContainer addSubview:addHourButton];
    [self.buttonsContainer addSubview:addDayButton];
    [self.buttonsContainer addSubview:doneButton];

    UIView *spacerView1 = [[UIView alloc] init];
    spacerView1.translatesAutoresizingMaskIntoConstraints = NO;
    UIView *spacerView2 = [[UIView alloc] init];
    spacerView2.translatesAutoresizingMaskIntoConstraints = NO;
    UIView *spacerView3 = [[UIView alloc] init];
    spacerView3.translatesAutoresizingMaskIntoConstraints = NO;

    [self.buttonsContainer addSubview:spacerView1];
    [self.buttonsContainer addSubview:spacerView2];
    [self.buttonsContainer addSubview:spacerView3];

    [addTenButton leadingConstraintMatchesSuperview];
    [self.buttonsContainer addConstraint:[addTenButton.trailingAnchor constraintEqualToAnchor:spacerView1.leadingAnchor]];
    [self.buttonsContainer addConstraint:[addHourButton.leadingAnchor constraintEqualToAnchor:spacerView1.trailingAnchor]];
    [self.buttonsContainer addConstraint:[addHourButton.trailingAnchor constraintEqualToAnchor:spacerView2.leadingAnchor]];
    [self.buttonsContainer addConstraint:[addDayButton.leadingAnchor constraintEqualToAnchor:spacerView2.trailingAnchor]];
    [self.buttonsContainer addConstraint:[addDayButton.trailingAnchor constraintEqualToAnchor:spacerView3.leadingAnchor]];
    [self.buttonsContainer addConstraint:[doneButton.leadingAnchor constraintEqualToAnchor:spacerView3.trailingAnchor]];
    [doneButton trailingConstraintMatchesSuperview];

    [self.buttonsContainer addConstraint:[spacerView1.widthAnchor constraintEqualToAnchor:spacerView2.widthAnchor]];
    [self.buttonsContainer addConstraint:[spacerView2.widthAnchor constraintEqualToAnchor:spacerView3.widthAnchor]];
    [self.buttonsContainer addConstraint:[spacerView1.widthAnchor constraintEqualToAnchor:spacerView3.widthAnchor]];

    [addTenButton verticalConstraintsMatchSuperview];
    [addDayButton verticalConstraintsMatchSuperview];
    [addHourButton verticalConstraintsMatchSuperview];
    [doneButton verticalConstraintsMatchSuperview];
}

- (void)setupConstraints {
    [self addConstraint:[self.titleLabel.topAnchor constraintEqualToAnchor:self.topAnchor constant:10.0]];
    [self addConstraint:[self.titleLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:20.0]];
    [self addConstraint:[self.titleLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-20.0]];

    [self addConstraint:[self.detailLabel.topAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor constant:2.0]];
    [self addConstraint:[self.detailLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:20.0]];
    [self addConstraint:[self.detailLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-20.0]];

    [self addConstraint:[self.buttonsContainer.topAnchor constraintEqualToAnchor:self.detailLabel.bottomAnchor constant:8.0]];
    [self addConstraint:[self.buttonsContainer.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-10.0]];

    [self addConstraint:[self.buttonsContainer.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:20.0]];
    [self addConstraint:[self.buttonsContainer.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-20.0]];
}

- (void)addTenMinutesButtonWasTapped:(id)sender {
    [self.notificationTaskViewDelegate addTenMinutesButtonWasTappedWithView:self];
}

- (void)addOneHourButtonWasTapped:(id)sender {
    [self.notificationTaskViewDelegate addOneHourButtonWasTappedWithView:self];
}

- (void)addOneDayButtonWasTapped:(id)sender {
    [self.notificationTaskViewDelegate addOneDayButtonWasTappedWithView:self];
}

- (void)doneButtonWasTapped:(id)sender {
    [self.notificationTaskViewDelegate doneButtonWasTappedWithView:self];
}

@end
