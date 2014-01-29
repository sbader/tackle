//
//  TackMainViewController.m
//  Tackle
//
//  Created by Scott Bader on 1/26/14.
//  Copyright (c) 2014 Melody Road. All rights reserved.
//

#import "TackMainViewController.h"

#import "TackMainFlowLayout.h"

@interface TackMainViewController ()

@end

@implementation TackMainViewController

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.managedObjectContext = managedObjectContext;

        [self.view setBackgroundColor:[UIColor blueColor]];

        [self setupTopSpace];
        [self setupMainCollectionViewController];
    }
    return self;
}

- (void)setupTopSpace
{
    UIView *topSpaceView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20.0f)];
    [topSpaceView setBackgroundColor:[UIColor lightPlumColor]];

    UIView *bottomSeparator = [[UIView alloc] initWithFrame:CGRectMake(0, 19.5f, self.view.frame.size.width, 0.5f)];
    [bottomSeparator setBackgroundColor:[UIColor lightPlumGrayColor]];
    [topSpaceView addSubview:bottomSeparator];

    [self.view addSubview:topSpaceView];
}

- (void)setupMainCollectionViewController
{
    TackMainFlowLayout *layout  = [[TackMainFlowLayout alloc] init];
    [layout setItemSize:CGSizeMake(self.view.frame.size.width, 67.0f)];

    self.mainCollectionViewController = [[TackMainCollectionViewController alloc] initWithCollectionViewLayout:layout];

    [self.mainCollectionViewController setManagedObjectContext:self.managedObjectContext];
    [self addChildViewController:self.mainCollectionViewController];
    [self.mainCollectionViewController.view setFrame:CGRectMake(0, 20.0f, self.view.frame.size.width, self.view.frame.size.height - 20.0f)];
    [self.view addSubview:self.mainCollectionViewController.view];
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
