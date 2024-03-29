//
//  MRCreditsViewController.h
//  Tackle
//
//  Created by Scott Bader on 1/26/16.
//  Copyright © 2016 Melody Road. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MRPersistenceController;
@protocol MRArchiveTaskTableViewDelegate;

@interface MRCreditsViewController : UIViewController

- (instancetype)initWithPersistenceController:(MRPersistenceController *)persistenceController;

@property (nonatomic) id<MRArchiveTaskTableViewDelegate> archiveTaskDelegate;

@end
