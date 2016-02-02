//
//  MRNotificationTaskTableViewCell.m
//  Tackle
//
//  Created by Scott Bader on 1/30/16.
//  Copyright © 2016 Melody Road. All rights reserved.
//

#import "MRNotificationTaskTableViewCell.h"

@interface MRNotificationTaskTableViewCell()

@property (nonatomic) UIView *addTimeButtonsContainer;
@property (nonatomic) UIView *doneButtonContainer;

@end

@implementation MRNotificationTaskTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];

    if (self) {
        self.layoutMargins = UIEdgeInsetsZero;
        self.preservesSuperviewLayoutMargins = NO;

        self.textLabel.numberOfLines = 0;
        self.textLabel.lineBreakMode = NSLineBreakByWordWrapping;

        self.detailTextLabel.numberOfLines = 1;

        self.backgroundColor = [UIColor offWhiteBackgroundColor];

        self.textLabel.textColor = [UIColor grayTextColor];
        self.textLabel.font = [UIFont fontForTableViewTextLabel];

        self.detailTextLabel.textColor = [UIColor grayTextColor];
        self.detailTextLabel.font = [UIFont fontForTableViewDetailLabel];

        [self setupButtonsContainer];
//        [self setupDoneButtonContainer];
        [self setupConstraints];
    }

    return self;
}

- (void)setupButtonsContainer {
    self.addTimeButtonsContainer = [[UIView alloc] init];
    self.addTimeButtonsContainer.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.addTimeButtonsContainer];
    [self.addTimeButtonsContainer leadingConstraintMatchesSuperviewWithConstant:20.0];
    [self.addTimeButtonsContainer trailingConstraintMatchesSuperviewWithConstant:-20.0];

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

- (void)setupDoneButtonContainer {
    self.doneButtonContainer = [[UIView alloc] init];
    self.doneButtonContainer.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.doneButtonContainer];
//    [self.doneButtonContainer trailingConstraintMatchesSuperview];


    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeSystem];
    doneButton.translatesAutoresizingMaskIntoConstraints = NO;
    [doneButton setTitle:NSLocalizedString(@"Notification Task Done", nil) forState:UIControlStateNormal];
    doneButton.titleLabel.font = [UIFont fontForModalDoneButton];
    doneButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [doneButton addTarget:self action:@selector(doneButtonWasTapped:) forControlEvents:UIControlEventTouchUpInside];

    [self.doneButtonContainer addSubview:doneButton];
    [doneButton constraintsMatchSuperview];
}

- (void)setupConstraints {
    self.textLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.detailTextLabel.translatesAutoresizingMaskIntoConstraints = NO;

    [self.textLabel leadingConstraintMatchesView:self.contentView withConstant:20.0];
    [self.textLabel trailingConstraintMatchesView:self.contentView withConstant:-20.0];
//    [self.contentView addConstraint:[self.textLabel.trailingAnchor constraintEqualToAnchor:self.doneButtonContainer.leadingAnchor constant:-20.0]];
//    [self.doneButtonContainer staticWidthConstraint:48.0];
//    [self.doneButtonContainer trailingConstraintMatchesSuperviewWithConstant:-20.0];
    [self.detailTextLabel trailingConstraintMatchesView:self.textLabel];
    [self.detailTextLabel leadingConstraintMatchesView:self.contentView withConstant:20.0];
//    [self.detailTextLabel trailingConstraintMatchesView:self.contentView withConstant:-20.0];
    [self.textLabel topConstraintMatchesView:self.contentView withConstant:10.0];

    [self.detailTextLabel addConstraintEqualToView:self.textLabel
                                       inContainer:self.contentView
                                     withAttribute:NSLayoutAttributeTop
                                  relatedAttribute:NSLayoutAttributeBottom
                                        multiplier:1.0
                                          constant:2.0];

//    [self.detailTextLabel bottomConstraintMatchesView:self.contentView withConstant:-14.0];

//    [self.doneButtonContainer topConstraintMatchesView:self.textLabel withConstant:0.0];
//    [self.addTimeButtonsContainer topConstraintBelowView:self.detailTextLabel withConstant:8.0];
    [self.contentView addConstraint:[self.addTimeButtonsContainer.topAnchor constraintEqualToAnchor:self.detailTextLabel.bottomAnchor constant:8.0]];

    [self.contentView addConstraint:[self.addTimeButtonsContainer.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-10.0]];
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
