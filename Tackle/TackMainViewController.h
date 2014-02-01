//
//  TackMainViewController.h
//  Tackle
//
//  Created by Scott Bader on 1/26/14.
//  Copyright (c) 2014 Melody Road. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TackMainCollectionViewController.h"

@interface TackMainViewController : UIViewController <TackMainCollectionViewScrollViewDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) TackMainCollectionViewController *mainCollectionViewController;

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

@end