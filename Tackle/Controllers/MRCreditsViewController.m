//
//  MRCreditsViewController.m
//  Tackle
//
//  Created by Scott Bader on 1/26/16.
//  Copyright © 2016 Melody Road. All rights reserved.
//

#import "MRCreditsViewController.h"
#import "PaintCodeStyleKit.h"
#import <MessageUI/MFMailComposeViewController.h>

@interface MRCreditsViewController () <MFMailComposeViewControllerDelegate>

@property (nonatomic) UIView *topContainerView;
@property (nonatomic) UIView *linksView;
@property (nonatomic) UIView *bottomTextView;

@end

@implementation MRCreditsViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = NSLocalizedString(@"Credits Title", nil); // Tackle
    self.view.backgroundColor = [UIColor darkGrayBackgroundColor];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Credits Done", nil) // Credits
                                                                             style:UIBarButtonItemStyleDone
                                                                            target:self
                                                                            action:@selector(handleDoneButton:)];

    [self setupTopSection];
    [self setupLinks];
    [self setupBottomText];
    [self setupConstraints];
}

- (void)setupTopSection {
    self.topContainerView = [[UIView alloc] init];
    self.topContainerView.translatesAutoresizingMaskIntoConstraints = NO;

    [self.view addSubview:self.topContainerView];

    [self.topContainerView horizontalCenterConstraintMatchesSuperview];


    UIImageView *imageView = [[UIImageView alloc] initWithImage:[PaintCodeStyleKit imageOfCreditsTIcon]];
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.topContainerView addSubview:imageView];

    imageView.tintColor = [UIColor whiteColor];
    [imageView topConstraintMatchesSuperview];
    [imageView leadingConstraintMatchesSuperview];
    [imageView trailingConstraintMatchesSuperview];
    [imageView staticWidthConstraint:212.0];
    [imageView staticHeightConstraint:68.0];

    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.translatesAutoresizingMaskIntoConstraints = NO;
    textLabel.text = NSLocalizedString(@"Designed and Developed by Scott Bader", nil);
    textLabel.textColor = [UIColor whiteColor];
    textLabel.numberOfLines = 2;
    textLabel.textAlignment = NSTextAlignmentCenter;
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
    versionLabel.textColor = [UIColor whiteColor];

    [self.topContainerView addSubview:versionLabel];

    [versionLabel horizontalConstraintsMatchSuperview];
    [versionLabel topConstraintBelowView:imageView withConstant:32.0];

    [textLabel staticWidthConstraint:212.0];
    [textLabel horizontalCenterConstraintMatchesView:imageView];

    [textLabel topConstraintBelowView:versionLabel withConstant:18.0];
    [textLabel bottomConstraintMatchesSuperview];
}

- (void)setupLinks {
    self.linksView = [[UIView alloc] init];
    self.linksView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.linksView];

    [self.linksView horizontalConstraintsMatchSuperview];

    UIButton *feedbackButton = [UIButton buttonWithType:UIButtonTypeSystem];
    feedbackButton.tintColor = [UIColor whiteColor];

    NSMutableAttributedString *feedbackAttributedTitle = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"Send Feedback", nil)];
    [feedbackAttributedTitle addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, feedbackAttributedTitle.length)];


    [feedbackButton setAttributedTitle:feedbackAttributedTitle forState:UIControlStateNormal];
    [feedbackButton addTarget:self action:@selector(handleFeedbackButton:) forControlEvents:UIControlEventTouchUpInside];
    feedbackButton.titleLabel.font = [UIFont fontForCreditsLinks];
    feedbackButton.translatesAutoresizingMaskIntoConstraints = NO;

    [self.linksView addSubview:feedbackButton];

    UIButton *rateButton = [UIButton buttonWithType:UIButtonTypeSystem];
    rateButton.tintColor = [UIColor whiteColor];

    NSMutableAttributedString *rateAttributedTitle = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"Rate in the App Store", nil)];
    [rateAttributedTitle addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, rateAttributedTitle.length)];

    [rateButton setAttributedTitle:rateAttributedTitle forState:UIControlStateNormal];
    [rateButton addTarget:self action:@selector(handleRateButton:) forControlEvents:UIControlEventTouchUpInside];
    rateButton.titleLabel.font = [UIFont fontForCreditsLinks];
    rateButton.translatesAutoresizingMaskIntoConstraints = NO;

    [self.linksView addSubview:rateButton];

    [feedbackButton horizontalCenterConstraintMatchesSuperview];
    [feedbackButton topConstraintMatchesSuperview];

    [rateButton horizontalCenterConstraintMatchesSuperview];
    [rateButton topConstraintBelowView:feedbackButton withConstant:0.0];
    [rateButton bottomConstraintMatchesSuperview];
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
    copyrightLabel.textColor = [UIColor whiteColor];

    [self.bottomTextView addSubview:copyrightLabel];

    [copyrightLabel topConstraintMatchesSuperview];
    [copyrightLabel horizontalCenterConstraintMatchesSuperview];
    [copyrightLabel bottomConstraintMatchesSuperview];
}

- (void)setupConstraints {
    [self.topContainerView topConstraintMatchesSuperviewWithConstant:50.0];
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
                                                                                 message:NSLocalizedString(@"Your device is not configured to send email. You can configure an email address in settings or send an email directly to tackle@melodyroad.com.", nil)
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

#pragma mark - Mail Compose Delegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(nullable NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
