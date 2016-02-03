//
//  MRCalendarCollectionViewController.m
//  Tackle
//
//  Created by Scott Bader on 12/28/14.
//  Copyright (c) 2014 Melody Road. All rights reserved.
//

#import "MRCalendarCollectionViewController.h"

#import "MRDateCollectionViewCell.h"

static NSString *dateCellReuseIdentifier = @"CalendarDateCell";

@interface MRCalendarCollectionViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic) NSDate *referenceDate;

@end

@implementation MRCalendarCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.referenceDate = [NSDate date];

    [self.collectionView registerClass:[MRDateCollectionViewCell class] forCellWithReuseIdentifier:dateCellReuseIdentifier];

    self.collectionView.backgroundColor = [UIColor grayBorderColor];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.alwaysBounceHorizontal = YES;
    self.collectionView.alwaysBounceVertical = NO;
    self.collectionView.pagingEnabled = NO;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}

- (NSDate *)dateForIndexPath:(NSIndexPath *)indexPath {
    return [[NSCalendar currentCalendar] dateByAddingUnit:NSCalendarUnitDay value:indexPath.row toDate:self.referenceDate options:0];
}

#pragma mark - Collection View Data Source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 365;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MRDateCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:dateCellReuseIdentifier forIndexPath:indexPath];
    [cell setDate:[self dateForIndexPath:indexPath]];

    return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDate *date = [self dateForIndexPath:indexPath];
    [self.dateSelectionDelegate selectedDate:date];

    return NO;
}

#pragma mark - Collection View Flow Layout Delegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(74, 74);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

@end
