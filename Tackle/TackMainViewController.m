//
//  TackMainViewController.m
//  Tackle
//
//  Created by Scott Bader on 1/26/14.
//  Copyright (c) 2014 Melody Road. All rights reserved.
//

#import "TackMainViewController.h"

@interface TackMainViewController ()

@end

@implementation TackMainViewController

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.managedObjectContext = managedObjectContext;
        self.mainTableViewController = [[TackMainTableViewController alloc] init];
        [self.mainTableViewController setManagedObjectContext:self.managedObjectContext];
        [self addChildViewController:self.mainTableViewController];
        UIView *topSpaceView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20.0f)];
        [topSpaceView setBackgroundColor:[UIColor lightPlumColor]];

        [self.mainTableViewController.view setFrame:CGRectMake(0, 20.0f, self.view.frame.size.width, self.view.frame.size.height - 20.0f)];
        [self.view setBackgroundColor:[UIColor blueColor]];

        [self.view addSubview:topSpaceView];
        [self.view addSubview:self.mainTableViewController.view];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
