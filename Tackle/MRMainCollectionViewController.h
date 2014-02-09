//
//  MRMainCollectionViewController.h
//  Tackle
//
//  Created by Scott Bader on 1/27/14.
//  Copyright (c) 2014 Melody Road. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Task.h"
#import "MRMainCollectionViewCell.h"

@protocol MRMainCollectionViewScrollViewDelegate;
@protocol MRMainCollectionViewSelectionDelegate;

@interface MRMainCollectionViewController : UICollectionViewController <UICollectionViewDelegate, NSFetchedResultsControllerDelegate, UITextFieldDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, MRMainCollectionViewCellDelegate>

@property (assign, nonatomic) id <MRMainCollectionViewScrollViewDelegate> scrollViewDelegate;
@property (assign, nonatomic) id <MRMainCollectionViewSelectionDelegate> selectionDelegate;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (void)resetContentOffset;
- (void)selectTask:(Task *)task;
- (void)moveToBack;
- (void)moveToFront;

@end

@protocol MRMainCollectionViewScrollViewDelegate <NSObject>

@optional

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset;
- (void)scrollViewDidInsetContent:(UIScrollView *)scrollView;
- (void)scrollViewDidResetContent:(UIScrollView *)scrollView;

@end

@protocol MRMainCollectionViewSelectionDelegate <NSObject>

@optional

- (void)didSelectCellWithTask:(Task *)task;

@end
