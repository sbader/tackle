//
//  TackMainCollectionViewCell.m
//  Tackle
//
//  Created by Scott Bader on 1/27/14.
//  Copyright (c) 2014 Melody Road. All rights reserved.
//

#import "TackMainCollectionViewCell.h"

#import "TackDateFormatter.h"
#import <QuartzCore/QuartzCore.h>

@implementation TackMainCollectionViewCell

@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor lightPlumColor]];

        [self setupDueDateLabel];
        [self setupTaskTextLabel];
        [self setupMarkDoneButton];
        [self setupBottomSeparator];
    }
    return self;
}

- (void)setupMarkDoneButton
{
    self.markAsDoneButton = [[UIButton alloc] initWithFrame:CGRectMake(271.0f, self.frame.size.height/2 - 19.0f, 38.0f, 38.0f)];

    [self.markAsDoneButton.layer setShouldRasterize:YES];
    [self.markAsDoneButton.layer setRasterizationScale:[[UIScreen mainScreen] scale]];
    [self.markAsDoneButton.layer setCornerRadius:19.0f];
    [self.markAsDoneButton.layer setBorderWidth:1.0f];
    [self.markAsDoneButton.layer setBackgroundColor:[UIColor softGrayColor].CGColor];
    [self.markAsDoneButton.layer setBorderColor:[UIColor softGrayColor].CGColor];

    [self.markAsDoneButton addTarget:self action:@selector(markAsDone:) forControlEvents:UIControlEventTouchUpInside];

    [self.contentView addSubview:self.markAsDoneButton];
}

- (void)setupDueDateLabel
{
    self.dueDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(6.0f, 10.0f, 234.0f, 21.0f)];
    [self.dueDateLabel setFont:[UIFont effraRegularWithSize:18.0f]];
    [self.dueDateLabel setTextColor:[UIColor blackColor]];

    [self.contentView addSubview:self.dueDateLabel];
}

- (void)setupTaskTextLabel
{
    self.taskTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(6.0f, 35.0f, 234.0f, 21.0f)];

    [self.taskTextLabel setFont:[UIFont effraRegularWithSize:15.0f]];
    [self.taskTextLabel setNumberOfLines:0];
    [self.taskTextLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [self.taskTextLabel setTextColor:[UIColor blackColor]];

    [self.contentView addSubview:self.taskTextLabel];
}

- (void)setupBottomSeparator
{
    UIView *bottomSeparator = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 0.5f, self.frame.size.width, 0.5f)];
    [bottomSeparator setBackgroundColor:[UIColor lightPlumGrayColor]];

    [self.contentView addSubview:bottomSeparator];
}

- (void)setText:(NSString *)text
{
    [self.taskTextLabel setText:text];
    [self.taskTextLabel sizeToFit];
}

- (void)setDueDate:(NSDate *)dueDate
{
    [self.dueDateLabel setText:[[TackDateFormatter sharedInstance] stringFromDate:dueDate]];
}

- (IBAction)markAsDone:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(markAsDone:)]) {
        [self.delegate markAsDone:self];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
