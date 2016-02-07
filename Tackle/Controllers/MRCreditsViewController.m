//
//  MRCreditsViewController.m
//  Tackle
//
//  Created by Scott Bader on 1/26/16.
//  Copyright © 2016 Melody Road. All rights reserved.
//

#import "MRCreditsViewController.h"

#import "PaintCodeStyleKit.h"
#import "MRPersistenceController.h"
#import "MRArchiveViewController.h"

#import <MessageUI/MFMailComposeViewController.h>

@interface MRCreditsViewController () <MFMailComposeViewControllerDelegate>

@property (nonatomic) UIView *topContainerView;
@property (nonatomic) UIView *linksView;
@property (nonatomic) UIView *bottomTextView;
@property (nonatomic) MRPersistenceController *persistenceController;

@end

@implementation MRCreditsViewController

- (instancetype)initWithPersistenceController:(MRPersistenceController *)persistenceController {
    self = [super init];

    if (self) {
        _persistenceController = persistenceController;
    }

    return self;

}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = NSLocalizedString(@"Credits Title", nil);
    self.view.backgroundColor = [UIColor grayBackgroundColor];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Credits Done", nil)
                                                                             style:UIBarButtonItemStyleDone
                                                                            target:self
                                                                            action:@selector(handleDoneButton:)];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Credits Archive", nil)
                                                                             style:UIBarButtonItemStyleDone
                                                                            target:self
                                                                            action:@selector(handleViewArchiveButton:)];


    [self setupTopSection];
    [self setupLinks];
    [self setupBottomText];
    [self setupConstraints];
}

- (void)setupTopSection {
    self.topContainerView = [[UIView alloc] init];
    self.topContainerView.translatesAutoresizingMaskIntoConstraints = NO;

    [self.view addSubview:self.topContainerView];

    [self.topContainerView horizontalConstraintsMatchSuperview];

    UIImageView *imageView = [[UIImageView alloc] initWithImage:[PaintCodeStyleKit imageOfCreditsTIcon]];
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.topContainerView addSubview:imageView];

    imageView.tintColor = [UIColor offWhiteBackgroundColor];
    [imageView topConstraintMatchesSuperview];
    [imageView horizontalCenterConstraintMatchesSuperview];

    [imageView addConstraint:[NSLayoutConstraint constraintWithItem:imageView
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationLessThanOrEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:212.0]];

    [imageView addConstraint:[NSLayoutConstraint constraintWithItem:imageView
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:imageView
                                                          attribute:NSLayoutAttributeHeight
                                                         multiplier:212.0/68.0 constant:0.0]];

    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.translatesAutoresizingMaskIntoConstraints = NO;
    textLabel.text = NSLocalizedString(@"Designed and Developed by Scott Bader", nil);
    textLabel.textColor = [UIColor offWhiteBackgroundColor];
    textLabel.numberOfLines = 0;
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.adjustsFontSizeToFitWidth = YES;
    textLabel.minimumScaleFactor = 0.85;
    textLabel.font = [UIFont fontForCreditsTextLabel];

    [self.topContainerView addSubview:textLabel];

    UILabel *versionLabel = [[UILabel alloc] init];

    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];

    NSString *version = info[@"CFBundleShortVersionString"];
    NSString *build = info[(NSString *)kCFBundleVersionKey];

    versionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    versionLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Tackle %@ (%@)", nil), version, build];
    versionLabel.font = [UIFont fontForCreditsVersionText];
    versionLabel.textAlignment = NSTextAlignmentCenter;
    versionLabel.textColor = [UIColor offWhiteBackgroundColor];

    [self.topContainerView addSubview:versionLabel];

    [versionLabel horizontalConstraintsMatchSuperview];
    [versionLabel topConstraintBelowView:imageView withConstant:20.0];
    [versionLabel staticHeightConstraint:22.0];

    [textLabel leadingConstraintMatchesSuperviewWithConstant:80.0];
    [textLabel trailingConstraintMatchesSuperviewWithConstant:-80.0];
    [textLabel addConstraint:[textLabel.heightAnchor constraintGreaterThanOrEqualToConstant:22.0]];

    [textLabel topConstraintBelowView:versionLabel withConstant:18.0];
    [textLabel bottomConstraintMatchesSuperview];
}

- (void)setupLinks {
    self.linksView = [[UIView alloc] init];
    self.linksView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.linksView];

    [self.linksView horizontalConstraintsMatchSuperview];

    UIButton *feedbackButton = [UIButton buttonWithType:UIButtonTypeSystem];
    feedbackButton.tintColor = [UIColor offWhiteBackgroundColor];

    NSMutableAttributedString *feedbackAttributedTitle = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"Send Feedback", nil)];
    [feedbackAttributedTitle addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, feedbackAttributedTitle.length)];


    [feedbackButton setAttributedTitle:feedbackAttributedTitle forState:UIControlStateNormal];
    [feedbackButton addTarget:self action:@selector(handleFeedbackButton:) forControlEvents:UIControlEventTouchUpInside];
    feedbackButton.titleLabel.font = [UIFont fontForCreditsLinks];
    feedbackButton.translatesAutoresizingMaskIntoConstraints = NO;

    [self.linksView addSubview:feedbackButton];

    UIButton *rateButton = [UIButton buttonWithType:UIButtonTypeSystem];
    rateButton.tintColor = [UIColor offWhiteBackgroundColor];

    NSMutableAttributedString *rateAttributedTitle = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"Rate in the App Store", nil)];
    [rateAttributedTitle addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, rateAttributedTitle.length)];

    [rateButton setAttributedTitle:rateAttributedTitle forState:UIControlStateNormal];
    [rateButton addTarget:self action:@selector(handleRateButton:) forControlEvents:UIControlEventTouchUpInside];
    rateButton.titleLabel.font = [UIFont fontForCreditsLinks];
    rateButton.translatesAutoresizingMaskIntoConstraints = NO;

    [self.linksView addSubview:rateButton];

    [feedbackButton horizontalCenterConstraintMatchesSuperview];
    [feedbackButton topConstraintMatchesSuperview];
    [feedbackButton staticHeightConstraint:22.0];

    [rateButton horizontalCenterConstraintMatchesSuperview];
    [rateButton topConstraintBelowView:feedbackButton withConstant:0.0];
    [rateButton bottomConstraintMatchesSuperview];
    [rateButton staticHeightConstraint:22.0];
}

- (void)setupBottomText {
    self.bottomTextView = [[UIView alloc] init];
    self.bottomTextView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.bottomTextView];

    [self.bottomTextView horizontalConstraintsMatchSuperview];

    UILabel *copyrightLabel = [[UILabel alloc] init];
    copyrightLabel.translatesAutoresizingMaskIntoConstraints = NO;
    copyrightLabel.text = NSLocalizedString(@"© 2016 Melody Road, LLC", nil);
    copyrightLabel.font = [UIFont fontForCreditsBottomText];
    copyrightLabel.textAlignment = NSTextAlignmentCenter;
    copyrightLabel.textColor = [UIColor offWhiteBackgroundColor];

    [self.bottomTextView addSubview:copyrightLabel];

    [copyrightLabel topConstraintMatchesSuperview];
    [copyrightLabel horizontalCenterConstraintMatchesSuperview];
    [copyrightLabel bottomConstraintMatchesSuperview];
    [copyrightLabel staticHeightConstraint:22.0];
}

- (void)setupConstraints {
    [self.view addConstraint:[self.topContainerView.topAnchor constraintGreaterThanOrEqualToAnchor:self.view.topAnchor constant:10.0]];
    NSLayoutConstraint *topLowPriorityConstraint = [self.topContainerView.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:80.0];
    topLowPriorityConstraint.priority = UILayoutPriorityDefaultLow;
    [self.view addConstraint:topLowPriorityConstraint];
    [self.view addConstraint:[self.topContainerView.topAnchor constraintLessThanOrEqualToAnchor:self.view.topAnchor constant:80.0]];

    [self.view addConstraint:[self.topContainerView.bottomAnchor constraintLessThanOrEqualToAnchor:self.linksView.topAnchor constant:-20.0]];

    [self.linksView bottomConstraintAboveView:self.bottomTextView withConstant:-35.0];
    [self.bottomTextView bottomConstraintMatchesSuperviewWithConstant:-35.0];
}

- (void)handleDoneButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)handleFeedbackButton:(id)sender {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
        mailController.mailComposeDelegate = self;
        mailController.subject = NSLocalizedString(@"Tackle Feedback", nil);
        [mailController setToRecipients:@[@"Tackle Feedback <tackle@melodyroad.com>"]];

        [self presentViewController:mailController animated:true completion:nil];
    }
    else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Email Not Configured", nil)
                                                                                 message:NSLocalizedString(@"Your device is not configured to send email.", nil)
                                                                          preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction *closeAction = [UIAlertAction actionWithTitle:@"Close" style:UIAlertActionStyleCancel handler:nil];

        [alertController addAction:closeAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)handleRateButton:(id)sender {
    NSURL *rateURL = [NSURL URLWithString:[NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@", @"1079040532"]];
    [[UIApplication sharedApplication] openURL:rateURL];
}

- (void)handleViewArchiveButton:(id)sender {
    MRArchiveViewController *vc = [[MRArchiveViewController alloc] initWithPersistenceController:self.persistenceController];
    vc.archiveTaskDelegate = self.archiveTaskDelegate;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Mail Compose Delegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(nullable NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
