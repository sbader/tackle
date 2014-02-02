//
//  TackMainCollectionViewController.h
//  Tackle
//
//  Created by Scott Bader on 1/27/14.
//  Copyright (c) 2014 Melody Road. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TackMainCollectionViewScrollViewDelegate;

@interface TackMainCollectionViewController : UICollectionViewController <NSFetchedResultsControllerDelegate, UITextFieldDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>

@property (assign, nonatomic) id <TackMainCollectionViewScrollViewDelegate> scrollViewDelegate;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (void)resetContentOffset;

@end

@protocol TackMainCollectionViewScrollViewDelegate <NSObject>

@optional

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset;
- (void)scrollViewDidInsetContent:(UIScrollView *)scrollView;

@end
