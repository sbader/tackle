//
//  MRAddTimeTableViewCell.m
//  Tackle
//
//  Created by Scott Bader on 12/28/14.
//  Copyright (c) 2014 Melody Road. All rights reserved.
//

#import "MRAddTimeTableViewCell.h"

@implementation MRAddTimeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];

    if (self) {
//        self.layoutMargins = UIEdgeInsetsZero;
//        self.preservesSuperviewLayoutMargins = NO;

        self.textLabel.textColor = [UIColor plumTintColor];
        self.textLabel.numberOfLines = 1;
        self.backgroundColor = [UIColor offWhiteBackgroundColor];
        self.textLabel.font = [UIFont effraRegularWithSize:20.0];

        [self setupConstraints];
    }

    return self;
}

- (void)setupConstraints {
    self.textLabel.translatesAutoresizingMaskIntoConstraints = NO;

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
