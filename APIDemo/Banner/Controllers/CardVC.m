//
//  CardVC.m
//  APIDemo
//
//  Created by Macx on 2018/8/3.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "CardVC.h"
#import "CustomScrollView.h"
#define kCellID @"cell"
#import <TYCyclePagerView/TYCyclePagerView.h>
#import "PreViewCell.h"

@interface CardVC () <UITableViewDataSource,UITableViewDelegate,TYCyclePagerViewDataSource,TYCyclePagerViewDelegate> {
    UITableView *_tableView;
    
}

@end

@implementation CardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    _tableView = kInsertTableView(self.view, CGRectMake(0, 0, kAppWidth, self.view.height), self, self, UITableViewStylePlain, 0);
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellID];
    
    TYCyclePagerView *pagerView = [[TYCyclePagerView alloc] initWithFrame:CGRectMake(0, 0, kAppWidth, 200)];
    pagerView.layer.borderWidth = 1;
    pagerView.isInfiniteLoop = YES;
    pagerView.autoScrollInterval = 3.0;
    pagerView.dataSource = self;
    pagerView.delegate = self;
    [pagerView  registerClass:[PreViewCell class] forCellWithReuseIdentifier:kCellID];
    _tableView.tableHeaderView = pagerView;
}

// MARK: - UITableViewDataSource&Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    cell.textLabel.text = @"cell";
    return cell;
}

- (NSInteger)numberOfItemsInPagerView:(TYCyclePagerView *)pageView {
    return 3;
}

- (__kindof UICollectionViewCell *)pagerView:(TYCyclePagerView *)pagerView cellForItemAtIndex:(NSInteger)index {
    PreViewCell *cell = [pagerView dequeueReusableCellWithReuseIdentifier:kCellID forIndex:index];
    [cell setCellWithData:@"AppIcon"];
    return cell;
}
@end
