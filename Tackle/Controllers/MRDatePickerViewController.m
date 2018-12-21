//
//  MRDatePickerViewController.m
//  Tackle
//
//  Created by Scott Bader on 12/30/14.
//  Copyright (c) 2014 Melody Road. All rights reserved.
//

#import "MRDatePickerViewController.h"

#import "MRDatePickerProvider.h"

@interface MRDatePickerViewController ()

@property (nonatomic) UIDatePicker *datePicker;
@property (nonatomic) UIView *datePickerContainer;
@property (nonatomic) UILabel *label;
@property (nonatomic) UIView *buttonContainer;
@property (nonatomic) NSDate *date;
@property (nonatomic) NSDate *selectedDate;
@property (nonatomic) UIView *contentView;

@end

@implementation MRDatePickerViewController

- (instancetype)initWithDate:(NSDate *)date {
    self = [super init];

    if (self) {
        self.date = date;
        self.selectedDate = [date copy];
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.datePickerContainer = [[UIView alloc] init];
    self.datePickerContainer.backgroundColor = [UIColor offWhiteBackgroundColor];
    self.datePickerContainer.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.datePickerContainer];

    [self.datePickerContainer leadingConstraintMatchesSuperview];
    [self.datePickerContainer trailingConstraintMatchesSuperview];

    [self.datePickerContainer applyTackleLayerDisplay];

    [self.view addConstraint:[self.datePickerContainer.topAnchor
                              constraintLessThanOrEqualToAnchor:self.view.topAnchor
                              constant:10.0]];

    [self.datePickerContainer addConstraint:[self.datePickerContainer.heightAnchor constraintGreaterThanOrEqualToConstant:120.0]];
    [self.datePickerContainer addConstraint:[self.datePickerContainer.heightAnchor constraintLessThanOrEqualToConstant:180.0]];

    [self setupDatePicker];

    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    closeButton.translatesAutoresizingMaskIntoConstraints = NO;
    closeButton.titleLabel.font = [UIFont fontForModalButton];
    closeButton.tintColor = [UIColor destructiveColor];
    closeButton.contentEdgeInsets = UIEdgeInsetsMake(15.0, 0.0, 15.0, 0.0);
    closeButton.backgroundColor = [UIColor offWhiteBackgroundColor];
    [closeButton setTitle:NSLocalizedString(@"Date Picker Close Title", nil) forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(handleCloseButton:) forControlEvents:UIControlEventTouchUpInside];
    [closeButton setBackgroundImage:[UIImage imageWithColor:[UIColor offWhiteBackgroundColor]] forState:UIControlStateNormal];
    [closeButton setBackgroundImage:[UIImage imageWithColor:[UIColor darkenedOffWhiteBackgroundColor]] forState:UIControlStateHighlighted];
    [closeButton applyTackleLayerDisplay];
    [self.view addSubview:closeButton];

    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeSystem];
    saveButton.translatesAutoresizingMaskIntoConstraints = NO;
    saveButton.titleLabel.font = [UIFont fontForModalButton];
    saveButton.contentEdgeInsets = UIEdgeInsetsMake(15.0, 0.0, 15.0, 0.0);
    saveButton.backgroundColor = [UIColor offWhiteBackgroundColor];
    [saveButton setTitle:NSLocalizedString(@"Date Picker Save Title", nil) forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(handleSaveButton:) forControlEvents:UIControlEventTouchUpInside];
    [saveButton setBackgroundImage:[UIImage imageWithColor:[UIColor offWhiteBackgroundColor]] forState:UIControlStateNormal];
    [saveButton setBackgroundImage:[UIImage imageWithColor:[UIColor darkenedOffWhiteBackgroundColor]] forState:UIControlStateHighlighted];
    [saveButton applyTackleLayerDisplay];

    [self.view addSubview:saveButton];

    [saveButton topConstraintBelowView:self.datePickerContainer withConstant:8.0];
    [saveButton leadingConstraintMatchesSuperview];
    [saveButton trailingConstraintMatchesSuperview];

    [closeButton leadingConstraintMatchesSuperview];
    [closeButton trailingConstraintMatchesSuperview];
    [closeButton topConstraintBelowView:saveButton withConstant:8.0];
    [closeButton bottomConstraintMatchesSuperview];
}

- (void)setupDatePicker {
    self.datePicker = [[UIDatePicker alloc] init];
    self.datePicker.translatesAutoresizingMaskIntoConstraints = NO;
    self.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    self.datePicker.minimumDate = [NSDate date];

    self.datePicker.minuteInterval = 5;
    [self.datePicker setDate:self.date animated:NO];
    [self.datePicker addTarget:self action:@selector(handleDatePickerValueChanged:) forControlEvents:UIControlEventValueChanged];

    [self.datePickerContainer addSubview:self.datePicker];

    UITapGestureRecognizer *intervalTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(intervalTapGestureWasTapped:)];
    intervalTapGestureRecognizer.numberOfTapsRequired = 2;
    [self.datePicker addGestureRecognizer:intervalTapGestureRecognizer];

    [self.datePicker horizontalCenterConstraintMatchesSuperview];
    [self.datePicker topConstraintMatchesSuperview];
    [self.datePicker bottomConstraintMatchesSuperview];
}

- (void)dismiss {
    [self mr_dismissViewControllerModallyAnimated:YES completion:nil];
}

#pragma mark - Handlers

- (IBAction)handleDatePickerValueChanged:(UIDatePicker *)datePicker {
    self.selectedDate = datePicker.date;
}

- (void)handleCloseButton:(id)sender {
    [self dismiss];
}

- (void)handleSaveButton:(id)sender {
    [self.delegate didSelectDate:self.selectedDate];
    [self dismiss];
}

- (void)intervalTapGestureWasTapped:(id)sender {
    self.datePicker.minuteInterval = (self.datePicker.minuteInterval == 5) ? 1 : 5;
}

@end
