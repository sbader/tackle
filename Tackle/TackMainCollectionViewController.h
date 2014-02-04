//
//  TackMainCollectionViewController.h
//  Tackle
//
//  Created by Scott Bader on 1/27/14.
//  Copyright (c) 2014 Melody Road. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Task.h"
#import "TackMainCollectionViewCell.h"

@protocol TackMainCollectionViewScrollViewDelegate;
@protocol TackMainCollectionViewSelectionDelegate;

@interface TackMainCollectionViewController : UICollectionViewController <UICollectionViewDelegate, NSFetchedResultsControllerDelegate, UITextFieldDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, TackMainCollectionViewCellDelegate>

@property (assign, nonatomic) id <TackMainCollectionViewScrollViewDelegate> scrollViewDelegate;
@property (assign, nonatomic) id <TackMainCollectionViewSelectionDelegate> selectionDelegate;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (void)resetContentOffset;
- (void)selectTask:(Task *)task;

@end

@protocol TackMainCollectionViewScrollViewDelegate <NSObject>

@optional

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset;
- (void)scrollViewDidInsetContent:(UIScrollView *)scrollView;
- (void)scrollViewDidResetContent:(UIScrollView *)scrollView;

@end

@protocol TackMainCollectionViewSelectionDelegate <NSObject>

@optional

- (void)didSelectCellWithTask:(Task *)task;

@end
