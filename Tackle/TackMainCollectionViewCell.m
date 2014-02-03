//
//  TackMainCollectionViewCell.m
//  Tackle
//
//  Created by Scott Bader on 1/27/14.
//  Copyright (c) 2014 Melody Road. All rights reserved.
//

#import "TackMainCollectionViewCell.h"

#import "TackDateFormatter.h"
#import <QuartzCore/QuartzCore.h>

@interface TackMainCollectionViewCell ()

@property (strong, nonatomic) UIView *mainView;

@property (strong, nonatomic) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) UIGravityBehavior *gravityBehaviour;
@property (nonatomic, strong) UIPushBehavior* pushBehavior;
@property (nonatomic, strong) UIAttachmentBehavior *panAttachmentBehaviour;

@end

@implementation TackMainCollectionViewCell

@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor darkPlumColor]];

        [self setupMainView];
        [self setupPanGestureRecognizer];
        [self setupAnimator];
        [self setupDueDateLabel];
        [self setupTaskTextLabel];
        [self setupBottomSeparator];
    }
    return self;
}

- (void)prepareForReuse
{
    [self.mainView setTransform:CGAffineTransformIdentity];
    [self.mainView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}

- (void)setupMainView
{
    self.mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self.mainView setBackgroundColor:[UIColor lightPlumColor]];
    [self.contentView addSubview:self.mainView];
}

- (void)setupPanGestureRecognizer
{
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [self.panGestureRecognizer setDelegate:self];
    [self.mainView addGestureRecognizer:self.panGestureRecognizer];
}

- (void)setupAnimator
{
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
}

- (void)setupDueDateLabel
{
    self.dueDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(6.0f, 10.0f, 234.0f, 21.0f)];
    [self.dueDateLabel setFont:[UIFont effraRegularWithSize:18.0f]];
    [self.dueDateLabel setTextColor:[UIColor blackColor]];

    [self.mainView addSubview:self.dueDateLabel];
}

- (void)setupTaskTextLabel
{
    self.taskTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(6.0f, 35.0f, 300.0f, 21.0f)];

    [self.taskTextLabel setFont:[UIFont effraRegularWithSize:15.0f]];
    [self.taskTextLabel setNumberOfLines:0];
    [self.taskTextLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [self.taskTextLabel setTextColor:[UIColor blackColor]];

    [self.mainView addSubview:self.taskTextLabel];
}

- (void)setupBottomSeparator
{
    UIView *bottomSeparator = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 0.5f, self.frame.size.width, 0.5f)];
    [bottomSeparator setBackgroundColor:[UIColor lightPlumGrayColor]];

    [self.mainView addSubview:bottomSeparator];
}

- (void)setText:(NSString *)text
{
    [self.taskTextLabel setText:text];

    CGSize textSize = [TackMainCollectionViewCell sizeForTaskTextLabelWithText:text];
    [self.taskTextLabel setFrame:CGRectMake(6, 35, textSize.width, textSize.height)];
}

- (void)setDueDate:(NSDate *)dueDate
{
    [self.dueDateLabel setText:[[TackDateFormatter sharedInstance] stringFromDate:dueDate]];
}

- (void)markAsDone
{
    [self.delegate markAsDone:self];
}

+ (CGSize)sizeForTaskTextLabelWithText:(NSString *)text
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];

    UIFont *font = [UIFont effraRegularWithSize:15.0f];

    NSDictionary *attributes = @{NSFontAttributeName:[font fontWithSize:15.0f],
                                 NSParagraphStyleAttributeName:paragraphStyle};

    CGRect rect = [text boundingRectWithSize:CGSizeMake(300.0f, MAXFLOAT)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:attributes
                                     context:nil];

    return CGSizeMake(rect.size.width, rect.size.height);
}

#pragma mark - UIGestureRecognizerDelegate

- (void)handlePanGesture:(UIPanGestureRecognizer *)gestureRecognizer
{
    if (![self.delegate shouldHandlePanGesturesForCell:self]) {
        return;
    }

    static UIAttachmentBehavior *attachment;
    static CGPoint startCenter;
    static CFAbsoluteTime lastTime;
    static CGFloat lastAngle;
    static CGFloat angularVelocity;

    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        [self.animator removeAllBehaviors];
        [self.superview bringSubviewToFront:self];

        startCenter = gestureRecognizer.view.center;
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
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint anchor = [gestureRecognizer locationInView:gestureRecognizer.view.superview];
        attachment.anchorPoint = anchor;
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        [self.animator removeAllBehaviors];

        CGPoint velocity = [gestureRecognizer velocityInView:gestureRecognizer.view.superview];
        CGFloat maxVelocity = MAX(fabs(velocity.x), fabs(velocity.y));

        if (maxVelocity < 825) {
            UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:gestureRecognizer.view snapToPoint:startCenter];
            [self.animator addBehavior:snap];

            return;
        }

        //        if (fabs(atan2(velocity.y, velocity.x) - M_PI_2) > M_PI_4) {
        //            UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:gestureRecognizer.view snapToPoint:startCenter];
        //            [self.animator addBehavior:snap];
        //
        //            return;
        //        }

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
        return ABS(velocity.x) > ABS(velocity.y);
    } else {
        return YES;
    }
}

@end
