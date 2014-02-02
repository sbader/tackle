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
        [self setupBottomSeparator];
    }
    return self;
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
    self.taskTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(6.0f, 35.0f, 300.0f, 21.0f)];

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

    CGSize textSize = [TackMainCollectionViewCell sizeForTaskTextLabelWithText:text];
    [self.taskTextLabel setFrame:CGRectMake(6, 35, textSize.width, textSize.height)];
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

+ (CGSize)sizeForTaskTextLabelWithText:(NSString *)text
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];

    UIFont *font = [UIFont effraRegularWithSize:15.0f];

    NSDictionary *attributes = @{NSFontAttributeName:[font fontWithSize:15.0f],
                                 NSParagraphStyleAttributeName:paragraphStyle};

    CGRect rect = [text boundingRectWithSize:CGSizeMake(300.0f, MAXFLOAT)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:attributes
                                     context:nil];

    return CGSizeMake(rect.size.width, rect.size.height);
}

@end
