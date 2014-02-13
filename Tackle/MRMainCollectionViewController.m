//
//  MRMainCollectionViewController.m
//  Tackle
//
//  Created by Scott Bader on 1/27/14.
//  Copyright (c) 2014 Melody Road. All rights reserved.
//

#import "MRMainCollectionViewController.h"

#import "MRLongDateFormatter.h"
#import "MRHeartbeat.h"

const CGFloat kMRMainCollectionViewVerticalCenterStart = 274.0f;
const CGFloat kMRMainCollectionViewVerticalCenterEnd = 364.0f;

@interface MRMainCollectionViewController ()

@property (nonatomic, strong) UIMotionEffectGroup *effectGroup;
@property (nonatomic, getter = isInset) BOOL inset;
@property (nonatomic, strong) UIPanGestureRecognizer *gestureRecognizer;
@property (nonatomic) CGPoint startTouchPoint;

- (void)updateCell:(MRMainCollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end

@implementation MRMainCollectionViewController

- (id)initWithCollectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithCollectionViewLayout:layout];
    if (self) {
        self.inset = NO;

        [self.collectionView setRestorationIdentifier:@"CollectionView"];
        [self.collectionView setAlwaysBounceVertical:YES];
        [self.collectionView setBackgroundColor:[UIColor darkPlumColor]];
        [self.collectionView registerClass:[MRMainCollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
        [self.collectionView setPagingEnabled:NO];
        [self.collectionView setKeyboardDismissMode:UIScrollViewKeyboardDismissModeOnDrag];
        [self.collectionView setShowsVerticalScrollIndicator:NO];
        [self setupMotion];
        [self setupGestureRecognizer];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self attachObservers];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self detachObservers];
}

- (void)attachObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(heartDidBeat) name:[MRHeartbeat slowHeartbeatId] object:nil];
}

- (void)detachObservers
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:[MRHeartbeat heartbeatId] object:nil];
}

- (void)heartDidBeat
{
    [self.collectionView.visibleCells enumerateObjectsUsingBlock:^(MRMainCollectionViewCell *cell, NSUInteger idx, BOOL *stop) {
        [cell decrementDate];
    }];
}

- (void)setupGestureRecognizer
{
    self.gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [self.gestureRecognizer setDelegate:self];
    [self.view addGestureRecognizer:self.gestureRecognizer];
}


- (void)setupMotion
{
    UIInterpolatingMotionEffect *verticalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];

    verticalMotionEffect.minimumRelativeValue = @(-20);
    verticalMotionEffect.maximumRelativeValue = @(20);

    UIInterpolatingMotionEffect *horizontalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];

    horizontalMotionEffect.minimumRelativeValue = @(-20);
    horizontalMotionEffect.maximumRelativeValue = @(20);

    self.effectGroup = [UIMotionEffectGroup new];
    self.effectGroup.motionEffects = @[horizontalMotionEffect, verticalMotionEffect];
}

- (void)addMotionEffects
{
    [self.collectionView addMotionEffect:self.effectGroup];
}

- (void)removeMotionEffects
{
    [self.collectionView removeMotionEffect:self.effectGroup];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    Task *task = [self.fetchedResultsController objectAtIndexPath:indexPath];

    CGSize textSize = [MRMainCollectionViewCell sizeForTaskTextLabelWithText:task.text];

    CGFloat height = ceil(textSize.height) + (2 * kMRMainCollectionViewCellVerticalPadding) + 26;

    return CGSizeMake(self.collectionView.frame.size.width, height);
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MRMainCollectionViewCell *cell = (MRMainCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    [cell performDeselection];
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return !self.isInset;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.isInset) {
        MRMainCollectionViewCell *cell = (MRMainCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        [cell performSelection];

        Task *task = [self.fetchedResultsController objectAtIndexPath:indexPath];
        if ([self.selectionDelegate respondsToSelector:@selector(didSelectCellWithTask:)]) {
            [self.selectionDelegate didSelectCellWithTask:task];
        }
    }
}

- (void)moveToBack
{
    CALayer *layer = self.collectionView.layer;
    CGFloat scale = 0.9;
    [layer setTransform:CATransform3DMakeScale(scale, scale, 1)];

    CGPoint center = self.view.center;
    center.y = kMRMainCollectionViewVerticalCenterEnd;
    [self.collectionView setCenter:center];

    [self addMotionEffects];
    self.inset = YES;
}

- (void)moveToFront
{
    self.inset = NO;
    [self removeMotionEffects];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MRMainCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    [cell setDelegate:self];
    [self updateCell:cell atIndexPath:indexPath];

    return cell;
}

- (void)updateCell:(MRMainCollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Task *task = [self.fetchedResultsController objectAtIndexPath:indexPath];

    [cell setText:task.text];
    [cell setDueDate:task.dueDate];
    [cell updateSizing];
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Task" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];

    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];

    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dueDate" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];

    [fetchRequest setSortDescriptors:sortDescriptors];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"isDone == NO"]];

    //    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;

	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}

    return _fetchedResultsController;
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{

    UICollectionView *collectionView = self.collectionView;

    switch(type) {
        case NSFetchedResultsChangeInsert:
            [collectionView insertItemsAtIndexPaths:@[newIndexPath]];
            break;

        case NSFetchedResultsChangeDelete:
            [collectionView deleteItemsAtIndexPaths:@[indexPath]];
            break;

        case NSFetchedResultsChangeUpdate:
            [self updateCell:(MRMainCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath] atIndexPath:indexPath];
            break;

        case NSFetchedResultsChangeMove:
            [collectionView moveItemAtIndexPath:indexPath toIndexPath:newIndexPath];
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)resetContentOffsetWithAnimations:(void(^)(void))animations completions:(void(^)(void))completions
{
    [UIView animateWithDuration:0.2 animations:^{
        if (self.collectionView.contentInset.top != 0) {
            [self.collectionView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
            [self.collectionView setContentOffset:CGPointZero];
        }
        else {
            if (self.collectionView.center.y != kMRMainCollectionViewVerticalCenterStart) {
                CGPoint center = self.collectionView.center;
                center.y = kMRMainCollectionViewVerticalCenterStart;
                [self.collectionView setCenter:center];
            }

            CALayer *layer = self.collectionView.layer;
            CATransform3D transform = CATransform3DMakeScale(1, 1, 1);

            if (!CATransform3DEqualToTransform(layer.transform, transform)) {
                [layer setTransform:transform];
            }

            [self deselectSelectedCells];

            animations();
        }
    } completion:^(BOOL finished) {
        completions();

        [self.collectionView setScrollEnabled:YES];
        self.inset = NO;
        [self removeMotionEffects];
    }];
}

- (void)deselectSelectedCells
{
    [[self.collectionView indexPathsForSelectedItems] enumerateObjectsUsingBlock:^(NSIndexPath *indexPath, NSUInteger idx, BOOL *stop) {
        MRMainCollectionViewCell *cell = (MRMainCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        [cell performDeselection];
    }];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!self.collectionView.scrollEnabled && self.isInset && self.collectionView.contentOffset.y == -100) {
        [self.collectionView setScrollEnabled:YES];
    }

    if ([self.scrollViewDelegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [self.scrollViewDelegate scrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (!self.isInset && scrollView.contentOffset.y <= -100) {
        targetContentOffset->y = -100;

        self.inset = YES;
        [UIView animateWithDuration:0.2 animations:^{
            [scrollView setContentInset:UIEdgeInsetsMake(100, 0, 0, 0)];
        } completion:^(BOOL finished) {
            if ([self.scrollViewDelegate respondsToSelector:@selector(scrollViewDidInsetContent:)]) {
                [self.scrollViewDelegate scrollViewDidInsetContent:self.collectionView];
            }

            [self addMotionEffects];
        }];
    }
    else if (self.isInset && scrollView.contentOffset.y > -100) {
        targetContentOffset->y = (scrollView.contentOffset.y > 0) ? scrollView.contentOffset.y : 0;

        self.inset = NO;
        [UIView animateWithDuration:0.2 animations:^{
            [scrollView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];

            [self deselectSelectedCells];
        } completion:^(BOOL finished) {
            if ([self.scrollViewDelegate respondsToSelector:@selector(scrollViewDidResetContent:)]) {
                [self.scrollViewDelegate scrollViewDidResetContent:self.collectionView];
            }
            [self removeMotionEffects];
        }];
    }
}

#pragma mark - MRMainCollectionViewCellDelegate

- (void)markAsDone:(MRMainCollectionViewCell *)cell
{
    Task *task = [self.fetchedResultsController objectAtIndexPath:[self.collectionView indexPathForCell:cell]];
    [task setIsDone:YES];
    [task cancelNotification];

    __block NSError *error;
    [task.managedObjectContext performBlock:^{
        [task.managedObjectContext save:&error];
    }];
}

- (BOOL)shouldHandlePanGesturesForCell:(MRMainCollectionViewCell *)cell
{
    return !self.isInset;
}

- (void)selectTask:(Task *)task
{
    NSIndexPath *indexPath = [self.fetchedResultsController indexPathForObject:task];
    MRMainCollectionViewCell *cell = (MRMainCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    [cell performSelection];
}

#pragma mark - UIGestureRecognizerDelegate

- (void)handlePanGesture:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGPoint touchPoint = [gestureRecognizer locationInView:gestureRecognizer.view];

    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        self.startTouchPoint = touchPoint;
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGFloat verticalOffset = self.startTouchPoint.y - touchPoint.y;
        CGFloat relativeOffset = verticalOffset * 2.1f;
        CGFloat offsetY = 20.0f - relativeOffset;

        [self.panGestureDelegate panGestureDidPanWithVerticalOffset:offsetY];

        CGFloat scaleMultiplier = 0.1f/210.0f; /* 0.000476 */
        CGFloat scale = 0.9;

        if (offsetY <= 20) {
            CGFloat calculatedScale = 0.9f + ((20.0f - offsetY) * scaleMultiplier);
            scale = MIN(calculatedScale, 1);
        }

        CGFloat centerY = kMRMainCollectionViewVerticalCenterEnd;

        if (verticalOffset > 0 && verticalOffset <= 100) {
            CGFloat topMultiplier = (kMRMainCollectionViewVerticalCenterEnd - kMRMainCollectionViewVerticalCenterStart)/210.0f;
            centerY = kMRMainCollectionViewVerticalCenterEnd - ((20.0f - offsetY) * topMultiplier);
        }
        else if (verticalOffset > 100) {
            centerY = kMRMainCollectionViewVerticalCenterStart;
        }

        CGPoint center = self.collectionView.center;
        if (centerY != center.y) {
            center.y = centerY;
            [self.collectionView setCenter:center];
        }

        CALayer *layer = self.collectionView.layer;
        CATransform3D transform = CATransform3DMakeScale(scale, scale, 1);

        if (!CATransform3DEqualToTransform(layer.transform, transform)) {
            [layer setTransform:transform];
        }
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint velocity = [gestureRecognizer velocityInView:gestureRecognizer.view];
        CALayer *layer = self.collectionView.layer;
        CGFloat scale = 0.9;
        CGFloat endPosition = 20;
        CGFloat centerY = kMRMainCollectionViewVerticalCenterEnd;

        BOOL done = NO;

        CGFloat verticalOffset = self.startTouchPoint.y - touchPoint.y;

        if (velocity.y < -30 || verticalOffset > 40) {
            scale = 1;
            endPosition = -190;
            done = YES;
            centerY = kMRMainCollectionViewVerticalCenterStart;
        }

        [UIView animateWithDuration:0.2 animations:^{
            [layer setTransform:CATransform3DMakeScale(scale, scale, 1)];
            [self.panGestureDelegate panGestureDidPanWithVerticalOffset:endPosition];

            if (done) {
                [self.panGestureDelegate panGestureWillReachEnd];
            }

            CGPoint center = self.collectionView.center;
            center.y = centerY;
            [self.collectionView setCenter:center];
        } completion:^(BOOL finished) {
            [self.collectionView setScrollEnabled:done];

            if (done) {
                [self moveToFront];
                [self.panGestureDelegate panGestureDidReachEnd];
            }
        }];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return self.isInset;
}

@end
