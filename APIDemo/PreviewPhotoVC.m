//
//  PreviewPhotoVC.m
//  APIDemo
//
//  Created by Macx on 2018/7/2.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "PreviewPhotoVC.h"

#import "PreViewCell.h"
#import "PageEnableLayout.h"

@interface PreviewPhotoVC () <UICollectionViewDelegate,UICollectionViewDataSource> {
    UICollectionView *_collectionView;
}
@end

@implementation PreviewPhotoVC

// MARK: - viewController's view's lifeCircle
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = [NSString stringWithFormat:@"%zd/%zd",_currentIndex + 1,_dataArray.count];
    PageEnableLayout *layout = [PageEnableLayout new];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kAppWidth,kAppHeight) collectionViewLayout:layout];
    _collectionView.decelerationRate = 10;
    _collectionView.pagingEnabled = YES;
    _collectionView.backgroundColor = [UIColor blackColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [_collectionView registerClass:[PreViewCell class] forCellWithReuseIdentifier:@"cell"];
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
    PreViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell setCellWithData:_dataArray[indexPath.row]];
    return cell;
}

// MARK: - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x / kAppWidth;
    self.navigationItem.title = [NSString stringWithFormat:@"%zd/%zd",index + 1,_dataArray.count];
}

@end
