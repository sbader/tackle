//
//  TackMainViewController.m
//  Tackle
//
//  Created by Scott Bader on 1/26/14.
//  Copyright (c) 2014 Melody Road. All rights reserved.
//

#import "TackMainViewController.h"

#import "TackMainFlowLayout.h"
#import "TackTaskEditView.h"

@interface TackMainViewController ()

@property (nonatomic, strong) TackTaskEditView *editView;

@end

@implementation TackMainViewController

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.managedObjectContext = managedObjectContext;

        [self.view setBackgroundColor:[UIColor darkPlumColor]];

        [self setupMainCollectionViewController];
        [self setupEditView];
        [self setupTopSpace];
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
    [self.mainCollectionViewController setScrollViewDelegate:self];

    [self.mainCollectionViewController setManagedObjectContext:self.managedObjectContext];
    [self addChildViewController:self.mainCollectionViewController];
    [self.mainCollectionViewController.view setFrame:CGRectMake(0, 20.0f, self.view.frame.size.width, self.view.frame.size.height - 20.0f)];

    [self.view addSubview:self.mainCollectionViewController.view];
}

- (void)setupEditView
{
    self.editView = [[TackTaskEditView alloc] initWithFrame:CGRectMake(0, -190.0f, self.view.frame.size.width, 165.0f)];
//    [self.editView setHidden:YES];
//    CALayer *layer = self.editView.layer;
//
//    CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
//    rotationAndPerspectiveTransform.m34 = 1.0 / -1000.0;
//    rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, M_PI * 0.6, 1.0f, 0.0f, 0.0f);
//    layer.anchorPoint = CGPointMake(0.5, 0);
//    layer.transform = rotationAndPerspectiveTransform;

    [self.view addSubview:self.editView];
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

#pragma mark - TackMainCollectionViewScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    CGPoint offset = scrollView.contentOffset;
    CGRect frame = self.editView.frame;
    CGFloat offsetY = -190.0f - (offset.y * 2.1);

    [self.editView setFrame:CGRectMake(frame.origin.x, offsetY, frame.size.width, frame.size.height)];

    CALayer *layer = self.mainCollectionViewController.view.layer;

    if (offset.y <= 0) {
        CGFloat scale = MAX(1 - (ABS(offset.y) * 0.001f), 0.9);
        [layer setTransform:CATransform3DMakeScale(scale, scale, 1)];
    }
    else {
        [layer setTransform:CATransform3DMakeScale(1, 1, 1)];
    }
}

@end
