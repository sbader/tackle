//
//  MRMainCollectionViewCell.m
//  Tackle
//
//  Created by Scott Bader on 1/27/14.
//  Copyright (c) 2014 Melody Road. All rights reserved.
//

#import "MRMainCollectionViewCell.h"

#import "MRLongDateFormatter.h"
#import <QuartzCore/QuartzCore.h>

const CGFloat kMRMainCollectionViewCellVerticalPadding = 12.0f;
const CGFloat kMRMainCollectionViewCellHorizontalPadding = 8.0f;

@interface MRMainCollectionViewCell ()

@property (strong, nonatomic) UIView *mainView;
@property (strong, nonatomic) UIView *topSeparator;
@property (strong, nonatomic) UIView *bottomSeparator;

@property (strong, nonatomic) UIPanGestureRecognizer *panGestureRecognizer;
@property (strong, nonatomic) UILongPressGestureRecognizer *longPressGestureRecognizer;
@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) UIGravityBehavior *gravityBehaviour;
@property (nonatomic, strong) UIPushBehavior* pushBehavior;
@property (nonatomic, strong) UIAttachmentBehavior *panAttachmentBehaviour;
@property (nonatomic, strong) NSDate *initialDueDate;
@property (nonatomic, getter = isDragging) BOOL dragging;
@property (nonatomic, getter = isLongPressed) BOOL longPressed;
@property (nonatomic, getter = hasShadow) BOOL shadow;
@property (nonatomic) CGPoint startCenter;

@end

@implementation MRMainCollectionViewCell

@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor darkPlumColor]];

        [self setupMainView];
        [self setupPanGestureRecognizer];
        [self setupLongPressGestureRecognizer];
        [self setupAnimator];
        [self setupDueDateLabel];
        [self setupTaskTextLabel];
        [self setupSeparators];

        self.dragging = NO;
        self.longPressed = NO;
        self.shadow = NO;
    }
    return self;
}

- (void)performSelection
{
    [self.mainView setBackgroundColor:UIColorFromRGB(0xCECEDE)];
}

- (void)performDeselection
{
    [self.mainView setBackgroundColor:[UIColor whiteColor]];
}

- (void)performHighlight
{
    [self.mainView setBackgroundColor:UIColorFromRGB(0xE1E1EB)];
}

- (void)performUnhighlight
{
    if (!self.isDragging && !self.isLongPressed) {
        [self.mainView setBackgroundColor:[UIColor whiteColor]];
    }
}

- (void)decrementDate
{
    [self.dueDateLabel setText:self.initialDueDate.tackleString];
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
}

- (void)prepareForReuse
{
    [self.animator removeAllBehaviors];
    [self.mainView setTransform:CGAffineTransformIdentity];
    [self.mainView setBackgroundColor:[UIColor whiteColor]];

    self.dragging = NO;
    self.longPressed = NO;
}

- (void)updateSizing
{
    [self.mainView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self.topSeparator setFrame:CGRectMake(0, 0, self.frame.size.width, 0.25f)];
    [self.bottomSeparator setFrame:CGRectMake(0, self.frame.size.height - 0.25f, self.frame.size.width, 0.25f)];
    self.startCenter = self.mainView.center;
}

- (void)setupMainView
{
    self.mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self.mainView setBackgroundColor:[UIColor whiteColor]];
    [self.contentView addSubview:self.mainView];
}

- (void)setupPanGestureRecognizer
{
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [self.panGestureRecognizer setDelegate:self];
    [self.mainView addGestureRecognizer:self.panGestureRecognizer];
}

- (void)setupLongPressGestureRecognizer
{
    self.longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
    [self.longPressGestureRecognizer setMinimumPressDuration:0.4];
    [self.longPressGestureRecognizer setDelegate:self];
    [self.mainView addGestureRecognizer:self.longPressGestureRecognizer];
}

- (void)setupAnimator
{
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
}

- (void)setupDueDateLabel
{
    self.dueDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMRMainCollectionViewCellHorizontalPadding, kMRMainCollectionViewCellVerticalPadding, 300.0f, 21.0f)];
    [self.dueDateLabel setFont:[UIFont effraRegularWithSize:18.0f]];
    [self.dueDateLabel setTextColor:[UIColor blackColor]];

    [self.mainView addSubview:self.dueDateLabel];
}

- (void)setupTaskTextLabel
{
    self.taskTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMRMainCollectionViewCellHorizontalPadding, 35.0f, 300.0f, 21.0f)];
    [self.taskTextLabel setFont:[UIFont effraLightWithSize:16.0f]];
    [self.taskTextLabel setNumberOfLines:0];
    [self.taskTextLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [self.taskTextLabel setTextColor:[UIColor blackColor]];

    [self.mainView addSubview:self.taskTextLabel];
}

- (void)setupSeparators
{
    self.topSeparator = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 0.25f)];
    [self.topSeparator setBackgroundColor:[UIColor lightPlumGrayColor]];


    self.bottomSeparator = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 0.25f, self.frame.size.width, 0.25f)];
    [self.bottomSeparator setBackgroundColor:[UIColor lightPlumGrayColor]];

    [self.mainView addSubview:self.topSeparator];
    [self.mainView addSubview:self.bottomSeparator];
}

- (void)setText:(NSString *)text
{
    [self.taskTextLabel setText:text];

    CGSize textSize = [MRMainCollectionViewCell sizeForTaskTextLabelWithText:text];
    [self.taskTextLabel setFrame:CGRectMake(kMRMainCollectionViewCellHorizontalPadding, 35.0f, textSize.width, textSize.height)];
}

- (void)setDueDate:(NSDate *)dueDate
{
    self.initialDueDate = dueDate;
    [self.dueDateLabel setText:self.initialDueDate.tackleString];
}

- (void)markAsDone
{
    [self.delegate markAsDone:self];
}

+ (CGSize)sizeForTaskTextLabelWithText:(NSString *)text
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];

    UIFont *font = [UIFont effraLightWithSize:16.0f];

    NSDictionary *attributes = @{NSFontAttributeName:font,
                                 NSParagraphStyleAttributeName:paragraphStyle};

    CGRect rect = [text boundingRectWithSize:CGSizeMake(300.0f, MAXFLOAT)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:attributes
                                     context:nil];

    return CGSizeMake(rect.size.width, rect.size.height);
}

- (void)addShadow
{
    if (!self.hasShadow) {
        [self.superview bringSubviewToFront:self];
        self.shadow = YES;

        self.mainView.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.mainView.bounds].CGPath;
        self.mainView.layer.masksToBounds = NO;
        self.mainView.layer.shadowOffset = CGSizeMake(0, 0);
        self.mainView.layer.shadowRadius = 3;

        [UIView animateWithDuration:0.2 animations:^{
            self.mainView.layer.shadowOpacity = 0.5;
        }];
    }
}

- (void)removeShadow
{
    if (self.hasShadow) {
        self.shadow = NO;

        [UIView animateWithDuration:0.2 animations:^{
            self.mainView.layer.masksToBounds = YES;
            self.mainView.layer.shadowOpacity = 0.0;
        }];
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (void)handleLongPressGesture:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (![self.delegate shouldHandleLongPressGesturesForCell:self]) {
        return;
    }

    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        self.longPressed = YES;
        [self addShadow];
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        self.longPressed = NO;
        [self removeShadow];

        [UIView animateWithDuration:0.2 animations:^{
            [self performUnhighlight];
        }];
    }
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)gestureRecognizer
{
    if (![self.delegate shouldHandlePanGesturesForCell:self]) {
        return;
    }

    static UIAttachmentBehavior *attachment;
    static CFAbsoluteTime lastTime;
    static CGFloat lastAngle;
    static CGFloat angularVelocity;

    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        [self addShadow];
        self.dragging = YES;
        [self.animator removeAllBehaviors];
        [self.superview bringSubviewToFront:self];

        CGPoint pointWithinAnimatedView = [gestureRecognizer locationInView:gestureRecognizer.view];
        UIOffset offset = UIOffsetMake(pointWithinAnimatedView.x - gestureRecognizer.view.bounds.size.width / 2.0, pointWithinAnimatedView.y - gestureRecognizer.view.bounds.size.height / 2.0);

        CGPoint anchor = [gestureRecognizer locationInView:gestureRecognizer.view.superview];

        attachment = [[UIAttachmentBehavior alloc] initWithItem:gestureRecognizer.view
                                               offsetFromCenter:offset
                                               attachedToAnchor:anchor];

        lastTime = CFAbsoluteTimeGetCurrent();
        lastAngle = gestureRecognizer.view.angleOfView;

        attachment.action = ^{
            CFAbsoluteTime time = CFAbsoluteTimeGetCurrent();
            CGFloat angle = gestureRecognizer.view.angleOfView;
            if (time > lastTime) {
                angularVelocity = (angle - lastAngle) / (time - lastTime);
                lastTime = time;
                lastAngle = angle;
            }
        };

        [self.animator addBehavior:attachment];
        [self performHighlight];
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        [self performHighlight];
        CGPoint anchor = [gestureRecognizer locationInView:gestureRecognizer.view.superview];
        attachment.anchorPoint = anchor;
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        self.dragging = NO;
        [self.animator removeAllBehaviors];

        CGPoint velocity = [gestureRecognizer velocityInView:gestureRecognizer.view.superview];
        CGFloat maxVelocity = MAX(fabs(velocity.x), fabs(velocity.y));

        if (maxVelocity < 825) {
            UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:gestureRecognizer.view snapToPoint:self.startCenter];
            [self.animator addBehavior:snap];

            [UIView animateWithDuration:0.2 animations:^{
                [self performUnhighlight];
                [self removeShadow];
            }];

            return;
        }

        UIDynamicItemBehavior *dynamic = [[UIDynamicItemBehavior alloc] initWithItems:@[gestureRecognizer.view]];
        [dynamic addLinearVelocity:velocity forItem:gestureRecognizer.view];
        [dynamic addAngularVelocity:angularVelocity forItem:gestureRecognizer.view];
        [dynamic setAngularResistance:2];

        dynamic.action = ^{
            CGPoint point = [self.superview convertPoint:gestureRecognizer.view.frame.origin fromView:self];
            CGRect relativeBounds = CGRectMake(point.x, point.y, gestureRecognizer.view.frame.size.width, gestureRecognizer.view.frame.size.height);

            if (!CGRectIntersectsRect(self.superview.bounds, relativeBounds)) {
                [self.animator removeAllBehaviors];
                [self markAsDone];
            }
        };

        [self.animator addBehavior:dynamic];

        UIGravityBehavior *gravity = [[UIGravityBehavior alloc] initWithItems:@[gestureRecognizer.view]];
        gravity.magnitude = 0.7;
        [self.animator addBehavior:gravity];
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)recognizer {
    if ([recognizer isEqual:self.panGestureRecognizer]) {
        UIPanGestureRecognizer *panRecognizer = (UIPanGestureRecognizer *)recognizer;
        CGPoint velocity = [panRecognizer velocityInView:self];
        return self.isLongPressed || ABS(velocity.x) > ABS(velocity.y);
    }
    else {
        return YES;
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]]) {
        return YES;
    }

    return NO;
}

@end
