//
//  MRMainCollectionViewCell.h
//  Tackle
//
//  Created by Scott Bader on 1/27/14.
//  Copyright (c) 2014 Melody Road. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MRMainCollectionViewCellDelegate;

@interface MRMainCollectionViewCell : UICollectionViewCell <UIGestureRecognizerDelegate>

@property (assign, nonatomic) id <MRMainCollectionViewCellDelegate> delegate;

@property (strong, nonatomic) UILabel *taskTextLabel;
@property (strong, nonatomic) UILabel *dueDateLabel;

+ (CGSize)sizeForTaskTextLabelWithText:(NSString *)text;\
- (void)setText:(NSString *)text;
- (void)setDueDate:(NSDate *)dueDate;
- (void)performSelection;
- (void)performDeselection;
- (void)updateSizing;
- (void)decrementDate;

@end

@protocol MRMainCollectionViewCellDelegate <NSObject>

@required

- (void)markAsDone:(MRMainCollectionViewCell *)cell;
- (BOOL)shouldHandlePanGesturesForCell:(MRMainCollectionViewCell *)cell;

@end
