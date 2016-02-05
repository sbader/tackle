//
//  MRTaskEditViewController.m
//  Tackle
//
//  Created by Scott Bader on 12/27/14.
//  Copyright (c) 2014 Melody Road. All rights reserved.
//

#import "MRTaskEditViewController.h"

#import "PaintCodeStyleKit.h"

#import "MRScrollView.h"
#import "MRHorizontalButton.h"
#import "MRTaskTableViewDelegate.h"
#import "MRDatePickerViewController.h"
#import "MRTaskEditTableViewController.h"
#import "MRCalendarCollectionViewFlowLayout.h"
#import "MRCalendarCollectionViewController.h"

@interface MRTaskEditViewController () <MRDateSelectionDelegate, MRTaskEditTableViewDelegate, MRDatePickerViewControllerDelegate, UITextFieldDelegate, UIScrollViewDelegate>

@property (nonatomic) MRScrollView *scrollView;
@property (nonatomic) UIView *topView;
@property (nonatomic) UIView *titleView;
@property (nonatomic) UIView *dateView;
@property (nonatomic) UIView *doneView;
@property (nonatomic) UIView *addTimeView;
@property (nonatomic) UIView *calendarView;
@property (nonatomic) UIView *previousTasksView;
@property (nonatomic) UIButton *dateButton;
@property (nonatomic) UITextField *titleField;
@property (nonatomic) MRCalendarCollectionViewController *calendarViewController;
@property (nonatomic) MRTaskEditTableViewController *addTimeController;
@property (nonatomic) NSLayoutConstraint *scrollViewBottomConstraint;
@property (nonatomic) UIView *activeView;

@property (nonatomic) NSDate *taskDueDate;
@property (nonatomic) NSString *taskTitle;
@property (nonatomic) BOOL shouldDisplayPreviousTasks;
@property (nonatomic) BOOL shouldDisplayDoneButton;
@property (nonatomic) NSDataDetector *dateDetector;

@property (nonatomic) NSDate *possibleDate;
@property (nonatomic) UIView *possibleDateContainer;
@property (nonatomic) MRHorizontalButton *possibleDateButton;
@property (nonatomic) NSString *leftoverTitleText;
@property (nonatomic) NSLayoutConstraint *possibleDateViewHeightConstraint;

@property (nonatomic) NSManagedObjectContext *managedObjectContext;

@end

@implementation MRTaskEditViewController

- (instancetype)initWithTitle:(NSString *)title dueDate:(NSDate *)dueDate managedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    self = [super init];

    if (self) {
        self.taskTitle = title;
        self.taskDueDate = dueDate;
        self.managedObjectContext = managedObjectContext;
        self.shouldDisplayPreviousTasks = (title == nil);
        self.shouldDisplayDoneButton = (dueDate != nil);
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor lightGrayFormBackgroundColor];

    NSError *error = nil;
    self.dateDetector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeDate
                                                               error:&error];


    [self setupScrollView];
    [self setupTitleView];
    [self setupPossibleDateButton];
    [self setupDateView];
    [self setupCalendarView];
    [self setupAddTimeView];

    [self setupConstraints];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Task Edit Cancel", nil) //Cancel
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(handleCancelButton:)];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Task Edit Save", nil) //Save
                                                                              style:UIBarButtonItemStyleDone
                                                                             target:self
                                                                             action:@selector(handleSaveButton:)];

    NSDictionary *barButtonTitleTextAttributes = @{
                                                   NSFontAttributeName: [UIFont fontForBarButtonItemDoneStyle]
                                                   };

    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:barButtonTitleTextAttributes forState:UIControlStateNormal];

    if (!self.taskDueDate) {
        self.title = NSLocalizedString(@"New Task", nil);

        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitTimeZone
                                                   fromDate:[NSDate date]];

        NSInteger minutes = 10 - (components.minute % 10);
        NSDate *currentDate = [calendar dateFromComponents:components];
        self.taskDueDate = [[NSCalendar currentCalendar] dateByAddingUnit:NSCalendarUnitMinute value:minutes toDate:currentDate options:0];
    }
    else {
        self.title = NSLocalizedString(@"Edit Task", nil);
    }

    [self updateTitleField];
    [self updateDueDateButton];
    [self registerForKeyboardNotifications];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self unregisterKeyboardNotifications];
}

- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];

}

- (void)unregisterKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if (!self.taskTitle || [self.taskTitle isEqualToString:@""]) {
        [self.titleField becomeFirstResponder];
    }
}

- (void)setupScrollView {
    self.automaticallyAdjustsScrollViewInsets = NO;

    self.scrollView = [[MRScrollView alloc] init];
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.scrollView.alwaysBounceVertical = YES;
    self.scrollView.delegate = self;
    self.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:self.scrollView];

    self.topView = [[UIView alloc] init];
    self.topView.translatesAutoresizingMaskIntoConstraints = NO;
    self.topView.backgroundColor = [UIColor offWhiteBackgroundColor];
    [self.scrollView addSubview:self.topView];

    [self.scrollView constraintsMatchSuperview];
    [self.topView horizontalConstraintsMatchSuperview];
}

- (void)setupTitleView {
    self.titleView = [[UIView alloc] init];
    self.titleView.backgroundColor = [UIColor offWhiteBackgroundColor];
    self.titleView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.scrollView addSubview:self.titleView];

    self.titleField = [[UITextField alloc] init];
    self.titleField.translatesAutoresizingMaskIntoConstraints = NO;
    self.titleField.textAlignment = NSTextAlignmentCenter;
    self.titleField.placeholder = NSLocalizedString(@"What do you want to tackle?", nil);
    self.titleField.textColor = [UIColor grayTextColor];
    self.titleField.font = [UIFont fontForFormTextField];
    self.titleField.returnKeyType = UIReturnKeyDone;
    self.titleField.delegate = self;
    self.titleField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.titleView addSubview:self.titleField];

    self.titleField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, 5, 50.0f)];
    self.titleField.leftView.userInteractionEnabled = NO;
    self.titleField.leftViewMode = UITextFieldViewModeAlways;

    self.titleField.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, 5, 50.0f)];
    self.titleField.rightView.userInteractionEnabled = NO;
    self.titleField.rightViewMode = UITextFieldViewModeAlways;

    [self.titleField addTarget:self
                        action:@selector(titleFieldDidChange:)
              forControlEvents:UIControlEventEditingChanged];

    [self.titleView horizontalConstraintsMatchSuperview];
    [self.titleField horizontalConstraintsMatchSuperview];

    [self.titleField topConstraintMatchesSuperview];
    [self.titleField bottomConstraintMatchesSuperview];
}

- (void)setupDateView {
    self.dateView = [[UIView alloc] init];
    self.dateView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.scrollView addSubview:self.dateView];

    self.dateButton = [MRHorizontalButton buttonWithType:UIButtonTypeSystem];
    self.dateButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.dateButton.titleLabel.font = [UIFont fontForLargeFormButtons];
    [self.dateButton setImage:[PaintCodeStyleKit imageOfClock] forState:UIControlStateNormal];
    [self.dateButton addTarget:self action:@selector(handleDateButton:) forControlEvents:UIControlEventTouchUpInside];
    self.dateButton.contentEdgeInsets = UIEdgeInsetsMake(10, 0, 10, 0);
    [self.dateView addSubview:self.dateButton];

    [self.dateView horizontalConstraintsMatchSuperview];

    [self.dateButton leadingConstraintMatchesSuperview];
    [self.dateButton trailingConstraintMatchesSuperview];

    [self.dateButton topConstraintMatchesSuperviewWithConstant:10.0];
    [self.dateButton bottomConstraintMatchesSuperviewWithConstant:-7.0];
}

- (void)setupPossibleDateButton {
    self.possibleDateContainer = [[UIView alloc] init];
    self.possibleDateContainer.translatesAutoresizingMaskIntoConstraints = NO;
    [self.scrollView addSubview:self.possibleDateContainer];

    self.possibleDateButton = [MRHorizontalButton buttonWithType:UIButtonTypeSystem];
    self.possibleDateButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.possibleDateButton.titleLabel.font = [UIFont fontForLargeFormButtons];
    [self.possibleDateButton addTarget:self action:@selector(handlePossibleDateButton:) forControlEvents:UIControlEventTouchUpInside];
    self.possibleDateButton.contentEdgeInsets = UIEdgeInsetsMake(10, 0, 10, 0);
    [self.possibleDateContainer addSubview:self.possibleDateButton];
    [self.possibleDateButton setTintColor:[UIColor whiteColor]];
    [self.possibleDateContainer setBackgroundColor:[UIColor plumTintColor]];

    [self.possibleDateContainer horizontalConstraintsMatchSuperview];

    [self.possibleDateButton leadingConstraintMatchesSuperview];
    [self.possibleDateButton trailingConstraintMatchesSuperview];
    [self.possibleDateButton verticalCenterConstraintMatchesSuperview];

    self.possibleDateViewHeightConstraint = [NSLayoutConstraint constraintWithItem:self.possibleDateContainer
                                                                         attribute:NSLayoutAttributeHeight
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:nil
                                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                                        multiplier:1.0
                                                                          constant:0];

    [self.possibleDateContainer addConstraint:self.possibleDateViewHeightConstraint];

}

- (void)displayPossibleDateButton {
    self.possibleDateViewHeightConstraint.constant = 45;
    [self.possibleDateContainer layoutIfNeeded];
}

- (void)hidePossibleDateButton {
    [self.possibleDateButton setTitle:nil forState:UIControlStateNormal];
    self.possibleDateViewHeightConstraint.constant = 0;
    [self.possibleDateContainer layoutIfNeeded];
}

- (void)setupCalendarView {
    self.calendarView = [[UIView alloc] init];
    self.calendarView.backgroundColor = [UIColor offWhiteBackgroundColor];
    self.calendarView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.scrollView addSubview:self.calendarView];

    MRCalendarCollectionViewFlowLayout *layout = [[MRCalendarCollectionViewFlowLayout alloc] init];
    self.calendarViewController = [[MRCalendarCollectionViewController alloc] initWithCollectionViewLayout:layout];
    self.calendarViewController.dateSelectionDelegate = self;
    self.calendarViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self.calendarView addSubview:self.calendarViewController.view];

    [self.calendarViewController.view constraintsMatchSuperview];
    [self.calendarView horizontalConstraintsMatchSuperview];

    UIView *borderTop = [[UIView alloc] init];
    borderTop.translatesAutoresizingMaskIntoConstraints = NO;
    borderTop.backgroundColor = [UIColor grayBorderColor];
    [self.calendarView addSubview:borderTop];

    UIView *borderBottom = [[UIView alloc] init];
    borderBottom.translatesAutoresizingMaskIntoConstraints = NO;
    borderBottom.backgroundColor = [UIColor grayBorderColor];
    [self.calendarView addSubview:borderBottom];

    [borderTop horizontalConstraintsMatchSuperview];
    [borderBottom horizontalConstraintsMatchSuperview];

    [borderTop staticHeightConstraint:1.0];
    [borderTop topConstraintMatchesSuperview];
    [borderBottom staticHeightConstraint:1.0];
    [borderBottom bottomConstraintMatchesSuperview];
}

- (void)setupDoneView {
    self.doneView = [[UIView alloc] init];
    self.doneView.backgroundColor = [UIColor offWhiteBackgroundColor];
    self.doneView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.scrollView addSubview:self.doneView];

}

- (void)setupAddTimeView {
    self.addTimeView = [[UIView alloc] init];
    self.addTimeView.backgroundColor = [UIColor offWhiteBackgroundColor];
    self.addTimeView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.scrollView addSubview:self.addTimeView];

    self.addTimeController = [[MRTaskEditTableViewController alloc] initWithDoneButtonEnabled:self.shouldDisplayDoneButton previousTasksEnabled:self.shouldDisplayPreviousTasks managedObjectContext:self.managedObjectContext];
    self.addTimeController.delegate = self;
    [self.addTimeView addSubview:self.addTimeController.view];

    [self.addTimeView horizontalConstraintsMatchSuperview];
    [self.addTimeController.view constraintsMatchSuperview];
}

- (void)setupConstraints {
    [self.topView addConstraintEqualToView:self.titleView inContainer:self.scrollView withAttribute:NSLayoutAttributeBottom relatedAttribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
    [self.topView staticHeightConstraint:400.0];
    [self.topView addConstraintEqualToView:self.scrollView inContainer:self.scrollView withAttribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0];

    [self.titleView topConstraintMatchesView:self.scrollView withConstant:0.0];
    [self.titleView staticHeightConstraint:75.0];

    [self.possibleDateContainer addConstraintEqualToView:self.titleView inContainer:self.scrollView withAttribute:NSLayoutAttributeTop relatedAttribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];

    [self.dateView addConstraintEqualToView:self.possibleDateContainer inContainer:self.scrollView withAttribute:NSLayoutAttributeTop relatedAttribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
    [self.calendarView addConstraintEqualToView:self.dateView inContainer:self.scrollView withAttribute:NSLayoutAttributeTop relatedAttribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
    [self.calendarView staticHeightConstraint:74.0];

    [self.addTimeView addConstraintEqualToView:self.calendarView inContainer:self.scrollView withAttribute:NSLayoutAttributeTop relatedAttribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0];
    [self.addTimeView addConstraintEqualToView:self.addTimeController.tableView inContainer:self.scrollView withAttribute:NSLayoutAttributeHeight relatedAttribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0];


    [self.titleView addConstraintEqualToView:self.scrollView inContainer:self.scrollView withAttribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0];
    [self.dateView addConstraintEqualToView:self.scrollView inContainer:self.scrollView withAttribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0];
    [self.calendarView addConstraintEqualToView:self.scrollView inContainer:self.scrollView withAttribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0];
    [self.addTimeView addConstraintEqualToView:self.scrollView inContainer:self.scrollView withAttribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0];
    [self.addTimeView bottomConstraintMatchesView:self.scrollView withConstant:0.0];
}

- (void)handleCancelButton:(id)sender {
    if (self.titleField.isFirstResponder) {
        [self.titleField resignFirstResponder];
    }

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)handleSaveButton:(id)sender {
    if ([self.titleField.text length] == 0) {
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"] ;

        animation.values = @[
                             [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(-5.0f, 0.0f, 0.0f)],
                             [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(5.0f, 0.0f, 0.0f)]
                             ];

        animation.autoreverses = YES ;
        animation.repeatCount = 5.0f ;
        animation.duration = 0.05f ;

        [self.titleField.layer addAnimation:animation forKey:nil ] ;

        return;
    }

    if (self.titleField.isFirstResponder) {
        [self.titleField resignFirstResponder];
    }

    [self.delegate editedTaskTitle:self.titleField.text dueDate:self.taskDueDate];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)updateTitleField {
    if (self.taskTitle) {
        self.titleField.text = self.taskTitle;
    }
}

- (void)updateDueDateButton {
    if (self.taskDueDate) {
        [self.dateButton setTitle:self.taskDueDate.tackleString forState:UIControlStateNormal];
    }
}

- (void)keyboardWillBeShown:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    CGRect keyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];

    UIEdgeInsets contentInset = self.scrollView.contentInset;
    contentInset.bottom = keyboardRect.size.height;
    self.scrollView.scrollIndicatorInsets = contentInset;
    self.scrollView.contentInset = contentInset;

    CGRect viewRect = self.view.frame;
    viewRect.size.height -= keyboardRect.size.height;
    if (!CGRectContainsPoint(viewRect, self.activeView.frame.origin) ) {
        [self.scrollView scrollRectToVisible:self.activeView.frame animated:YES];
    }
}

- (void)keyboardWillBeHidden:(id)sender {
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

#pragma mark - Handlers

- (void)handlePossibleDateButton:(id)sender {
    if (self.possibleDate) {
        [self didSelectDate:self.possibleDate];
        self.possibleDate = nil;
        if (self.leftoverTitleText.length > 0) {
            self.taskTitle = self.leftoverTitleText;
            [self updateTitleField];
        }
        self.leftoverTitleText = nil;
    }

    [self.possibleDateButton setTitle:nil forState:UIControlStateNormal];
    [self hidePossibleDateButton];
}

- (void)titleFieldDidChange:(id)sender {
    NSTextCheckingResult *result = [self.dateDetector firstMatchInString:self.titleField.text
                                                                 options:kNilOptions
                                                                   range:NSMakeRange(0, self.titleField.text.length)];

    if (result && [result.date compare:[NSDate date]] == NSOrderedDescending) {
        NSString *leftoverText = [self.titleField.text stringByReplacingCharactersInRange:result.range withString:@""];
        self.leftoverTitleText = [leftoverText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        [self displayPossibleDateButton];
        NSString *buttonText = [NSString stringWithFormat:NSLocalizedString(@"Date Detector Format", nil), result.date.tackleString];
        [self.possibleDateButton setTitle:buttonText forState:UIControlStateNormal];
        self.possibleDate = result.date;

        return;
    }

    [self.possibleDateButton setTitle:nil forState:UIControlStateNormal];
    [self hidePossibleDateButton];
    self.possibleDate = nil;
    self.leftoverTitleText = nil;
}

- (void)handleDateButton:(id)sender {
    if (self.titleField.isFirstResponder) {
        [self.titleField resignFirstResponder];
    }

    MRDatePickerViewController *datePickerController = [[MRDatePickerViewController alloc] initWithDate:self.taskDueDate];
    datePickerController.delegate = self;
    [self mr_presentViewControllerModally:datePickerController animated:YES completion:nil];
}

#pragma mark - Date Selection Delegate

- (void)selectedDate:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear
                                               fromDate:date];

    NSDateComponents *newComponents = [calendar components:NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond|NSCalendarUnitTimeZone
                                                  fromDate:self.taskDueDate];
    newComponents.year = components.year;
    newComponents.month = components.month;
    newComponents.day = components.day;

    self.taskDueDate = [calendar dateFromComponents:newComponents];

    [self updateDueDateButton];
}

#pragma mark - Task Edit Table View Delegate

- (void)selectedDone {
    [self.delegate completedTask];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)selectedTimeInterval:(MRTimeInterval *)timeInterval {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    self.taskDueDate = [calendar dateByAddingUnit:timeInterval.unit
                                            value:timeInterval.interval
                                           toDate:self.taskDueDate
                                          options:0];

    [self updateDueDateButton];
}

- (void)selectedPreviousTaskTitle:(NSString *)title {
    self.taskTitle = title;
    [self updateTitleField];
    [self.scrollView setContentOffset:CGPointZero animated:YES];
}

#pragma mark - Text Field Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.activeView = textField.superview;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    textField.text = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.activeView = nil;
}

#pragma mark - Date Picker Delegate

- (void)didSelectDate:(NSDate *)date {
    self.taskDueDate = date;
    [self updateDueDateButton];
}

@end
