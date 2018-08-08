//
//  BannerVC.m
//  APIDemo
//
//  Created by Macx on 2018/7/31.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "BannerVC.h"
#import "HeadeReusableView.h"
#import <SDCycleScrollView/SDCycleScrollView.h>
#import "UICollectionSectionViewFlowLayout.h"
#import "CardVC.h"

#define kHeaderID @"header"
#define kCellID  @"UICollectionViewCell"

@interface BannerVC () <UICollectionViewDelegate,UICollectionViewDataSource,SDCycleScrollViewDelegate,UICollectionViewDelegateFlowLayout> {
    UICollectionView *_collectionView;
    SDCycleScrollView *_bannerView;
    UIView *_headerView;
}

@end

@implementation BannerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    UICollectionSectionViewFlowLayout *layout = [[UICollectionSectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((kScreenWidth - 15)/2.0, (kScreenWidth - 15)/2.0);
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    layout.minimumLineSpacing = 5.0;
    layout.minimumInteritemSpacing = 5.0;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[HeadeReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeaderID];
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kCellID];
    _headerView = kInsertViewWithBorderAndCorRadius(self.view, CGRectMake(0, 0, kAppWidth, 200), [UIColor whiteColor], 0.0, nil, 0.0);
    _bannerView = [SDCycleScrollView  cycleScrollViewWithFrame:CGRectMake(0, 0, kAppWidth, 200) delegate:self placeholderImage:[UIImage imageNamed:@"AppIcon"]];
    _bannerView.localizationImageNamesGroup = @[@"tabbar_1_s",@"tabbar_1_s",@"tabbar_1_s",@"tabbar_1_s"];
    _bannerView.autoScroll = YES;
    [_headerView addSubview:_bannerView];
    //头部
    @weakify(self);
    [_collectionView addLegendHeaderWithRefreshingBlock:^{
        @strongify(self);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self->_collectionView.header endRefreshing];
        });
    }];
    
    //尾部
    [_collectionView  addLegendFooterWithRefreshingBlock:^{
        @strongify(self);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self->_collectionView.footer  endRefreshing];
        });
    }];
}


#pragma mark  -- UIColletioncViewDataSource&Delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 100;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellID forIndexPath:indexPath];
    cell.backgroundColor = kRandomColor;
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    iToastText(@"cell!");
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableView = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        HeadeReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeaderID forIndexPath:indexPath];
        [headerView addSubview:_headerView];
        reusableView = headerView;
    }
    return reusableView;
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(kAppWidth, 200);
}

// MARK: - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    [self.navigationController pushViewController:[CardVC new] animated:YES];
}
@end
