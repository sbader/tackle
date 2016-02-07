//
//  MRTaskNotificationTableViewCell.m
//  Tackle
//
//  Created by Scott Bader on 2/6/16.
//  Copyright © 2016 Melody Road. All rights reserved.
//

#import "MRTaskNotificationTableViewCell.h"

@interface MRTaskNotificationTableViewCell()

@property (nonatomic) UIView *addTimeButtonsContainer;
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UILabel *detailLabel;

@end

@implementation MRTaskNotificationTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];

    if (self) {
        self.layoutMargins = UIEdgeInsetsZero;
        self.preservesSuperviewLayoutMargins = NO;

        self.backgroundColor = [UIColor clearColor];

        [self setupTitleLabel];
        [self setupDetailLabel];
        [self setupButtonsContainer];
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

    [self.contentView addSubview:self.titleLabel];
}

- (void)setupDetailLabel {
    self.detailLabel = [[UILabel alloc] init];
    self.detailLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.detailLabel.numberOfLines = 1;
    self.detailLabel.textColor = [UIColor grayTextColor];
    self.detailLabel.font = [UIFont fontForTableViewDetailLabel];

    [self.contentView addSubview:self.detailLabel];
}

- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
}

- (void)setDetail:(NSString *)detail {
    self.detailLabel.text = detail;
}

- (void)setupButtonsContainer {
    self.addTimeButtonsContainer = [[UIView alloc] init];
    self.addTimeButtonsContainer.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.addTimeButtonsContainer];

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

    [self.addTimeButtonsContainer addSubview:addTenButton];
    [self.addTimeButtonsContainer addSubview:addHourButton];
    [self.addTimeButtonsContainer addSubview:addDayButton];
    [self.addTimeButtonsContainer addSubview:doneButton];

    UIView *spacerView1 = [[UIView alloc] init];
    spacerView1.translatesAutoresizingMaskIntoConstraints = NO;
    UIView *spacerView2 = [[UIView alloc] init];
    spacerView2.translatesAutoresizingMaskIntoConstraints = NO;
    UIView *spacerView3 = [[UIView alloc] init];
    spacerView3.translatesAutoresizingMaskIntoConstraints = NO;

    [self.addTimeButtonsContainer addSubview:spacerView1];
    [self.addTimeButtonsContainer addSubview:spacerView2];
    [self.addTimeButtonsContainer addSubview:spacerView3];

    [addTenButton leadingConstraintMatchesSuperview];
    [self.addTimeButtonsContainer addConstraint:[addTenButton.trailingAnchor constraintEqualToAnchor:spacerView1.leadingAnchor]];
    [self.addTimeButtonsContainer addConstraint:[addHourButton.leadingAnchor constraintEqualToAnchor:spacerView1.trailingAnchor]];
    [self.addTimeButtonsContainer addConstraint:[addHourButton.trailingAnchor constraintEqualToAnchor:spacerView2.leadingAnchor]];
    [self.addTimeButtonsContainer addConstraint:[addDayButton.leadingAnchor constraintEqualToAnchor:spacerView2.trailingAnchor]];
    [self.addTimeButtonsContainer addConstraint:[addDayButton.trailingAnchor constraintEqualToAnchor:spacerView3.leadingAnchor]];
    [self.addTimeButtonsContainer addConstraint:[doneButton.leadingAnchor constraintEqualToAnchor:spacerView3.trailingAnchor]];
    [doneButton trailingConstraintMatchesSuperview];

    [self.addTimeButtonsContainer addConstraint:[spacerView1.widthAnchor constraintEqualToAnchor:spacerView2.widthAnchor]];
    [self.addTimeButtonsContainer addConstraint:[spacerView2.widthAnchor constraintEqualToAnchor:spacerView3.widthAnchor]];
    [self.addTimeButtonsContainer addConstraint:[spacerView1.widthAnchor constraintEqualToAnchor:spacerView3.widthAnchor]];

    [addTenButton verticalConstraintsMatchSuperview];
    [addDayButton verticalConstraintsMatchSuperview];
    [addHourButton verticalConstraintsMatchSuperview];
    [doneButton verticalConstraintsMatchSuperview];
}

- (void)setupConstraints {
    [self.contentView addConstraint:[self.titleLabel.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:12.0]];
    [self.contentView addConstraint:[self.titleLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:15.0]];
    [self.contentView addConstraint:[self.titleLabel.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-15.0]];

    [self.contentView addConstraint:[self.detailLabel.topAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor constant:4.0]];
    [self.contentView addConstraint:[self.detailLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:15.0]];
    [self.contentView addConstraint:[self.detailLabel.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-15.0]];

    [self.contentView addConstraint:[self.addTimeButtonsContainer.topAnchor constraintEqualToAnchor:self.detailLabel.bottomAnchor constant:8.0]];
    [self.contentView addConstraint:[self.addTimeButtonsContainer.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-12.0]];

    [self.contentView addConstraint:[self.addTimeButtonsContainer.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:15.0]];
    [self.contentView addConstraint:[self.addTimeButtonsContainer.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-15.0]];
}

#pragma mark: Handlers

- (void)addTenMinutesButtonWasTapped:(id)sender {
    [self.taskCellDelegate addTenMinutesButtonWasTappedWithCell:self];
}

- (void)addOneHourButtonWasTapped:(id)sender {
    [self.taskCellDelegate addOneHourButtonWasTappedWithCell:self];
}

- (void)addOneDayButtonWasTapped:(id)sender {
    [self.taskCellDelegate addOneDayButtonWasTappedWithCell:self];
}

- (void)doneButtonWasTapped:(id)sender {
    [self.taskCellDelegate doneButtonWasTappedWithCell:self];
}

@end
