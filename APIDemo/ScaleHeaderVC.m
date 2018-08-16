//
//  ScaleHeaderVC.m
//  APIDemo
//
//  Created by Chan on 2018/7/5.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "ScaleHeaderVC.h"

@interface ScaleHeaderVC () <UITableViewDelegate,UITableViewDataSource> {
    UIView *_headerView;
    UITableView *_tableView;
}

@end

@implementation ScaleHeaderVC

// MARK: - viewController‘s view’s LifeCircle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _headerView = kInsertViewWithBorderAndCorRadius(self.view, CGRectMake(0, 0, kAppWidth, 150), kColorClear, 0.0, nil, 0);
    _headerView.layer.contents = (id) kIMAGE(@"AppIcon").CGImage;
    _tableView = kInsertTableView(self.view,CGRectMake(0,150, kAppWidth, self.view.frame.size.height - 150), self, self, 0, 0);
}

#pragma mark  -- UITableViewDataSource&Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = @"测试数据";
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isEqual:_tableView]) {
        CGFloat offsetY = _tableView.contentOffset.y + _tableView.contentInset.top;
        CGFloat scale = 1.0;
        if (offsetY < 0) {// 放大
            // 允许下拉放大的最大距离为250
            scale = MIN(1.5, 1 - offsetY / 300);
        } else if (offsetY > 0) { // 缩小
            // 允许向上超过导航条缩小的最大距离为250
            scale = MAX(0.4, 1 - offsetY / 300);
        }
        _headerView.transform = CGAffineTransformMakeScale(scale, scale);
    }
}

// MARK: - memory management
- (void)dealloc {
    if (_tableView) {
        _tableView.delegate = nil;
        _tableView.dataSource = nil;
        _tableView = nil;
    }
    if (_headerView) {
        _headerView = nil;
    }
}
@end
