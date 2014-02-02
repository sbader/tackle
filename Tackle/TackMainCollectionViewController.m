//
//  TackMainCollectionViewController.m
//  Tackle
//
//  Created by Scott Bader on 1/27/14.
//  Copyright (c) 2014 Melody Road. All rights reserved.
//

#import "TackMainCollectionViewController.h"

#import "TackDateFormatter.h"

@interface TackMainCollectionViewController ()

- (void)updateCell:(TackMainCollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end

@implementation TackMainCollectionViewController

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
    [self.collectionView setRestorationIdentifier:@"CollectionView"];
    [self.collectionView setAlwaysBounceVertical:YES];
    [self.collectionView setBackgroundColor:[UIColor darkPlumColor]];
    [self.collectionView registerClass:[TackMainCollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    [self.collectionView setPagingEnabled:NO];
    [self.collectionView setKeyboardDismissMode:UIScrollViewKeyboardDismissModeOnDrag];
    [self.collectionView setShowsVerticalScrollIndicator:NO];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    Task *task = [self.fetchedResultsController objectAtIndexPath:indexPath];

    CGSize textSize = [TackMainCollectionViewCell sizeForTaskTextLabelWithText:task.text];

    CGFloat height = ceil(textSize.height) + 46;

    return CGSizeMake(self.view.frame.size.width, height);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.collectionView.contentInset.top != 100) {
        Task *task = [self.fetchedResultsController objectAtIndexPath:indexPath];
        if ([self.selectionDelegate respondsToSelector:@selector(didSelectCellWithTask:)]) {
            [self.selectionDelegate didSelectCellWithTask:task];
        }
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TackMainCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    [cell setDelegate:self];
    [self updateCell:cell atIndexPath:indexPath];

    return cell;
}

- (void)updateCell:(TackMainCollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Task *task = [self.fetchedResultsController objectAtIndexPath:indexPath];

    [cell setText:task.text];
    [cell setDueDate:task.dueDate];
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
            [self updateCell:(TackMainCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath] atIndexPath:indexPath];
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
    }];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([self.scrollViewDelegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [self.scrollViewDelegate scrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (scrollView.contentInset.top != 100 && scrollView.contentOffset.y <= -100) {
        targetContentOffset->y = -100;

        [UIView animateWithDuration:0.2 animations:^{
            [scrollView setContentInset:UIEdgeInsetsMake(100, 0, 0, 0)];
        } completion:^(BOOL finished) {
            if ([self.scrollViewDelegate respondsToSelector:@selector(scrollViewDidInsetContent:)]) {
                [self.scrollViewDelegate scrollViewDidInsetContent:self.collectionView];
            }
        }];
    }
    else if (scrollView.contentInset.top == 100 && scrollView.contentOffset.y > -100) {
        targetContentOffset->y = (scrollView.contentOffset.y > 0) ? scrollView.contentOffset.y : 0;

        [UIView animateWithDuration:0.2 animations:^{
            [scrollView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        } completion:^(BOOL finished) {
            if ([self.scrollViewDelegate respondsToSelector:@selector(scrollViewDidResetContent:)]) {
                [self.scrollViewDelegate scrollViewDidResetContent:self.collectionView];
            }
        }];
    }
}

#pragma mark - TackMainCollectionViewCellDelegate

- (void)markAsDone:(TackMainCollectionViewCell *)cell
{
    Task *task = [self.fetchedResultsController objectAtIndexPath:[self.collectionView indexPathForCell:cell]];
    [task setIsDone:YES];

    __block NSError *error;
    [task.managedObjectContext performBlock:^{
        [task.managedObjectContext save:&error];
    }];
}

@end
