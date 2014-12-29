//
//  MRTaskTableViewCell.m
//  Tackle
//
//  Created by Scott Bader on 12/27/14.
//  Copyright (c) 2014 Melody Road. All rights reserved.
//

#import "MRTaskTableViewCell.h"

@implementation MRTaskTableViewCell

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
        self.textLabel.font = [UIFont effraRegularWithSize:20.0];
    
        self.detailTextLabel.textColor = [UIColor grayTextColor];
        self.detailTextLabel.font = [UIFont effraLightWithSize:14.0];

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
                                              @"detail.leading = view.leading + horizontalPadding",
                                              @"detail.trailing = view.trailing - horizontalPadding",
                                              @"text.top = view.top + verticalPadding",
                                              @"detail.top = text.bottom + spacing",
                                              @"detail.bottom = view.bottom - verticalPadding",
                                              ]
                                    metrics:@{
                                              @"horizontalPadding": @(20),
                                              @"verticalPadding": @(8),
                                              @"spacing": @(5)
                                              }
                                      views:@{
                                              @"text": self.textLabel,
                                              @"detail": self.detailTextLabel,
                                              @"view": self.contentView
                                              }];
}

@end
