//
//  TackMainCollectionViewController.h
//  Tackle
//
//  Created by Scott Bader on 1/27/14.
//  Copyright (c) 2014 Melody Road. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TackMainCollectionViewController : UICollectionViewController <NSFetchedResultsControllerDelegate, UITextFieldDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>

@property (assign, nonatomic) id <UIScrollViewDelegate> scrollViewDelegate;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;


@end
