//
//  MRDatePickerViewController.m
//  Tackle
//
//  Created by Scott Bader on 12/30/14.
//  Copyright (c) 2014 Melody Road. All rights reserved.
//

#import "MRDatePickerViewController.h"

@interface MRDatePickerViewController ()

@property (nonatomic) UIDatePicker *datePicker;
@property (nonatomic) UIView *datePickerContainer;
@property (nonatomic) UILabel *label;
@property (nonatomic) UIView *buttonContainer;
@property (nonatomic) NSDate *date;

@end

@implementation MRDatePickerViewController\

- (instancetype)initWithDate:(NSDate *)date {
    self = [super init];

    if (self) {
        self.date = date;
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor offWhiteBackgroundColor];

    [self setupLabel];
    [self setupButtons];
    [self setupDatePickerContainer];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self setupDatePicker];
}

- (void)setupLabel {
    self.label = [[UILabel alloc] init];
    self.label.translatesAutoresizingMaskIntoConstraints = NO;
    self.label.font = [UIFont fontForFormLabel];
    self.label.text = @"Select Due Date";

    [self.view addSubview:self.label];
    [self.label topConstraintMatchesSuperviewWithConstant:17.0];
    [self.label leadingConstraintMatchesSuperviewWithConstant:20.0];
    [self.label trailingConstraintMatchesSuperviewWithConstant:-20.0];
}

- (void)setupDatePickerContainer {
    self.datePickerContainer = [[UIView alloc] init];
    self.datePickerContainer.backgroundColor = [UIColor whiteColor];
    self.datePickerContainer.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.datePickerContainer];
    [self.datePickerContainer horizontalConstraintsMatchSuperview];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.datePickerContainer attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.label attribute:NSLayoutAttributeBottom multiplier:1.0 constant:17.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.buttonContainer attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.datePickerContainer attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];

    [self.datePickerContainer addConstraint:[NSLayoutConstraint constraintWithItem:self.datePickerContainer attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:215]];
}

- (void)setupDatePicker {
    self.datePicker = [[UIDatePicker alloc] init];
    self.datePicker.translatesAutoresizingMaskIntoConstraints = NO;
    self.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    self.datePicker.minimumDate = [NSDate date];
    self.datePicker.minuteInterval = 5;
    [self.datePicker setDate:self.date animated:NO];
    [self.datePickerContainer addSubview:self.datePicker];

    [self.datePicker constraintsMatchSuperview];
}

- (void)setupButtons {
    self.buttonContainer = [[UIView alloc] init];
    self.buttonContainer.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.buttonContainer];

    [self.buttonContainer staticHeightConstraint:59.0];
    [self.buttonContainer bottomConstraintMatchesSuperview];
    [self.buttonContainer horizontalConstraintsMatchSuperview];

    UIView *separator = [[UIView alloc] init];
    separator.translatesAutoresizingMaskIntoConstraints = NO;
    separator.backgroundColor = [UIColor grayBorderColor];
    [self.buttonContainer addSubview:separator];

    [separator horizontalCenterConstraintMatchesSuperview];
    [separator staticWidthConstraint:1.0];
    [separator topConstraintMatchesSuperviewWithConstant:5.0];
    [separator bottomConstraintMatchesSuperviewWithConstant:-5.0];

    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    closeButton.translatesAutoresizingMaskIntoConstraints = NO;
    closeButton.titleLabel.font = [UIFont fontForFormButtons];
    closeButton.tintColor = [UIColor destructiveColor];
    closeButton.contentEdgeInsets = UIEdgeInsetsMake(20.0, 0, 20.0, 0);
    [closeButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(handleCloseButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonContainer addSubview:closeButton];

    [closeButton verticalCenterConstraintMatchesSuperview];
    [closeButton leadingConstraintMatchesSuperview];
    [self.buttonContainer addConstraint:[NSLayoutConstraint constraintWithItem:closeButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:separator attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]];

    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeSystem];
    saveButton.translatesAutoresizingMaskIntoConstraints = NO;
    saveButton.titleLabel.font = [UIFont fontForFormButtons];
    saveButton.contentEdgeInsets = UIEdgeInsetsMake(20.0, 0, 20.0, 0);
    [saveButton setTitle:@"Save" forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(handleSaveButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonContainer addSubview:saveButton];

    [saveButton verticalCenterConstraintMatchesSuperview];
    [self.buttonContainer addConstraint:[NSLayoutConstraint constraintWithItem:saveButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:separator attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0]];
    [saveButton trailingConstraintMatchesSuperview];
}

- (void)dismiss {
    [self mr_dismissViewControllerModallyAnimated:YES completion:nil];
}

#pragma mark - Handlers

- (void)handleCloseButton:(id)sender {
    [self dismiss];
}

- (void)handleSaveButton:(id)sender {
    [self.delegate didSelectDate:self.datePicker.date];
    [self dismiss];
}

@end
