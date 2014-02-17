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

const CGFloat kMREditViewHeight = 185.0f;
const CGFloat kMRCollectionViewStartOffset = -165.0f;
const CGFloat kMRCollectionViewEndOffset = 0.0f;

@interface MRMainViewController ()

@property (nonatomic, strong) MRTaskEditView *editView;
@property (nonatomic, strong) Task *editingTask;
@property (nonatomic, strong) UIPanGestureRecognizer *gestureRecognizer;
@property (nonatomic) CGPoint startTouchPoint;
@property (nonatomic) BOOL shouldStatusBarBeHidden;

@end

@implementation MRMainViewController

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.managedObjectContext = managedObjectContext;

        [self.view setBackgroundColor:[UIColor darkPlumColor]];

        [self setupMainCollectionViewController];
        [self setupEditView];

        self.shouldStatusBarBeHidden = NO;
//        [self setupTopSpace];
    }

    return self;
}

- (void)setupTopSpace
{
    UIView *topSpaceView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20.0f)];
    [topSpaceView setBackgroundColor:[UIColor lightPlumColor]];

    UIView *bottomSeparator = [[UIView alloc] initWithFrame:CGRectMake(0, 19.5f, self.view.frame.size.width, 0.25f)];
    [bottomSeparator setBackgroundColor:[UIColor lightPlumGrayColor]];
    [topSpaceView addSubview:bottomSeparator];

    [self.view addSubview:topSpaceView];
}

- (void)setupMainCollectionViewController
{
    MRMainFlowLayout *layout  = [[MRMainFlowLayout alloc] init];
    [layout setItemSize:CGSizeMake(self.view.frame.size.width, 67.0f)];

    self.mainCollectionViewController = [[MRMainCollectionViewController alloc] initWithCollectionViewLayout:layout];
    [self.mainCollectionViewController setScrollViewDelegate:self];
    [self.mainCollectionViewController setSelectionDelegate:self];
    [self.mainCollectionViewController setPanGestureDelegate:self];

    [self.mainCollectionViewController setManagedObjectContext:self.managedObjectContext];
    [self addChildViewController:self.mainCollectionViewController];
    [self.mainCollectionViewController.view setFrame:CGRectMake(0, 20.0f, self.view.frame.size.width, self.view.frame.size.height - 20.0f)];

    [self.view addSubview:self.mainCollectionViewController.view];
}

- (void)setupEditView
{
    self.editView = [[MRTaskEditView alloc] initWithFrame:CGRectMake(0, kMRCollectionViewStartOffset, self.view.frame.size.width, kMREditViewHeight)];
    [self.editView setDelegate:self];
//    [self.editView setHidden:YES];
//    CALayer *layer = self.editView.layer;
//
//    CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
//    rotationAndPerspectiveTransform.m34 = 1.0 / -1000.0;
//    rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, M_PI * 0.6, 1.0f, 0.0f, 0.0f);
//    layer.anchorPoint = CGPointMake(0.5, 0);
//    layer.transform = rotationAndPerspectiveTransform;

    [self.view addSubview:self.editView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)hideStatusBar
{
    if (!self.shouldStatusBarBeHidden) {
        self.shouldStatusBarBeHidden = YES;
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

- (void)showStatusBar
{
    if (self.shouldStatusBarBeHidden) {
        self.shouldStatusBarBeHidden = NO;
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

- (void)editTask:(Task *)task
{
    [self setEditingTask:task];

    [self.editView hideBottomMaskView];
    [self hideStatusBar];

    [self.editView.textField setText:task.text];
    [self.editView setDueDate:task.dueDate animated:NO];

    [self.mainCollectionViewController.collectionView setScrollEnabled:NO];
    [self.mainCollectionViewController.collectionView setAllowsSelection:NO];

    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = self.editView.frame;
        [self.editView setFrame:CGRectMake(frame.origin.x, 0, frame.size.width, frame.size.height)];
        [self.mainCollectionViewController moveToBack];
    } completion:^(BOOL finished) {
        [self showStatusBar];
    }];
}

#pragma mark - TackMainCollectionViewScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    if (scrollView.contentInset.top == 100 && !self.editView.datePicker.hidden) {
        [self.editView hideDatePickerAnimated:YES];
    }

    CGPoint offset = scrollView.contentOffset;
    CGRect frame = self.editView.frame;
    CGFloat offsetMultiplier = (kMRCollectionViewEndOffset - kMRCollectionViewStartOffset)/100;
    CGFloat offsetY = MAX(kMRCollectionViewStartOffset, kMRCollectionViewStartOffset - (offset.y * offsetMultiplier));

    if (offsetY > kMRCollectionViewStartOffset) {
        [self hideStatusBar];
        [self.editView hideBottomMaskView];
    }

    [self.editView setFrame:CGRectMake(frame.origin.x, offsetY, frame.size.width, frame.size.height)];

    CALayer *layer = self.mainCollectionViewController.collectionView.layer;

    if (offset.y <= kMRCollectionViewEndOffset) {
        CGFloat scale = MAX(1 - (ABS(offset.y) * 0.001f), 0.9);
        [layer setTransform:CATransform3DMakeScale(scale, scale, 1)];
    }
    else {
        [layer setTransform:CATransform3DMakeScale(1, 1, 1)];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView isInset:(BOOL)isInset
{
    [self showStatusBar];
    
    if (!isInset) {
        [self.editView showBottomMaskView];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self showStatusBar];
    [self.editView showBottomMaskView];
}

- (void)scrollViewDidInsetContent:(UIScrollView *)scrollView
{
    [self showStatusBar];
    [self.editView.textField becomeFirstResponder];
}

- (void)scrollViewDidResetContent:(UIScrollView *)scrollView
{
    self.editingTask = nil;
    [self.editView resetContent];
    [self.editView showBottomMaskView];
    [self showStatusBar];
}

#pragma mark - TackMainCollectionViewSelectionDelegate

- (void)didSelectCellWithTask:(Task *)task
{
    [self editTask:task];
}

#pragma mark - TackTaskEditViewDelegate

- (void)taskEditViewDidReturnWithText:(NSString *)text dueDate:(NSDate *)dueDate
{
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
        CGRect frame = self.editView.frame;
        if (frame.origin.y != kMRCollectionViewStartOffset) {
            [self.editView setFrame:CGRectMake(frame.origin.x, kMRCollectionViewStartOffset, frame.size.width, frame.size.height)];
        }
    } completions:^{
        [self.editView resetContent];
    }];
}

- (void)selectTask:(Task *)task
{
    [self.mainCollectionViewController selectTask:task];
}

#pragma mark - MRMainCollectionViewPanGestureDelegate

- (void)panGestureDidPanWithVerticalOffset:(CGFloat)verticalOffset
{
    [self hideStatusBar];

    if (verticalOffset < 0 && !self.editView.datePicker.hidden) {
        [self.editView hideDatePickerAnimated:YES];
    }

    if (self.editView.textField.isFirstResponder) {
        [self.editView.textField resignFirstResponder];
    }

    CGRect frame = self.editView.frame;
    [self.editView setFrame:CGRectMake(frame.origin.x, MAX(kMRCollectionViewStartOffset, verticalOffset), frame.size.width, frame.size.height)];
}

- (void)panGestureWillReachEnd
{
    [self.mainCollectionViewController deselectSelectedCells];
}

- (void)panGestureDidReachEnd
{
    [self scrollViewDidResetContent:self.mainCollectionViewController.collectionView];
    [self.editView showBottomMaskView];
}

- (void)panGestureDidFinish
{
    [self showStatusBar];
}

- (BOOL)prefersStatusBarHidden {
    return self.shouldStatusBarBeHidden;
}

@end
