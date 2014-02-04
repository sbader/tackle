//
//  TackMainCollectionViewCell.h
//  Tackle
//
//  Created by Scott Bader on 1/27/14.
//  Copyright (c) 2014 Melody Road. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TackMainCollectionViewCellDelegate;

@interface TackMainCollectionViewCell : UICollectionViewCell <UIGestureRecognizerDelegate>

@property (assign, nonatomic) id <TackMainCollectionViewCellDelegate> delegate;

@property (strong, nonatomic) UILabel *taskTextLabel;
@property (strong, nonatomic) UILabel *dueDateLabel;

+ (CGSize)sizeForTaskTextLabelWithText:(NSString *)text;\
- (void)setText:(NSString *)text;
- (void)setDueDate:(NSDate *)dueDate;
- (void)performSelection;
- (void)performDeselection;

@end

@protocol TackMainCollectionViewCellDelegate <NSObject>

@required

- (void)markAsDone:(TackMainCollectionViewCell *)cell;
- (BOOL)shouldHandlePanGesturesForCell:(TackMainCollectionViewCell *)cell;

@end
