//
//  MRMainViewController.m
//  Tackle
//
//  Created by Scott Bader on 1/26/14.
//  Copyright (c) 2014 Melody Road. All rights reserved.
//

#import "MRMainViewController.h"

#import "MRMainFlowLayout.h"
#import "Task.h"

const CGFloat kMREditViewHeight = 190.0f;
const CGFloat kMRCollectionViewStartOffset = -170.0f;
const CGFloat kMRCollectionViewEndOffset = 0.0f;
const CGFloat kMREditViewInitialTop = 20.0f;

@interface MRMainViewController ()

@property (nonatomic, strong) MRTaskEditView *editView;
@property (nonatomic, strong) Task *editingTask;
@property (nonatomic, strong) UIPanGestureRecognizer *gestureRecognizer;
@property (nonatomic) CGPoint startTouchPoint;
@property (nonatomic) BOOL shouldStatusBarBeHidden;

@end

@implementation MRMainViewController

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    self = [super initWithNibName:nil bundle:nil];

    if (self) {
        self.managedObjectContext = managedObjectContext;

        [self.view setBackgroundColor:[UIColor darkPlumColor]];

        [self setupMainCollectionViewController];
        [self setupEditView];

        self.shouldStatusBarBeHidden = NO;
    }

    return self;
}

- (void)setupMainCollectionViewController {
    MRMainFlowLayout *layout  = [[MRMainFlowLayout alloc] init];
    [layout setItemSize:CGSizeMake(self.view.frame.size.width, 67.0f)];

    self.mainCollectionViewController = [[MRMainCollectionViewController alloc] initWithCollectionViewLayout:layout managedObjectContext:self.managedObjectContext];

    self.mainCollectionViewController.view.translatesAutoresizingMaskIntoConstraints = NO;

    [self.mainCollectionViewController setScrollViewDelegate:self];
    [self.mainCollectionViewController setSelectionDelegate:self];
    [self.mainCollectionViewController setPanGestureDelegate:self];

    [self.view addSubview:self.mainCollectionViewController.view];
    
    [self.view addCompactConstraints:@[
                                       @"view.height = superview.height + topOffset",
                                       @"view.leading = superview.leading",
                                       @"view.trailing = superview.trailing"
                                       ]
                             metrics:@{
                                       @"topOffset": @(-20)
                                       }
                               views:@{
                                       @"view": self.mainCollectionViewController.view,
                                       @"superview": self.view
                                       }];

    self.mainCollectionViewController.centerConstraint = [NSLayoutConstraint constraintWithItem:self.mainCollectionViewController.view
                                                                                      attribute:NSLayoutAttributeCenterY
                                                                                      relatedBy:NSLayoutRelationEqual
                                                                                         toItem:self.view
                                                                                      attribute:NSLayoutAttributeCenterY
                                                                                     multiplier:1
                                                                                       constant:10.0f];
    [self.view addConstraint:self.mainCollectionViewController.centerConstraint];
}

- (void)setupEditView {
//    self.editView = [[MRTaskEditView alloc] initWithFrame:CGRectMake(0, kMRCollectionViewStartOffset, self.view.frame.size.width, kMREditViewHeight)];
    self.editView = [[MRTaskEditView alloc] init];
    self.editView.translatesAutoresizingMaskIntoConstraints = NO;

    [self.view addSubview:self.editView];

    [self.view addCompactConstraints:@[
                                       @"view.leading = superview.leading",
                                       @"view.trailing = superview.trailing",
//                                       @"view.height = height"
                                       ]
                             metrics:@{
                                       @"height": @(kMREditViewHeight)
                                       }
                               views:@{
                                       @"view": self.editView,
                                       @"superview": self.view
                                       }];

    self.editView.topConstraint = [NSLayoutConstraint constraintWithItem:self.editView
                                                               attribute:NSLayoutAttributeTop
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self.view
                                                               attribute:NSLayoutAttributeTop
                                                              multiplier:1
                                                                constant:-(kMREditViewHeight - kMREditViewInitialTop)];

    [self.view addConstraint:self.editView.topConstraint];


    [self.editView setDelegate:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)hideStatusBar {
    if (!self.shouldStatusBarBeHidden) {
        self.shouldStatusBarBeHidden = YES;
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

- (void)showStatusBar {
    if (self.shouldStatusBarBeHidden) {
        self.shouldStatusBarBeHidden = NO;
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

- (void)editTask:(Task *)task {
    [self setEditingTask:task];

    [self hideStatusBar];

    [self.editView.textField setText:task.text];
    [self.editView setDueDate:task.dueDate animated:NO];

    [self.mainCollectionViewController.collectionView setScrollEnabled:NO];
    [self.mainCollectionViewController.collectionView setAllowsSelection:NO];

    [UIView animateWithDuration:0.2 animations:^{
        self.editView.topConstraint.constant = 0;
        [self.view layoutIfNeeded];
        [self.mainCollectionViewController moveToBack];
    } completion:^(BOOL finished) {
        [self showStatusBar];
    }];
}

#pragma mark - Main Collection View Scroll View Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentInset.top == 100 && !self.editView.datePicker.hidden) {
        [self.editView hideDatePickerAnimated:YES];
    }

    CGPoint offset = scrollView.contentOffset;
    CGFloat offsetMultiplier = (kMRCollectionViewEndOffset - kMRCollectionViewStartOffset)/100;
    CGFloat offsetY = MAX(kMRCollectionViewStartOffset, kMRCollectionViewStartOffset - (offset.y * offsetMultiplier));

    self.editView.topConstraint.constant = offsetY;
    [self.view layoutIfNeeded];

    CALayer *layer = self.mainCollectionViewController.collectionView.layer;

    if (offsetY > kMRCollectionViewStartOffset) {
        [self hideStatusBar];
    }

    if (offset.y <= kMRCollectionViewEndOffset) {
        CGFloat scale = MAX(1 - (ABS(offset.y) * 0.001f), 0.9);
        [layer setTransform:CATransform3DMakeScale(scale, scale, 1)];
    }
    else {
        [self showStatusBar];
        [layer setTransform:CATransform3DMakeScale(1, 1, 1)];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self showStatusBar];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self showStatusBar];
}

- (void)scrollViewDidInsetContent:(UIScrollView *)scrollView {
    [self showStatusBar];
    [self.editView.textField becomeFirstResponder];
}

- (void)scrollViewDidResetContent:(UIScrollView *)scrollView {
    self.editingTask = nil;
    [self.editView resetContent];
    [self showStatusBar];
}

#pragma mark - Main Collection View Selection Delegate

- (void)didSelectCellWithTask:(Task *)task {
    [self editTask:task];
}

#pragma mark - Task Edit View Delegate

- (void)taskEditViewDidReturnWithText:(NSString *)text dueDate:(NSDate *)dueDate {
    if (self.editingTask) {
        BOOL shouldReschedule = !([dueDate isEqual:self.editingTask.dueDate]);

        [self.editingTask setText:text];
        [self.editingTask setDueDate:dueDate];

        __block NSError *error;
        [self.editingTask.managedObjectContext performBlock:^{
            [self.editingTask.managedObjectContext save:&error];
        }];

        if (shouldReschedule) {
            [self.editingTask rescheduleNotification];
        }

        [self setEditingTask:nil];
    }
    else {
        Task *task = [NSEntityDescription insertNewObjectForEntityForName:@"Task" inManagedObjectContext:self.managedObjectContext];
        [task setText:text];
        [task setDueDate:dueDate];

        __block NSError *error;
        [task.managedObjectContext performBlock:^{
            [task.managedObjectContext save:&error];
            [task scheduleNotification];
        }];
    }

    [self.mainCollectionViewController resetContentOffsetWithAnimations:^{
        self.editView.topConstraint.constant = kMREditViewInitialTop;
        [self.view layoutIfNeeded];
    } completions:^{
        [self.editView resetContent];
    }];
}

- (void)selectTask:(Task *)task {
    [self.mainCollectionViewController selectTask:task];
}

#pragma mark - Main Collection View Pan Gesture Delegate

- (void)panGestureDidPanWithVerticalOffset:(CGFloat)verticalOffset {
    if (verticalOffset < 0 && !self.editView.datePicker.hidden) {
        [self.editView hideDatePickerAnimated:YES];
    }

    if (self.editView.textField.isFirstResponder) {
        [self.editView.textField resignFirstResponder];
    }

    CGFloat offsetMultiplier = (kMRCollectionViewEndOffset - kMRCollectionViewStartOffset)/100;
    CGFloat offsetY = MAX(kMRCollectionViewStartOffset, verticalOffset * offsetMultiplier);

    if (offsetY == kMRCollectionViewStartOffset) {
        [self showStatusBar];
    }
    else {
        [self hideStatusBar];
    }

    self.editView.topConstraint.constant = offsetY;
    [self.editView layoutIfNeeded];

//    if (offsetY != frame.origin.y) {
//        if (offsetY == kMRCollectionViewStartOffset) {
//            [self showStatusBar];
//        }
//        else {
//            [self hideStatusBar];
//        }
//
//        self.editView.topConstraint.constant = offsetY;
//        [self.editView layoutIfNeeded];
//    }
}

- (void)panGestureWillReachEnd {
    [self.mainCollectionViewController deselectSelectedCells];
}

- (void)panGestureDidReachEnd {
    [self scrollViewDidResetContent:self.mainCollectionViewController.collectionView];
}

- (void)panGestureDidFinish {
    [self showStatusBar];
}

- (BOOL)prefersStatusBarHidden {
    return self.shouldStatusBarBeHidden;
}

@end
