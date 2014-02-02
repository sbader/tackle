//
//  TackMainCollectionViewController.m
//  Tackle
//
//  Created by Scott Bader on 1/27/14.
//  Copyright (c) 2014 Melody Road. All rights reserved.
//

#import "TackMainCollectionViewController.h"

#import "TackMainCollectionViewCell.h"
#import "TackDateFormatter.h"
#import "Task.h"

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
    [self.collectionView setAlwaysBounceVertical:YES];
    [self.collectionView setBackgroundColor:[UIColor darkPlumColor]];
    [self.collectionView registerClass:[TackMainCollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    [self.collectionView setPagingEnabled:NO];
    [self.collectionView setKeyboardDismissMode:UIScrollViewKeyboardDismissModeOnDrag];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    Task *task = [self.fetchedResultsController objectAtIndexPath:indexPath];

    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];

    UIFont *font = [UIFont effraRegularWithSize:15.0f];

    NSDictionary *attributes = @{NSFontAttributeName:[font fontWithSize:15.0f],
                                 NSParagraphStyleAttributeName:paragraphStyle};

    CGRect rect = [task.text boundingRectWithSize:CGSizeMake(300.0f, MAXFLOAT)
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:attributes
                                          context:nil];

    CGFloat height = ceil(rect.size.height) + 46;

    return CGSizeMake(self.view.frame.size.width, height);
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
            [collectionView deleteItemsAtIndexPaths:@[newIndexPath]];
            break;

        case NSFetchedResultsChangeUpdate:
//            [self updateCell:(TackMainTableViewCell *)[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;

        case NSFetchedResultsChangeMove:
            [collectionView deleteItemsAtIndexPaths:@[indexPath]];
            [collectionView insertItemsAtIndexPaths:@[newIndexPath]];
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
        [self.collectionView setContentInset:UIEdgeInsetsMake(0, 0, 20, 0)];
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

        [scrollView setShowsVerticalScrollIndicator:NO];

        [UIView animateWithDuration:0.2 animations:^{
            [scrollView setContentInset:UIEdgeInsetsMake(100, 0, 20, 0)];
        } completion:^(BOOL finished) {
            if ([self.scrollViewDelegate respondsToSelector:@selector(scrollViewDidInsetContent:)]) {
                [self.scrollViewDelegate scrollViewDidInsetContent:self.collectionView];
            }
        }];
    }
    else if (scrollView.contentInset.top == 100 && scrollView.contentOffset.y > -100) {
        targetContentOffset->y = (scrollView.contentOffset.y > 0) ? scrollView.contentOffset.y : 0;

        [scrollView setShowsVerticalScrollIndicator:YES];

        [UIView animateWithDuration:0.2 animations:^{
            [scrollView setContentInset:UIEdgeInsetsMake(0, 0, 20, 0)];
        }];
    }
}

@end
