//
//  MRMainViewController.h
//  Tackle
//
//  Created by Scott Bader on 1/26/14.
//  Copyright (c) 2014 Melody Road. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MRMainCollectionViewController.h"
#import "MRTaskEditView.h"

const extern CGFloat kMREditViewHeight;
const extern CGFloat kMRCollectionViewStartOffset;
const extern CGFloat kMRCollectionViewEndOffset;

@interface MRMainViewController : UIViewController <MRMainCollectionViewScrollViewDelegate, MRMainCollectionViewSelectionDelegate, MRTaskEditViewDelegate, MRMainCollectionViewPanGestureDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) MRMainCollectionViewController *mainCollectionViewController;

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;
- (void)taskEditViewDidReturnWithText:(NSString *)text dueDate:(NSDate *)dueDate;
- (void)selectTask:(Task *)task;

@end
