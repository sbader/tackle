//
//  TackMainCollectionViewCell.h
//  Tackle
//
//  Created by Scott Bader on 1/27/14.
//  Copyright (c) 2014 Melody Road. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TackMainCollectionViewCellDelegate;

@interface TackMainCollectionViewCell : UICollectionViewCell

@property (assign, nonatomic) id <TackMainCollectionViewCellDelegate> delegate;

@property (strong, nonatomic) UILabel *taskTextLabel;
@property (strong, nonatomic) UILabel *dueDateLabel;

- (void)setText:(NSString *)text;
- (void)setDueDate:(NSDate *)dueDate;

@end

@protocol TackMainCollectionViewCellDelegate <NSObject>

@optional

- (void)markAsDone:(TackMainCollectionViewCell *)cell;

@end
