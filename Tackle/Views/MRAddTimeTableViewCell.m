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
        self.textLabel.textColor = [UIColor plumTintColor];
        self.textLabel.numberOfLines = 1;
        self.backgroundColor = [UIColor offWhiteBackgroundColor];
        self.textLabel.font = [UIFont fontForFormTableViewCellTextLabel];

        self.iconImageView = [[UIImageView alloc] init];
        self.iconImageView.translatesAutoresizingMaskIntoConstraints = NO;

        [self.contentView addSubview:self.iconImageView];


//        self.textLabel.ver

        [self setupConstraints];
    }

    return self;
}

- (void)setupConstraints {
    self.textLabel.translatesAutoresizingMaskIntoConstraints = NO;

    [self.contentView addCompactConstraints:@[
                                              @"text.top = view.top",
                                              @"text.bottom = view.bottom",
                                              @"text.leading = view.leading + horizontalPadding",
                                              @"image.leading = text.trailing + horizontalPadding",
                                              @"image.trailing = view.trailing - horizontalPadding",
                                              @"image.width = 30",
                                              @"image.height = 30",
                                              @"image.centerY = view.centerY",
//                                              @"text.top = view.top + 24",
//                                              @"text.bottom = view.bottom - 12",
                                              ]
                                    metrics:@{
                                              @"horizontalPadding": @(20),
                                              @"verticalPadding": @(10),
                                              }
                                      views:@{
                                              @"image": self.iconImageView,
                                              @"text": self.textLabel,
                                              @"view": self.contentView
                                              }];
}

@end
