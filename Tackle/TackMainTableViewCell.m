//
//  TackMainTableViewCell.m
//  Tackle
//
//  Created by Scott Bader on 1/22/14.
//  Copyright (c) 2014 Melody Road. All rights reserved.
//

#import "TackMainTableViewCell.h"

@implementation TackMainTableViewCell

@synthesize delegate = _delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)updateTask:(Task *)task
{
    [self setTask:task];
    [self reloadCell];
}

- (void)reloadCell
{
    [self.taskTextLabel setNumberOfLines:0];
    [self.taskTextLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [self.taskTextLabel setText:self.task.text];
    [self.taskTextLabel sizeToFit];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDoesRelativeDateFormatting:YES];

    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];

    [self.dueDateLabel setText:[dateFormatter stringFromDate:self.task.dueDate]];
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
