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
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];

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
//    self.textLabel.translatesAutoresizingMaskIntoConstraints = NO;
//    self.detailTextLabel.translatesAutoresizingMaskIntoConstraints = NO;
//
//    [self.contentView addCompactConstraints:@[
//                                              @"text.leading = view.leading + horizontalPadding",
//                                              @"text.trailing = view.trailing - horizontalPadding",
//                                              @"detail.leading = view.leading + horizontalPadding",
//                                              @"detail.trailing = view.trailing - horizontalPadding",
//                                              @"text.top = view.top + verticalPadding",
//                                              @"detail.top = text.bottom + spacing",
//                                              @"detail.bottom = view.bottom - verticalPadding",
//                                              ]
//                                    metrics:@{
//                                              @"horizontalPadding": @(20),
//                                              @"verticalPadding": @(14),
//                                              @"spacing": @(2)
//                                              }
//                                      views:@{
//                                              @"text": self.textLabel,
//                                              @"detail": self.detailTextLabel,
//                                              @"view": self.contentView
//                                              }];
}

@end
