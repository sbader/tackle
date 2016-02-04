//
//  MRTaskArchiveTableViewCell.m
//  Tackle
//
//  Created by Scott Bader on 2/4/16.
//  Copyright © 2016 Melody Road. All rights reserved.
//

#import "MRTaskArchiveTableViewCell.h"

@implementation MRTaskArchiveTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];

    if (self) {
        self.layoutMargins = UIEdgeInsetsZero;
        self.preservesSuperviewLayoutMargins = NO;

        self.textLabel.numberOfLines = 0;
        self.textLabel.lineBreakMode = NSLineBreakByWordWrapping;

        self.detailTextLabel.numberOfLines = 1;

        self.backgroundColor = [UIColor offWhiteBackgroundColor];

        self.textLabel.textColor = [UIColor grayTextColor];
        self.textLabel.font = [UIFont fontForTableViewTextLabel];

        self.detailTextLabel.textColor = [UIColor grayTextColor];
        self.detailTextLabel.font = [UIFont fontForTableViewDetailLabel];

        [self setupConstraints];
    }

    return self;
}

- (void)setupConstraints {
    self.textLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.detailTextLabel.translatesAutoresizingMaskIntoConstraints = NO;

    [self.textLabel leadingConstraintMatchesView:self.contentView withConstant:20.0];
    [self.textLabel trailingConstraintMatchesView:self.contentView withConstant:-20.0];
    [self.detailTextLabel leadingConstraintMatchesView:self.contentView withConstant:20.0];
    [self.detailTextLabel trailingConstraintMatchesView:self.contentView withConstant:-20.0];
    [self.textLabel topConstraintMatchesView:self.contentView withConstant:14.0];

    [self.detailTextLabel addConstraintEqualToView:self.textLabel
                                       inContainer:self.contentView
                                     withAttribute:NSLayoutAttributeTop
                                  relatedAttribute:NSLayoutAttributeBottom
                                        multiplier:1.0
                                          constant:2.0];

    [self.detailTextLabel bottomConstraintMatchesView:self.contentView withConstant:-14.0];
}


@end
