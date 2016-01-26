//
//  MRPreviousTaskTableViewCell.m
//  Tackle
//
//  Created by Scott Bader on 1/4/15.
//  Copyright (c) 2015 Melody Road. All rights reserved.
//

#import "MRPreviousTaskTableViewCell.h"

@implementation MRPreviousTaskTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];

    if (self) {
        self.textLabel.textColor = [UIColor plumTintColor];
        self.textLabel.numberOfLines = 0;
        self.backgroundColor = [UIColor offWhiteBackgroundColor];
        self.textLabel.font = [UIFont fontForFormTableViewCellTextLabel];

        [self setupConstraints];
    }

    return self;
}

- (void)setupConstraints {
    self.textLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.detailTextLabel.translatesAutoresizingMaskIntoConstraints = NO;

    [self.textLabel leadingConstraintMatchesView:self.contentView withConstant:20.0];
    [self.textLabel trailingConstraintMatchesView:self.contentView withConstant:-20.0];
    [self.textLabel topConstraintMatchesView:self.contentView withConstant:10.0];
    [self.textLabel bottomConstraintMatchesView:self.contentView withConstant:-10.0];
}

@end
