//
//  ScanVideoVC.m
//  APIDemo
//
//  Created by Macx on 2018/6/20.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "ScanVideoVC.h"
#import "VideoCell.h"
#import <MediaPlayer/MediaPlayer.h>

@interface ScanVideoVC ()<UICollectionViewDelegate,UICollectionViewDataSource> {
    UICollectionView *_collectionView;
}

@end

@implementation ScanVideoVC

// MARK: - lifeCircle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"扫描视频";
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5 );
    layout.minimumLineSpacing = 5.0;
    layout.minimumInteritemSpacing = 5.0;
    
    layout.itemSize = CGSizeMake((kAppWidth - 15)/2, (kAppWidth - 15)/2);
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kAppWidth,kAppHeight - 64) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [_collectionView registerClass:[VideoCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:_collectionView];
    NSArray *items = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:[docPath() stringByAppendingString:@"/videos"] error:nil];
    __block NSMutableArray *temArray = [NSMutableArray new];
    [items enumerateObjectsUsingBlock:^(NSString *subStr, NSUInteger idx, BOOL * _Nonnull stop) {
        [temArray addObject:[[docPath() stringByAppendingString:@"/videos"]stringByAppendingString:[NSString stringWithFormat:@"/%@",subStr]]];
    }];
    _dataArray = [NSMutableArray arrayWithArray:temArray];
}

// MARK: - UITableViewDataSource&Delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    VideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell setCellWithData:_dataArray[indexPath.row]];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //播放
    MPMoviePlayerViewController *playViewController = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL fileURLWithPath:_dataArray[indexPath.item]]];
    [self presentMoviePlayerViewControllerAnimated:playViewController];
}
@end
