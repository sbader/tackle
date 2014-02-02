//
//  TackTaskEditView.m
//  Tackle
//
//  Created by Scott Bader on 1/25/14.
//  Copyright (c) 2014 Melody Road. All rights reserved.
//

#import "TackTaskEditView.h"

#import "TackDateFormatter.h"

@implementation TackTaskEditView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:UIColorFromRGB(0xDADADC)];

        self.dueDate = [NSDate dateWithTimeIntervalSinceNow:600];

        [self setupTextField];
        [self setupDueDateButton];
        [self setupAddTenMinutesButton];
        [self setupAddOneHourButton];
        [self setupAddOneDayButton];
        [self setupSubmitButton];

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
    [self updateDueDate];

    UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 107.0f, self.frame.size.width, 1.0f)];
    [separatorView setBackgroundColor:UIColorFromRGB(0xCACACA)];

    [self addSubview:self.dueDateButton];
    [self addSubview:separatorView];
}

- (void)setupAddTenMinutesButton
{
    self.addTenMinutesButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 108.0f, 109.0f, 59.0f)];
    [self.addTenMinutesButton setTitle:@"+ 10 Minutes" forState:UIControlStateNormal];
    [self.addTenMinutesButton setTitleColor:UIColorFromRGB(0x7091BC) forState:UIControlStateNormal];
    [self.addTenMinutesButton.titleLabel setFont:[UIFont adonisRegularWithSize:15.5f]];

    [self.addTenMinutesButton addTarget:self action:@selector(handleAddTenMinutes:) forControlEvents:UIControlEventTouchUpInside];

    UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(108.0f, 108.0f, 1.0f, 57.0f)];
    [separatorView setBackgroundColor:UIColorFromRGB(0xCACACA)];

    [self addSubview:self.addTenMinutesButton];
    [self addSubview:separatorView];
}

- (void)setupAddOneHourButton
{
    self.addOneHourButton = [[UIButton alloc] initWithFrame:CGRectMake(109.0f, 108.0f, 79.0f, 59.0f)];
    [self.addOneHourButton setTitle:@"+ 1 Hour" forState:UIControlStateNormal];
    [self.addOneHourButton setTitleColor:UIColorFromRGB(0x7091BC) forState:UIControlStateNormal];
    [self.addOneHourButton.titleLabel setFont:[UIFont adonisRegularWithSize:15.5f]];

    [self.addOneHourButton addTarget:self action:@selector(handleAddOneHour:) forControlEvents:UIControlEventTouchUpInside];

    UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(187.0f, 108.0f, 1.0f, 57.0f)];
    [separatorView setBackgroundColor:UIColorFromRGB(0xCACACA)];

    [self addSubview:self.addOneHourButton];
    [self addSubview:separatorView];
}

- (void)setupAddOneDayButton
{
    self.addOneDayButton = [[UIButton alloc] initWithFrame:CGRectMake(188.0f, 108.0f, 72.0f, 59.0f)];
    [self.addOneDayButton setTitle:@"+ 1 Day" forState:UIControlStateNormal];
    [self.addOneDayButton setTitleColor:UIColorFromRGB(0x7091BC) forState:UIControlStateNormal];
    [self.addOneDayButton.titleLabel setFont:[UIFont adonisRegularWithSize:15.5f]];

    [self.addOneDayButton addTarget:self action:@selector(handleAddOneDay:) forControlEvents:UIControlEventTouchUpInside];

    UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(259.0f, 108.0f, 1.0f, 57.0f)];
    [separatorView setBackgroundColor:UIColorFromRGB(0xCACACA)];

    [self addSubview:self.addOneDayButton];
    [self addSubview:separatorView];
}

- (void)setupSubmitButton
{
    self.submitButton = [[UIButton alloc] initWithFrame:CGRectMake(260.0f, 108.0f, 61.0f, 59.0f)];
    [self.submitButton setTitle:@"Go" forState:UIControlStateNormal];
    [self.submitButton setTitleColor:UIColorFromRGB(0x2E67B3) forState:UIControlStateNormal];
    [self.submitButton.titleLabel setFont:[UIFont adonisRegularWithSize:29.5f]];
    [self.submitButton addTarget:self action:@selector(handleSubmit:) forControlEvents:UIControlEventTouchUpInside];

    UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 1, self.frame.size.width, 1.0f)];
    [separatorView setBackgroundColor:UIColorFromRGB(0xCACACA)];

    [self addSubview:self.submitButton];
    [self addSubview:separatorView];
}

- (void)handleSubmit:(id)sender
{
    [self.textField resignFirstResponder];
    [self.delegate taskEditViewDidReturnWithText:self.textField.text dueDate:[NSDate dateWithTimeIntervalSinceNow:600]];
    [self.textField setText:@""];
    [self setDueDate:[NSDate dateWithTimeIntervalSinceNow:600]];
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

- (void)updateDueDate
{
    [self.dueDateButton setTitle:[[TackDateFormatter sharedInstance] stringFromDate:self.dueDate] forState:UIControlStateNormal];
}

#pragma mark - NSKeyValueObserving

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"dueDate"]) {
        [self updateDueDate];
    }
}

@end
