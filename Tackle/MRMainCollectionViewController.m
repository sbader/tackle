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

@interface MRMainCollectionViewController ()

@property (nonatomic, strong) UIMotionEffectGroup *effectGroup;
@property (nonatomic, getter = isInset) BOOL inset;

- (void)updateCell:(MRMainCollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end

@implementation MRMainCollectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.inset = NO;

    [self.collectionView setRestorationIdentifier:@"CollectionView"];
    [self.collectionView setAlwaysBounceVertical:YES];
    [self.collectionView setBackgroundColor:[UIColor darkPlumColor]];
    [self.collectionView registerClass:[MRMainCollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    [self.collectionView setPagingEnabled:NO];
    [self.collectionView setKeyboardDismissMode:UIScrollViewKeyboardDismissModeOnDrag];
    [self.collectionView setShowsVerticalScrollIndicator:NO];
    [self attachObservers];
    [self setupMotion];
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

    CGFloat height = ceil(textSize.height) + 46;

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
    CALayer *layer = self.view.layer;
    CGFloat scale = 0.9;
    [layer setTransform:CATransform3DMakeScale(scale, scale, 1)];

    CGPoint center = self.view.center;
    center.y = center.y + 90.0f; // 384
    [self.view setCenter:center];

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

- (void)resetContentOffset
{
    [UIView animateWithDuration:0.2 animations:^{
        [self.collectionView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        [self.collectionView setContentOffset:CGPointZero];
    } completion:^(BOOL finished) {
        [self removeMotionEffects];
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

            NSArray *indexPaths = [self.collectionView indexPathsForSelectedItems];
            if ([indexPaths count] == 1) {
                MRMainCollectionViewCell *cell = (MRMainCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPaths[0]];
                [cell performDeselection];
            }
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
    if (self.collectionView.contentInset.top != 100) {
        return YES;
    }
    else {
        return NO;
    }
}

- (void)selectTask:(Task *)task
{
    NSIndexPath *indexPath = [self.fetchedResultsController indexPathForObject:task];
    MRMainCollectionViewCell *cell = (MRMainCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    [cell performSelection];
}

@end
