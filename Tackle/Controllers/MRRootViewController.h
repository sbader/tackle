//
//  MRRootViewController.h
//  Tackle
//
//  Created by Scott Bader on 12/27/14.
//  Copyright (c) 2014 Melody Road. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MRRootViewController : UIViewController

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

@end