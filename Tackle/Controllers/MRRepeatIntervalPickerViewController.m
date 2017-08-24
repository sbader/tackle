//
//  MRRepeatIntervalPickerViewController.m
//  Tackle
//
//  Created by Scott Bader on 8/23/17.
//  Copyright © 2017 Melody Road. All rights reserved.
//

#import "MRRepeatIntervalPickerViewController.h"


@interface MRRepeatIntervalPickerViewController () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic) TaskRepeatInterval repeatInterval;
@property (nonatomic) UIPickerView *picker;
@property (nonatomic) UIView *pickerContainer;
@property (nonatomic) UILabel *label;
@property (nonatomic) UIView *buttonContainer;
@property (nonatomic) NSDate *date;
@property (nonatomic) UIView *contentView;

@end

@implementation MRRepeatIntervalPickerViewController

- (instancetype)initWithRepeatInterval:(TaskRepeatInterval)repeatInterval {
    self = [super init];
    
    if (self) {
        self.repeatInterval = repeatInterval;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pickerContainer = [[UIView alloc] init];
    self.pickerContainer.backgroundColor = [UIColor offWhiteBackgroundColor];
    self.pickerContainer.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.pickerContainer];
    
    [self.pickerContainer leadingConstraintMatchesSuperview];
    [self.pickerContainer trailingConstraintMatchesSuperview];
    
    [self.pickerContainer applyTackleLayerDisplay];
    
    [self.view addConstraint:[self.pickerContainer.topAnchor
                              constraintLessThanOrEqualToAnchor:self.view.topAnchor
                              constant:10.0]];
    
    [self.pickerContainer addConstraint:[self.pickerContainer.heightAnchor constraintGreaterThanOrEqualToConstant:120.0]];
    [self.pickerContainer addConstraint:[self.pickerContainer.heightAnchor constraintLessThanOrEqualToConstant:180.0]];
    
    [self setupPicker];
    
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

    [saveButton topConstraintBelowView:self.pickerContainer withConstant:8.0];
    [saveButton leadingConstraintMatchesSuperview];
    [saveButton trailingConstraintMatchesSuperview];

    [closeButton leadingConstraintMatchesSuperview];
    [closeButton trailingConstraintMatchesSuperview];
    [closeButton topConstraintBelowView:saveButton withConstant:8.0];
    [closeButton bottomConstraintMatchesSuperview];
}

- (void)dismiss {
    [self mr_dismissViewControllerModallyAnimated:YES completion:nil];
}

- (void)setupPicker {
    self.picker = [[UIPickerView alloc] init];
    self.picker.translatesAutoresizingMaskIntoConstraints = NO;
    self.picker.delegate = self;
    self.picker.dataSource = self;
    
    [self.pickerContainer addSubview:self.picker];
    
    [self setInitialValue];
    
    [self.picker horizontalCenterConstraintMatchesSuperview];
    [self.picker topConstraintMatchesSuperview];
    [self.picker bottomConstraintMatchesSuperview];
}

#pragma mark - Handlers

- (void)handleCloseButton:(id)sender {
    [self dismiss];
}

- (void)handleSaveButton:(id)sender {
    [self.delegate didSelectRepeatInterval:self.selectedRepeatInterval];
    [self dismiss];
}

- (TaskRepeatInterval)selectedRepeatInterval {
    NSInteger index = [self.picker selectedRowInComponent:0];
    
    switch (index) {
        case 0:
            return TaskRepeatIntervalNone;
            break;
        case 1:
            return TaskRepeatIntervalAllDays;
            break;
        case 2:
            return TaskRepeatIntervalWeekdays;
            break;
        default:
            return TaskRepeatIntervalWeekdays;
            break;
    }
}

- (void)setInitialValue {
    NSInteger index = 0;
    
    switch (self.repeatInterval) {
        case TaskRepeatIntervalNone:
            index = 0;
            break;
        case TaskRepeatIntervalAllDays:
            index = 1;
            break;
        case TaskRepeatIntervalWeekdays:
            index = 2;
            break;
        default:
            index = 2;
            break;
    }
    
    [self.picker selectRow:index inComponent:0 animated:false];
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(nonnull UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(nonnull UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 3;
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    switch (row) {
        case 0:
            return NSLocalizedString(@"Repeat Interval Disabled Title", nil);
            break;
        case 1:
            return NSLocalizedString(@"Repeat Interval All Days Title", nil);
            break;
        case 2:
            return NSLocalizedString(@"Repeat Interval Weekdays Title", nil);
            break;
        default:
            return NSLocalizedString(@"Repeat Interval Weekdays Title", nil);
            break;
    }
}


@end
