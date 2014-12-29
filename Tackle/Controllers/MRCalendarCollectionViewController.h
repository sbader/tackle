//
//  MRCalendarCollectionViewController.h
//  Tackle
//
//  Created by Scott Bader on 12/28/14.
//  Copyright (c) 2014 Melody Road. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MRDateSelectionDelegate;

@interface MRCalendarCollectionViewController : UICollectionViewController

@property (nonatomic) id<MRDateSelectionDelegate> dateSelectionDelegate;

@end

@protocol MRDateSelectionDelegate <NSObject>

- (void)selectedDate:(NSDate *)date;

@end
