//
//  MRPersistenceController.h
//  Tackle
//
//  Created by Scott Bader on 4/28/15.
//  Copyright (c) 2015 Melody Road. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreData/CoreData.h>

@interface MRReadOnlyPersistenceController : NSObject

@property (readonly) NSManagedObjectContext *managedObjectContext;

- (instancetype)initWithCallback:(void(^)())callback;

@end
