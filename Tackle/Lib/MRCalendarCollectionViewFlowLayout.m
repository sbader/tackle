//
//  MRCalendarCollectionViewFlowLayout.m
//  Tackle
//
//  Created by Scott Bader on 12/28/14.
//  Copyright (c) 2014 Melody Road. All rights reserved.
//

#import "MRCalendarCollectionViewFlowLayout.h"

@implementation MRCalendarCollectionViewFlowLayout

- (id)init {
    self = [super init];

    if (self) {
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.minimumLineSpacing = 0.0;
    }

    return self;
}

@end
