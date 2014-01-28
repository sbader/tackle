//
//  TackMainTableViewCell.m
//  Tackle
//
//  Created by Scott Bader on 1/22/14.
//  Copyright (c) 2014 Melody Road. All rights reserved.
//

#import "TackMainTableViewCell.h"
#import "TackDateFormatter.h"

@implementation TackMainTableViewCell

@synthesize delegate = _delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundColor:[UIColor lightPlumColor]];

        [self setupDueDateLabel];
        [self setupTaskTextLabel];
        [self setupMarkDoneButton];
    }
    return self;
}

- (void)setupMarkDoneButton
{
    self.markAsDoneButton = [[UIButton alloc] initWithFrame:CGRectMake(271.0f, 10.0f, 38.0f, 38.0f)];
    [self.markAsDoneButton setTitle:@"Done" forState:UIControlStateNormal];
    [self.markAsDoneButton sizeToFit];
    [self.markAsDoneButton setTitleColor:[UIColor midOpaqueGrayColor] forState:UIControlStateNormal];

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

- (void)setText:(NSString *)text
{
    [self.taskTextLabel setText:text];
    [self.taskTextLabel sizeToFit];
}

- (void)setDueDate:(NSDate *)dueDate
{
    [self.dueDateLabel setText:[[TackDateFormatter sharedInstance] stringFromDate:dueDate]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)markAsDone:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(markAsDone:)]) {
        [self.delegate markAsDone:self];
    }
}

@end
