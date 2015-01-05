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

    [self.contentView addCompactConstraints:@[
                                              @"text.leading = view.leading + horizontalPadding",
                                              @"text.trailing = view.trailing - horizontalPadding",
                                              @"text.top = view.top + verticalPadding",
                                              @"text.bottom = view.bottom - verticalPadding",
                                              ]
                                    metrics:@{
                                              @"horizontalPadding": @(20),
                                              @"verticalPadding": @(10),
                                              }
                                      views:@{
                                              @"text": self.textLabel,
                                              @"view": self.contentView
                                              }];
}

@end
