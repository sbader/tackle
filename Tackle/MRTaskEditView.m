//
//  MRTaskEditView.m
//  Tackle
//
//  Created by Scott Bader on 1/25/14.
//  Copyright (c) 2014 Melody Road. All rights reserved.
//

#import "MRTaskEditView.h"

#import "MRLongDateFormatter.h"
#import "MRHeartbeat.h"

@interface MRTaskEditView ()

@property (nonatomic, getter = isDatePickerShown) BOOL datePickerShown;
@property (nonatomic, getter = isIncrementing) BOOL incrementing;
@property (nonatomic) NSDate *startDate;
@property (nonatomic) NSDate *visibleDate;
@property (nonatomic) NSTimeInterval incrementer;
@property (nonatomic, strong) UIView *topAreaView;
@property (nonatomic, strong) UIView *bottomMaskView;

@end

@implementation MRTaskEditView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:UIColorFromRGB(0xDADADC)];

        self.startDate = [NSDate date];
        self.dueDate = [NSDate dateWithTimeInterval:600 sinceDate:self.startDate];

        self.visibleDate = self.dueDate;

        self.incrementing = NO;

        [self setupTopArea];
        [self setupTextField];
        [self setupDueDateButton];
        [self setupBottomButtonView];
        [self setupDatePicker];
        [self setupBottomMaskView];

        [self addObservers];
    }
    return self;
}

- (void)addObservers
{
//    [self addObserver:self forKeyPath:@"dueDate" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeObservers
{
//    [self removeObserver:self forKeyPath:@"dueDate"];
}

- (void)hideBottomMaskView
{
    [self.bottomMaskView setHidden:YES];
}

- (void)showBottomMaskView
{
    [self.bottomMaskView setHidden:NO];
}

- (void)setupBottomMaskView
{
    self.bottomMaskView = [[UIView alloc] initWithFrame:CGRectMake(0, 165.0f, self.frame.size.width, 20.0f)];
    [self.bottomMaskView setBackgroundColor:UIColorFromRGB(0xEBEBEB)];
    [self addSubview:self.bottomMaskView];
}

- (void)setupTopArea
{
    self.topAreaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 20.0f)];
    [self.topAreaView setBackgroundColor:UIColorFromRGB(0xEBEBEB)];
    [self addSubview:self.topAreaView];
}

- (void)setupTextField
{
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 20, self.frame.size.width, 50.0f)];
    [self.textField setTextAlignment:NSTextAlignmentCenter];
    [self.textField setPlaceholder:@"What do you want to tackle?"];
    [self.textField setFont:[UIFont effraRegularWithSize:20.0f]];
    [self.textField setBackgroundColor:UIColorFromRGB(0xEBEBEB)];
    [self.textField setTintColor:UIColorFromRGB(0xA37BB9)];

    self.textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, 5, 50.0f)];
    [self.textField setLeftViewMode:UITextFieldViewModeAlways];

    self.textField.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, 5, 50.0f)];
    [self.textField setRightViewMode:UITextFieldViewModeAlways];

    UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 70.0f, self.frame.size.width, 1.0f)];
    [separatorView setBackgroundColor:UIColorFromRGB(0xCACACA)];

    [self addSubview:self.textField];
    [self addSubview:separatorView];
}

- (void)setupDueDateButton
{
    self.dueDateButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 71.0f, self.frame.size.width, 56.0f)];
    [self.dueDateButton setTitleColor:UIColorFromRGB(0x7091BC) forState:UIControlStateNormal];
    [self.dueDateButton setTitleColor:UIColorFromRGB(0x82AADD) forState:UIControlStateHighlighted];
    [self.dueDateButton setTitleColor:UIColorFromRGB(0x82AADD) forState:UIControlStateSelected];
    [self.dueDateButton setTitle:[self.dueDate tackleStringSinceDate:self.startDate] forState:UIControlStateNormal];
    [self.dueDateButton.titleLabel setFont:[UIFont effraRegularWithSize:18.0f]];

    [self.dueDateButton addTarget:self action:@selector(toggleDatePicker:) forControlEvents:UIControlEventTouchUpInside];

    [self addSubview:self.dueDateButton];
}

- (void)setupBottomButtonView
{
    self.bottomButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 128, self.frame.size.width, 59.0f)];

    UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1.0f)];
    [separatorView setBackgroundColor:UIColorFromRGB(0xCACACA)];

    [self.bottomButtonView addSubview:separatorView];

    [self setupAddTenMinutesButton];
    [self setupAddOneHourButton];
    [self setupAddOneDayButton];
    [self setupSubmitButton];

    [self addSubview:self.bottomButtonView];
}

- (void)setupDatePicker
{
    self.datePickerShown = NO;

    UITapGestureRecognizer *doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    [doubleTapGestureRecognizer setNumberOfTapsRequired:2];

    self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 128.0f, self.frame.size.width, 120.0f)];
    [self.datePicker setHidden:YES];
    [self.datePicker addTarget:self action:@selector(datePickerChanged:) forControlEvents:UIControlEventValueChanged];
    [self.datePicker setDate:self.dueDate];
    [self.datePicker setMinuteInterval:5];
    [self.datePicker addGestureRecognizer:doubleTapGestureRecognizer];
    [self addSubview:self.datePicker];
}

- (void)setupAddTenMinutesButton
{
    self.addTenMinutesButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 109.0f, 59.0f)];
    [self.addTenMinutesButton setTitle:@"+ 10 Minutes" forState:UIControlStateNormal];
    [self.addTenMinutesButton setTitleColor:UIColorFromRGB(0x7091BC) forState:UIControlStateNormal];
    [self.addTenMinutesButton setTitleColor:UIColorFromRGB(0x82AADD) forState:UIControlStateHighlighted];
    [self.addTenMinutesButton setTitleColor:UIColorFromRGB(0x82AADD) forState:UIControlStateSelected];
    [self.addTenMinutesButton.titleLabel setFont:[UIFont effraRegularWithSize:15.5f]];

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
    [self.addOneHourButton setTitleColor:UIColorFromRGB(0x82AADD) forState:UIControlStateHighlighted];
    [self.addOneHourButton setTitleColor:UIColorFromRGB(0x82AADD) forState:UIControlStateSelected];
    [self.addOneHourButton.titleLabel setFont:[UIFont effraRegularWithSize:15.5f]];

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
    [self.addOneDayButton setTitleColor:UIColorFromRGB(0x82AADD) forState:UIControlStateHighlighted];
    [self.addOneDayButton setTitleColor:UIColorFromRGB(0x82AADD) forState:UIControlStateSelected];
    [self.addOneDayButton.titleLabel setFont:[UIFont effraRegularWithSize:15.5f]];

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
    [self.submitButton setTitleColor:UIColorFromRGB(0x82AADD) forState:UIControlStateHighlighted];
    [self.submitButton setTitleColor:UIColorFromRGB(0x82AADD) forState:UIControlStateSelected];

    [self.submitButton.titleLabel setFont:[UIFont effraRegularWithSize:29.5f]];
    [self.submitButton addTarget:self action:@selector(handleSubmit:) forControlEvents:UIControlEventTouchUpInside];

    [self.bottomButtonView addSubview:self.submitButton];
}

- (void)handleSubmit:(id)sender
{
    if ([self.textField.text length] == 0) {
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"] ;

        animation.values = @[
                        [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(-5.0f, 0.0f, 0.0f)],
                        [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(5.0f, 0.0f, 0.0f)]
                    ];

        animation.autoreverses = YES ;
        animation.repeatCount = 5.0f ;
        animation.duration = 0.05f ;

        [self.textField.layer addAnimation:animation forKey:nil] ;

        return;
    }

    [self.textField resignFirstResponder];
    [self.delegate taskEditViewDidReturnWithText:self.textField.text dueDate:self.dueDate];
}

- (void)handleAddTenMinutes:(id)sender
{
    [self setDueDate:[NSDate dateWithTimeInterval:600 sinceDate:self.dueDate] animated:YES];
}

- (void)handleAddOneHour:(id)sender
{
    [self setDueDate:[NSDate dateWithTimeInterval:3600 sinceDate:self.dueDate] animated:YES];
}

- (void)handleAddOneDay:(id)sender
{
    [self setDueDate:[NSDate dateWithTimeInterval:86400 sinceDate:self.dueDate] animated:YES];
}

- (void)handleDoubleTap:(id)sender
{
    if (self.datePicker.minuteInterval == 5) {
        [self.datePicker setMinuteInterval:1];
    }
    else {
        [self.datePicker setMinuteInterval:5];
    }
}

- (void)showDatePickerAnimated:(BOOL)animated
{
    CGRect mainFrame = self.frame;
    CGRect bottomButtonViewFrame = self.bottomButtonView.frame;

    if (self.textField.isFirstResponder) {
        [self.textField resignFirstResponder];
    }

    mainFrame.size.height = mainFrame.size.height + 216;
    bottomButtonViewFrame.origin.y = bottomButtonViewFrame.origin.y + 216;

    void (^setFrame)(void) = ^{
        [self setFrame:mainFrame];
        [self.bottomButtonView setFrame:bottomButtonViewFrame];
    };

    void (^showDatePicker)(void) = ^{
        [self.datePicker setHidden:NO];
    };

    void (^showDatePickerCompletion)(BOOL finished) = ^(BOOL finished) {
        self.datePickerShown = YES;
    };

    if (animated) {
        [UIView animateWithDuration:0.2 animations:setFrame completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:showDatePicker completion:showDatePickerCompletion];
        }];
    }
    else {
        setFrame();
        showDatePicker();
        showDatePickerCompletion(YES);
    }
}

- (void)hideDatePickerAnimated:(BOOL)animated
{
    CGRect mainFrame = self.frame;
    CGRect bottomButtonViewFrame = self.bottomButtonView.frame;

    mainFrame.size.height = mainFrame.size.height - 216;
    bottomButtonViewFrame.origin.y = bottomButtonViewFrame.origin.y - 216;
    self.datePickerShown = NO;

    void (^hideDatePicker)(void) = ^{
        [self.datePicker setHidden:YES];
        [self.bottomButtonView setFrame:bottomButtonViewFrame];
        [self setFrame:mainFrame];
    };

    if (animated) {
        [UIView animateWithDuration:0.2 animations:hideDatePicker];
    }
    else {
        hideDatePicker();
    }
}

- (void)toggleDatePicker:(id)sender
{
    if (self.isDatePickerShown) {
        [self hideDatePickerAnimated:YES];
    }
    else {
        [self showDatePickerAnimated:YES];
    }
}

- (void)datePickerChanged:(id)sender
{
    [self setDueDate:self.datePicker.date animated:NO];
}

- (void)heartDidBeat
{
    NSTimeInterval difference = [self.dueDate timeIntervalSinceDate:self.visibleDate];

    if (!self.incrementer) {
        NSUInteger interval = 5;
        self.incrementer = ceil(difference/interval);
    }

    if (self.incrementer > 0 && difference > 0) {
        self.visibleDate = [self.visibleDate dateByAddingTimeInterval:self.incrementer];
        [self.dueDateButton setTitle:[self.visibleDate tackleStringSinceDate:self.startDate] forState:UIControlStateNormal];
    }
    else {
        self.incrementing = NO;
        self.incrementer = 0;
        [[NSNotificationCenter defaultCenter] removeObserver:self name:[MRHeartbeat heartbeatId] object:nil];
    }
}

- (void)resetContent
{
    self.startDate = [NSDate date];
    [self setDueDate:[NSDate dateWithTimeInterval:600 sinceDate:self.startDate] animated:NO];

    [self.textField setText:@""];
    if (self.isDatePickerShown) {
        CGRect mainFrame = self.frame;
        CGRect bottomButtonViewFrame = self.bottomButtonView.frame;

        mainFrame.size.height = mainFrame.size.height - 216;
        bottomButtonViewFrame.origin.y = bottomButtonViewFrame.origin.y - 216;

        [self.datePicker setHidden:YES];
        self.datePickerShown = NO;
        [self.bottomButtonView setFrame:bottomButtonViewFrame];
        [self setFrame:mainFrame];
    }

    [self.datePicker setMinuteInterval:5];
}

- (void)setDueDate:(NSDate *)dueDate animated:(BOOL)animated
{
    self.dueDate = dueDate;

    if (animated) {
        self.incrementing = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(heartDidBeat) name:[MRHeartbeat heartbeatId] object:nil];
        [self.dueDateButton setTitle:[self.visibleDate tackleStringSinceDate:self.startDate] forState:UIControlStateNormal];
    }
    else {
        self.visibleDate = self.dueDate;
        [self.dueDateButton setTitle:[self.visibleDate tackleStringSinceDate:self.startDate] forState:UIControlStateNormal];
    }

    [self.datePicker setDate:self.dueDate animated:NO];
}

@end
