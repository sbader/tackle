//
//  MRCreditsViewController.m
//  Tackle
//
//  Created by Scott Bader on 1/26/16.
//  Copyright © 2016 Melody Road. All rights reserved.
//

#import "MRCreditsViewController.h"

@interface MRCreditsViewController ()

@end

@implementation MRCreditsViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Tackle";
    self.view.backgroundColor = [UIColor blackColor];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                             style:UIBarButtonItemStyleDone
                                                                            target:self
                                                                            action:@selector(handleDoneButton:)];
}

- (void)handleDoneButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
