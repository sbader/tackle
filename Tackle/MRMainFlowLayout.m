//
//  MRMainFlowLayout.m
//  Tackle
//
//  Created by Scott Bader on 1/28/14.
//  Copyright (c) 2014 Melody Road. All rights reserved.
//

#import "MRMainFlowLayout.h"

@implementation MRMainFlowLayout

- (id)init
{
    self = [super init];

    if (self) {
        [self setMinimumInteritemSpacing:0];
        [self setMinimumLineSpacing:0];
    }

    return self;
}

@end
