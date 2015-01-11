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

        [self.contentView staticHeightConstraint:50.0];
    }

    return self;
}

@end
