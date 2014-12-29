//
//  MRTaskEditViewController.m
//  Tackle
//
//  Created by Scott Bader on 12/27/14.
//  Copyright (c) 2014 Melody Road. All rights reserved.
//

#import "MRTaskEditViewController.h"

#import "PaintCodeStyleKit.h"

#import "MRHorizontalButton.h"
#import "MRAddTimeTableViewController.h"
#import "MRCalendarCollectionViewFlowLayout.h"
#import "MRCalendarCollectionViewController.h"

@interface MRTaskEditViewController () <MRDateSelectionDelegate>

@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) UIView *topView;
@property (nonatomic) UIView *titleView;
@property (nonatomic) UIView *dateView;
@property (nonatomic) UIView *addTimeView;
@property (nonatomic) UIView *calendarView;
@property (nonatomic) UIView *previousTaskView;
@property (nonatomic) UIButton *dateButton;
@property (nonatomic) UITextField *titleField;
@property (nonatomic) MRCalendarCollectionViewController *calendarViewController;
@property (nonatomic) MRAddTimeTableViewController *addTimeController;

@property (nonatomic) NSDate *dueDate;
@property (nonatomic) NSString *title;

@end

@implementation MRTaskEditViewController

- (instancetype)initWithTitle:(NSString *)title dueDate:(NSDate *)dueDate {
    self = [super init];

    if (self) {
        self.title = title;
        self.dueDate = dueDate;
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Task";
    self.view.backgroundColor = [UIColor lightGrayFormBackgroundColor];

    [self setupScrollView];
    [self setupTitleView];
    [self setupDateView];
    [self setupCalendarView];
    [self setupAddTimeView];
    [self setupPreviousTaskView];
    [self setupConstraints];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(handleCancelButton:)];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(handleSaveButton:)];

    if (!self.dueDate) {
        self.dueDate = [[NSCalendar currentCalendar] dateByAddingUnit:NSCalendarUnitMinute value:10 toDate:[NSDate date] options:0];
    }

    [self updateTitleField];
    [self updateDueDateButton];
}

- (void)setupScrollView {
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.scrollView.alwaysBounceVertical = YES;
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
    self.titleField.placeholder = @"What do you want to tackle?";
    self.titleField.textColor = [UIColor grayTextColor];
    self.titleField.font = [UIFont effraLightWithSize:20.0];
    [self.titleView addSubview:self.titleField];

    self.titleField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, 5, 50.0f)];
    self.titleField.leftViewMode = UITextFieldViewModeAlways;

    self.titleField.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, 5, 50.0f)];
    self.titleField.rightViewMode = UITextFieldViewModeAlways;

    [self.titleView horizontalConstraintsMatchSuperview];
    [self.titleField horizontalConstraintsMatchSuperview];

    [self.titleView addCompactConstraints:@[
                                            @"title.top = view.top + 25",
                                            @"title.bottom = view.bottom - 25",
                                            ]
                                  metrics:@{}
                                    views:@{
                                            @"view": self.titleView,
                                            @"title": self.titleField
                                            }];
}

- (void)setupDateView {
    self.dateView = [[UIView alloc] init];
    self.dateView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.scrollView addSubview:self.dateView];

    self.dateButton = [MRHorizontalButton buttonWithType:UIButtonTypeSystem];
    self.dateButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.dateButton.titleLabel.font = [UIFont effraLightWithSize:24.0];
    [self.dateButton setTitle:@"Tomorrow at 1:45 PM" forState:UIControlStateNormal];
    [self.dateButton setImage:[PaintCodeStyleKit imageOfAlarmClockIcon] forState:UIControlStateNormal];
    [self.dateView addSubview:self.dateButton];

    [self.dateView horizontalConstraintsMatchSuperview];
    [self.dateView addCompactConstraints:@[
                                           @"button.leading = view.leading + 20",
                                           @"button.trailing = view.trailing - 20",
                                           @"button.top = view.top + 20",
                                           @"button.bottom = view.bottom - 20",
                                           ]
                                 metrics:@{}
                                   views:@{
                                           @"button": self.dateButton,
                                           @"view": self.dateView
                                           }];
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

    [self.calendarView addCompactConstraints:@[
                                               @"borderTop.height = 1",
                                               @"borderTop.top = view.top",
                                               @"borderBottom.height = 1",
                                               @"borderBottom.bottom = view.bottom",
                                               ]
                                     metrics:@{}
                                       views:@{
                                               @"view": self.calendarView,
                                               @"borderTop": borderTop,
                                               @"borderBottom": borderBottom
                                               }];
}

- (void)setupAddTimeView {
    self.addTimeView = [[UIView alloc] init];
    self.addTimeView.backgroundColor = [UIColor offWhiteBackgroundColor];
    self.addTimeView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.scrollView addSubview:self.addTimeView];

    self.addTimeController = [[MRAddTimeTableViewController alloc] init];
    [self.addTimeView addSubview:self.addTimeController.view];

    [self.addTimeView horizontalConstraintsMatchSuperview];
    [self.addTimeController.view constraintsMatchSuperview];

    UIView *borderTop = [[UIView alloc] init];
    borderTop.translatesAutoresizingMaskIntoConstraints = NO;
    borderTop.backgroundColor = [UIColor grayBorderColor];
    [self.addTimeView addSubview:borderTop];

    UIView *borderBottom = [[UIView alloc] init];
    borderBottom.translatesAutoresizingMaskIntoConstraints = NO;
    borderBottom.backgroundColor = [UIColor grayBorderColor];
    [self.addTimeView addSubview:borderBottom];

    [borderTop horizontalConstraintsMatchSuperview];
    [borderBottom horizontalConstraintsMatchSuperview];

    [self.addTimeView addCompactConstraints:@[
                                               @"borderTop.height = 1",
                                               @"borderTop.top = view.top",
                                               @"borderBottom.height = 1",
                                               @"borderBottom.bottom = view.bottom",
                                               ]
                                     metrics:@{}
                                       views:@{
                                               @"view": self.addTimeView,
                                               @"borderTop": borderTop,
                                               @"borderBottom": borderBottom
                                               }];

}

- (void)setupPreviousTaskView {
}

- (void)setupConstraints {
    [self.scrollView addCompactConstraints:@[
                                             @"topView.bottom = titleView.top",
                                             @"topView.height = 400",
                                             @"topView.width = view.width",
                                             @"titleView.top = view.top",
                                             @"titleView.height = 75",
                                             @"dateView.top = titleView.bottom",
                                             @"calendarView.top = dateView.bottom",
                                             @"calendarView.height = 74",
                                             @"addTimeView.top = calendarView.bottom + 38",
                                             @"addTimeView.height = 132",
                                             @"titleView.width = view.width",
                                             @"dateView.width = view.width",
                                             @"calendarView.width = view.width",
                                             @"addTimeView.width = view.width"
                                             ]
                                   metrics:@{}
                                     views:@{
                                             @"topView": self.topView,
                                             @"titleView": self.titleView,
                                             @"dateView": self.dateView,
                                             @"calendarView": self.calendarView,
                                             @"addTimeView": self.addTimeView,
                                             @"view": self.scrollView
                                             }];
}

- (void)handleCancelButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)handleSaveButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//- (void)updateFromTask:(Task *)task {
//    if (self.title) {
//        self.titleField.text = self.title;
//    }
//
//    if (self.dueDate) {
//        [self.dateButton setTitle:self.dueDate.tackleString forState:UIControlStateNormal];
//    }
//}

- (void)updateTitleField {
    if (self.title) {
        self.titleField.text = self.title;
    }
}

- (void)updateDueDateButton {
    if (self.dueDate) {
        [self.dateButton setTitle:self.dueDate.tackleString forState:UIControlStateNormal];
    }
}

//- (void)handleSubmit:(id)sender {
//    if ([self.textField.text length] == 0) {
//        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"] ;
//
//        animation.values = @[
//                             [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(-5.0f, 0.0f, 0.0f)],
//                             [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(5.0f, 0.0f, 0.0f)]
//                             ];
//
//        animation.autoreverses = YES ;
//        animation.repeatCount = 5.0f ;
//        animation.duration = 0.05f ;
//
//        [self.textField.layer addAnimation:animation forKey:nil] ;
//
//        return;
//    }
//
//    [self.textField resignFirstResponder];
//
//    NSTimeInterval interval = [self.dueDate timeIntervalSinceDate:self.startDate];
//    NSDate *dueDate = self.dueDate;
//
//    if (interval < 3600) {
//        dueDate = [NSDate dateWithTimeInterval:interval sinceDate:[NSDate date]];
//    }
//
//    [self.delegate taskEditViewDidReturnWithText:self.textField.text dueDate:dueDate];
//}

//- (void)heartDidBeat {
//    NSTimeInterval difference = [self.dueDate timeIntervalSinceDate:self.visibleDate];
//
//    if (!self.incrementer) {
//        NSUInteger interval = 5;
//        self.incrementer = ceil(difference/interval);
//    }
//
//    if (self.incrementer > 0 && difference > 0) {
//        self.visibleDate = [self.visibleDate dateByAddingTimeInterval:self.incrementer];
//        [self.dueDateButton setTitle:[self.visibleDate tackleStringSinceDate:self.startDate] forState:UIControlStateNormal];
//    }
//    else {
//        self.incrementing = NO;
//        self.incrementer = 0;
//        [[NSNotificationCenter defaultCenter] removeObserver:self name:[MRHeartbeat heartbeatId] object:nil];
//    }
//}

//- (void)setDueDate:(NSDate *)dueDate animated:(BOOL)animated {
//    if (dueDate) {
//        self.dueDate = dueDate;
//
//        if (animated) {
//            self.incrementing = YES;
//            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(heartDidBeat) name:[MRHeartbeat heartbeatId] object:nil];
//            [self.dueDateButton setTitle:[self.visibleDate tackleStringSinceDate:self.startDate] forState:UIControlStateNormal];
//        }
//        else {
//            self.visibleDate = self.dueDate;
//            [self.dueDateButton setTitle:[self.visibleDate tackleStringSinceDate:self.startDate] forState:UIControlStateNormal];
//        }
//
//        [self.datePicker setDate:self.dueDate animated:NO];
//    }
//}

#pragma mark - Date Selection Delegate

- (void)selectedDate:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitDay|NSCalendarUnitMonth|NSCalendarUnitYear
                                               fromDate:date];

    NSDateComponents *newComponents = [calendar components:NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond|NSCalendarUnitTimeZone
                                                  fromDate:self.dueDate];
    newComponents.year = components.year;
    newComponents.month = components.month;
    newComponents.day = components.day;

    self.dueDate = [calendar dateFromComponents:newComponents];

    [self updateDueDateButton];
}

@end
