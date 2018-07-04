//
//  ScanPhotoVC.m
//  APIDemo
//
//  Created by Chan on 2018/6/20.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "ScanPhotoVC.h"
#import "PhotoCell.h"
#import "PreviewPhotoVC.h"

#import <AssetsLibrary/AssetsLibrary.h>
@interface ScanPhotoVC () <UICollectionViewDelegate,UICollectionViewDataSource> {
    UICollectionView *_collectionView;
    NSMutableArray *_dataArray;
    ALAssetsLibrary *_library;
}

@end

@implementation ScanPhotoVC

// MARK: - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _library = [ALAssetsLibrary new];
    _dataArray = [NSMutableArray new];
    [self setUI];
    [self loadData];
    //下拉刷新
    @weakify(self);
    [_collectionView addLegendFooterWithRefreshingBlock:^{
        @strongify(self);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self->_collectionView.header endRefreshing];
            [self->_collectionView reloadData];
        });
    }];
}

// MARK: - loadData
- (void)loadData {
    @weakify(self);
    [_library enumerateGroupsWithTypes:ALAssetsGroupAll
                            usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                                if (group) {
                                    [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                                        @strongify(self);
                                        if (result) {
                                            [self->_dataArray addObject:result];
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                [self->_collectionView reloadData];
                                            });
                                        }
                                    }];
                                }
                            } failureBlock:^(NSError *error) {
                                
                            }];
}

// MARK: - setUI
- (void)setUI {
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.itemSize = CGSizeMake((kAppWidth - 20)/3, (kAppWidth - 20)/3);
    layout.minimumLineSpacing = 5.0;
    layout.minimumInteritemSpacing = 5.0;
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kAppWidth,kAppHeight ) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [_collectionView registerClass:[PhotoCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:_collectionView];
}

// MARK: - UICollectionViewDataSource&Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell  setCellWithData:_dataArray[indexPath.item]];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PreviewPhotoVC *VC = [PreviewPhotoVC new];
    VC.dataArray = _dataArray;
    VC.currentIndex = indexPath.row;
    [self.navigationController pushViewController:VC animated:YES];
}

// MARK: - memory management

- (void)dealloc {
    if (_collectionView) {
        _collectionView.delegate = nil;
        _collectionView.dataSource = nil;
    }
    if (_dataArray) {
        [_dataArray removeAllObjects];
        _dataArray = nil;
    }
}
@end
