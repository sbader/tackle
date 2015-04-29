//
//  MRPersistenceController.h
//  Tackle
//
//  Created by Scott Bader on 4/29/15.
//  Copyright (c) 2015 Melody Road. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MRPersistenceController : NSObject

@property (strong, readonly) NSManagedObjectContext *managedObjectContext;

- (id)initWithCallback:(void(^)())callback;
- (void)save;

@end
