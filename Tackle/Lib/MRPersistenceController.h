//
//  MRPersistenceController.h
//  Tackle
//
//  Created by Scott Bader on 4/29/15.
//  Copyright (c) 2015 Melody Road. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreData/CoreData.h>

@interface MRPersistenceController : NSObject

@property (strong, readonly) NSManagedObjectContext *managedObjectContext;

- (void)save;

@end
