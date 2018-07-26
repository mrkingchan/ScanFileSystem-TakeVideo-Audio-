//
//  BlurVC.m
//  APIDemo
//
//  Created by Macx on 2018/7/25.
//  Copyright © 2018年 Chan. All rights reserved.
//

#import "BlurVC.h"
#import "BlurModel.h"
#import "BlurCell.h"

@interface BlurVC ()<UITableViewDelegate,UITableViewDataSource,TagClickedDelegate> {
    UITableView *_tableView;
    NSMutableArray  *_dataArray;
}

@end

@implementation BlurVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.title = @"标签";
    _dataArray = [NSMutableArray new];
    for (int i = 0; i < 20; i  ++) {
        BlurModel *model = [BlurModel new];
        model.colorStr =  i == 0 ?@"#000000": i == 1 ? @"#FF44AA" : i ==2 ? @"#FF3333":i ==3 ? @"#88AA00": i == 4 ?@"#AA0000": i %2 ==0 ? @"#33FF33":@"#FFA488";
        NSMutableArray *items = [NSMutableArray new];
        for (int j = 0; j < i + 1; j ++) {
            [items addObject:[NSString stringWithFormat:@"%i==%i",i,j]];
        }
        model.items = items;
        [_dataArray addObject:model];
    }
    _tableView = kInsertTableView(self.view, CGRectMake(0, 0, kAppWidth,self.view.height ), self, self, 0, UITableViewCellSeparatorStyleSingleLine );
}

// MARK: - UITableViewDataSource&Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BlurCell *cell = [tableView dequeueReusableCellWithIdentifier:[BlurCell cellIdentifier]];
    if (!cell) {
        cell = [[BlurCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:[BlurCell cellIdentifier]];
    }
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.containerView.delegate = self;
    [cell setCellWithData:_dataArray[indexPath.row]];
    cell.completeBlock = ^(NSString *tagStr) {
        NSLog(@"你点击的是%@",tagStr);
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [BlurCell cellHeightWithModel:_dataArray[indexPath.row]];
}

// MARK: - TagContainerViewDelegate

- (void)tagClickedWithContainerView:(ContainerView *)containerView tagStr:(NSString *)tagStr {
    NSLog(@"你点击的是:%@",tagStr);
}
@end
