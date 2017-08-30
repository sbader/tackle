//
//  MRTaskTableViewCell.m
//  Tackle
//
//  Created by Scott Bader on 12/27/14.
//  Copyright (c) 2014 Melody Road. All rights reserved.
//

#import "MRTaskTableViewCell.h"

@interface MRTaskTableViewCell()

@property UILabel *mrTitleLabel;
@property UILabel *mrDetailLabel;

@end

@implementation MRTaskTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        self.layoutMargins = UIEdgeInsetsZero;
        self.preservesSuperviewLayoutMargins = NO;

        self.mrTitleLabel = [[UILabel alloc] init];
        self.mrDetailLabel = [[UILabel alloc] init];

        self.mrTitleLabel.numberOfLines = 0;
        self.mrTitleLabel.lineBreakMode = NSLineBreakByWordWrapping;

        self.mrDetailLabel.numberOfLines = 1;

        self.backgroundColor = [UIColor offWhiteBackgroundColor];
    
        self.mrTitleLabel.textColor = [UIColor grayTextColor];
        self.mrTitleLabel.font = [UIFont fontForTableViewTextLabel];
    
        self.mrDetailLabel.textColor = [UIColor grayTextColor];
        self.mrDetailLabel.font = [UIFont fontForTableViewDetailLabel];

        [self.contentView addSubview:self.mrTitleLabel];
        [self.contentView addSubview:self.mrDetailLabel];

        [self setupConstraints];
    }

    return self;
}

- (void)updateTitle:(NSString *)title detail:(NSString *)detail {
    self.mrTitleLabel.text = title;
    self.mrDetailLabel.text = detail;
}

- (void)setupConstraints {
    self.mrTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.mrDetailLabel.translatesAutoresizingMaskIntoConstraints = NO;

    [self.mrTitleLabel leadingConstraintMatchesView:self.contentView withConstant:20.0];
    [self.mrTitleLabel trailingConstraintMatchesView:self.contentView withConstant:-20.0];
    [self.mrDetailLabel leadingConstraintMatchesView:self.contentView withConstant:20.0];
    [self.mrDetailLabel trailingConstraintMatchesView:self.contentView withConstant:-20.0];
    [self.mrTitleLabel topConstraintMatchesView:self.contentView withConstant:14.0];

    [self.mrDetailLabel addConstraintEqualToView:self.mrTitleLabel
                                       inContainer:self.contentView
                                     withAttribute:NSLayoutAttributeTop
                                  relatedAttribute:NSLayoutAttributeBottom
                                        multiplier:1.0
                                          constant:2.0];

    [self.mrDetailLabel bottomConstraintMatchesView:self.contentView withConstant:-14.0];
}

@end
