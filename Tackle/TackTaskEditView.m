//
//  TackTaskEditView.m
//  Tackle
//
//  Created by Scott Bader on 1/25/14.
//  Copyright (c) 2014 Melody Road. All rights reserved.
//

#import "TackTaskEditView.h"

#import "TackDateFormatter.h"

@interface TackTaskEditView ()

@property (nonatomic) BOOL isDatePickerShown;

@end

@implementation TackTaskEditView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:UIColorFromRGB(0xDADADC)];

        self.dueDate = [NSDate dateWithTimeIntervalSinceNow:600];

        [self setupTextField];
        [self setupDueDateButton];
        [self setupBottomButtonView];
        [self setupDatePicker];
        [self updateDueDate];

        [self addObservers];
    }
    return self;
}

- (void)addObservers
{
    [self addObserver:self forKeyPath:@"dueDate" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeObservers
{
    [self removeObserver:self forKeyPath:@"dueDate"];
}

- (void)setupTextField
{
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 50.0f)];
    [self.textField setTextAlignment:NSTextAlignmentCenter];
    [self.textField setPlaceholder:@"What do you want to tackle?"];
    [self.textField setFont:[UIFont adonisRegularWithSize:20.0f]];
    [self.textField setBackgroundColor:UIColorFromRGB(0xEBEBEB)];
    [self.textField setTintColor:UIColorFromRGB(0xA37BB9)];

    self.textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 50.0f)];
    [self.textField setLeftViewMode:UITextFieldViewModeAlways];

    self.textField.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 50.0f)];
    [self.textField setRightViewMode:UITextFieldViewModeAlways];

    UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 50.0f, self.frame.size.width, 1.0f)];
    [separatorView setBackgroundColor:UIColorFromRGB(0xCACACA)];

    [self addSubview:self.textField];
    [self addSubview:separatorView];
}

- (void)setupDueDateButton
{
    self.dueDateButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 51.0f, self.frame.size.width, 56.0f)];
    [self.dueDateButton setTitleColor:UIColorFromRGB(0x7091BC) forState:UIControlStateNormal];
    [self.dueDateButton.titleLabel setFont:[UIFont adonisRegularWithSize:23.0f]];
    [self.dueDateButton addTarget:self action:@selector(displayDatePicker:) forControlEvents:UIControlEventTouchUpInside];

    UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 107.0f, self.frame.size.width, 1.0f)];
    [separatorView setBackgroundColor:UIColorFromRGB(0xCACACA)];

    [self addSubview:self.dueDateButton];
    [self addSubview:separatorView];
}

- (void)setupBottomButtonView
{
    self.bottomButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 108, self.frame.size.width, 59.0f)];

    [self setupAddTenMinutesButton];
    [self setupAddOneHourButton];
    [self setupAddOneDayButton];
    [self setupSubmitButton];

    [self addSubview:self.bottomButtonView];
}

- (void)setupDatePicker
{
    self.isDatePickerShown = NO;

    self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 108.0f, self.frame.size.width, 120.0f)];
    [self.datePicker setHidden:YES];
    [self.datePicker addTarget:self action:@selector(datePickerChanged:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.datePicker];
}

- (void)setupAddTenMinutesButton
{
    self.addTenMinutesButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 109.0f, 59.0f)];
    [self.addTenMinutesButton setTitle:@"+ 10 Minutes" forState:UIControlStateNormal];
    [self.addTenMinutesButton setTitleColor:UIColorFromRGB(0x7091BC) forState:UIControlStateNormal];
    [self.addTenMinutesButton.titleLabel setFont:[UIFont adonisRegularWithSize:15.5f]];

    [self.addTenMinutesButton addTarget:self action:@selector(handleAddTenMinutes:) forControlEvents:UIControlEventTouchUpInside];

    UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(108, 0, 1.0f, 57.0f)];
    [separatorView setBackgroundColor:UIColorFromRGB(0xCACACA)];

    [self.bottomButtonView addSubview:self.addTenMinutesButton];
    [self.bottomButtonView addSubview:separatorView];
}

- (void)setupAddOneHourButton
{
    self.addOneHourButton = [[UIButton alloc] initWithFrame:CGRectMake(109.0f, 0, 79.0f, 59.0f)];
    [self.addOneHourButton setTitle:@"+ 1 Hour" forState:UIControlStateNormal];
    [self.addOneHourButton setTitleColor:UIColorFromRGB(0x7091BC) forState:UIControlStateNormal];
    [self.addOneHourButton.titleLabel setFont:[UIFont adonisRegularWithSize:15.5f]];

    [self.addOneHourButton addTarget:self action:@selector(handleAddOneHour:) forControlEvents:UIControlEventTouchUpInside];

    UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(187.0f, 0, 1.0f, 57.0f)];
    [separatorView setBackgroundColor:UIColorFromRGB(0xCACACA)];

    [self.bottomButtonView addSubview:self.addOneHourButton];
    [self.bottomButtonView addSubview:separatorView];
}

- (void)setupAddOneDayButton
{
    self.addOneDayButton = [[UIButton alloc] initWithFrame:CGRectMake(188.0f, 0, 72.0f, 59.0f)];
    [self.addOneDayButton setTitle:@"+ 1 Day" forState:UIControlStateNormal];
    [self.addOneDayButton setTitleColor:UIColorFromRGB(0x7091BC) forState:UIControlStateNormal];
    [self.addOneDayButton.titleLabel setFont:[UIFont adonisRegularWithSize:15.5f]];

    [self.addOneDayButton addTarget:self action:@selector(handleAddOneDay:) forControlEvents:UIControlEventTouchUpInside];

    UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(259.0f, 0, 1.0f, 57.0f)];
    [separatorView setBackgroundColor:UIColorFromRGB(0xCACACA)];

    [self.bottomButtonView addSubview:self.addOneDayButton];
    [self.bottomButtonView addSubview:separatorView];
}

- (void)setupSubmitButton
{
    self.submitButton = [[UIButton alloc] initWithFrame:CGRectMake(260.0f, 0, 61.0f, 59.0f)];
    [self.submitButton setTitle:@"Go" forState:UIControlStateNormal];
    [self.submitButton setTitleColor:UIColorFromRGB(0x2E67B3) forState:UIControlStateNormal];
    [self.submitButton.titleLabel setFont:[UIFont adonisRegularWithSize:29.5f]];
    [self.submitButton addTarget:self action:@selector(handleSubmit:) forControlEvents:UIControlEventTouchUpInside];

    UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bottomButtonView.frame.size.height - 2, self.bottomButtonView.frame.size.width, 1.0f)];
    [separatorView setBackgroundColor:UIColorFromRGB(0xCACACA)];

    [self.bottomButtonView addSubview:self.submitButton];
    [self.bottomButtonView addSubview:separatorView];
}

- (void)handleSubmit:(id)sender
{
    [self.textField resignFirstResponder];
    [self.delegate taskEditViewDidReturnWithText:self.textField.text dueDate:self.dueDate];
    [self resetContent];
}

- (void)handleAddTenMinutes:(id)sender
{
    [self setDueDate:[NSDate dateWithTimeInterval:600 sinceDate:self.dueDate]];
}

- (void)handleAddOneHour:(id)sender
{
    [self setDueDate:[NSDate dateWithTimeInterval:3600 sinceDate:self.dueDate]];
}

- (void)handleAddOneDay:(id)sender
{
    [self setDueDate:[NSDate dateWithTimeInterval:86400 sinceDate:self.dueDate]];
}

- (void)displayDatePicker:(id)sender
{
    CGRect mainFrame = self.frame;
    CGRect bottomButtonViewFrame = self.bottomButtonView.frame;

    if (self.isDatePickerShown) {
        mainFrame.size.height = mainFrame.size.height - 216;
        bottomButtonViewFrame.origin.y = bottomButtonViewFrame.origin.y - 216;

        [self.datePicker setHidden:YES];
        self.isDatePickerShown = NO;

        [UIView animateWithDuration:0.2 animations:^{
            [self.bottomButtonView setFrame:bottomButtonViewFrame];
            [self setFrame:mainFrame];
        }];

    }
    else {
        if (self.textField.isFirstResponder) {
            [self.textField resignFirstResponder];
        }

        mainFrame.size.height = mainFrame.size.height + 216;
        bottomButtonViewFrame.origin.y = bottomButtonViewFrame.origin.y + 216;

        [UIView animateWithDuration:0.2 animations:^{
            [self setFrame:mainFrame];
            [self.bottomButtonView setFrame:bottomButtonViewFrame];
        } completion:^(BOOL finished) {
            [self.datePicker setHidden:NO];
            self.isDatePickerShown = YES;
        }];
    }
}

- (void)datePickerChanged:(id)sender
{
    self.dueDate = self.datePicker.date;
    [self updateDueDate];
}

- (void)updateDueDate
{
    [self.dueDateButton setTitle:[[TackDateFormatter sharedInstance] stringFromDate:self.dueDate] forState:UIControlStateNormal];
    [self.datePicker setDate:self.dueDate];
}

- (void)resetContent
{
    [self setDueDate:[NSDate dateWithTimeIntervalSinceNow:600]];
    [self.textField setText:@""];
    if (self.isDatePickerShown) {
        CGRect mainFrame = self.frame;
        CGRect bottomButtonViewFrame = self.bottomButtonView.frame;

        mainFrame.size.height = mainFrame.size.height - 216;
        bottomButtonViewFrame.origin.y = bottomButtonViewFrame.origin.y - 216;

        [self.datePicker setHidden:YES];
        self.isDatePickerShown = NO;
        [self.bottomButtonView setFrame:bottomButtonViewFrame];
        [self setFrame:mainFrame];
    }
}

#pragma mark - NSKeyValueObserving

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"dueDate"]) {
        [self updateDueDate];
    }
}

@end
