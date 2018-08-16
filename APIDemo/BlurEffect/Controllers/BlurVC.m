//
//  BlurVC.m
//  APIDemo
//
//  Created by Chan on 2018/7/25.
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
    NSArray *data = @[@{
                                    @"typeName": @"#",
                                    @"colorStr": @"#88AA00",
                                    @"items": @[@"懒猪",
                                                 @"吃货",
                                                 @"女神经",
                                                 @"强迫症晚期"
                                                 ]
                                    },
                                @{
                                    @"typeName": @"🏌",
                                    @"colorStr": @"#88AA00",
                                    @"items": @[@"乒乓球",
                                                 @"高尔夫",
                                                 @"篮球",
                                                 @"足球",
                                                 @"长跑"
                                                 ]
                                    },
                                @{
                                    @"typeName": @"🎵",
                                    @"colorStr": @"#AA0000",
                                    @"items": @[@"DJ",
                                                 @"颅内高潮",
                                                 @"电子",
                                                 @"嘻哈风",
                                                 @"陈奕迅",
                                                 @"有才的王力宏"
                                                 ]
                                    },
                                @{
                                    @"typeName": @"🍴",
                                    @"colorStr": @"#FF3333",
                                    @"items": @[@"牛排",
                                                 @"烧烤",
                                                 @"火锅",
                                                 @"日式铁板烧",
                                                 @"韩国烤肉大排档",
                                                 @"麻辣香锅",
                                                 @"日本拉面",
                                                 @"蛋糕甜点"
                                                 ]
                                    },
                                @{
                                    @"typeName": @"🎬",
                                     @"colorStr": @"#FF44AA",
                                    @"items": @[@"当幸福来敲门",
                                                 @"金三胖的总统之路",
                                                 @"普金大帝自传",
                                                 @"川不靠谱的职场生活",
                                                 @"铁血书生郭沫若",
                                                 @"从善如流马歇尔",
                                                 @"小鬼当家",
                                                 @"听海",
                                                 @"看",
                                                 @"前任",
                                                 @"这个杀手不太冷",
                                                 @"泰坦尼克号",
                                                 @"灵魂三部曲"
                                                 ]}
                      ,@{
                          @"typeName": @"🎬",
                          @"colorStr": @"#FF44AA",
                          @"items": @[@"当幸福来敲门",
                                      @"金三胖的总统之路",
                                      @"普金大帝自传",
                                      @"川不靠谱的职场生活",
                                      @"铁血书生郭沫若",
                                      @"从善如流马歇尔",
                                      @"小鬼当家",
                                      @"听海",
                                      @"看",
                                      @"前任",
                                      @"这个杀手不太冷",
                                      @"泰坦尼克号",
                                      @"灵魂三部曲"
                                      ]},@{
                          @"typeName": @"🎬",
                          @"colorStr": @"#FF44AA",
                          @"items": @[@"当幸福来敲门",
                                      @"金三胖的总统之路",
                                      @"普金大帝自传",
                                      @"川不靠谱的职场生活",
                                      @"铁血书生郭沫若",
                                      @"从善如流马歇尔",
                                      @"小鬼当家",
                                      @"听海",
                                      @"看",
                                      @"前任",
                                      @"这个杀手不太冷",
                                      @"泰坦尼克号",
                                      @"灵魂三部曲"
                                      ]},@{
                          @"typeName": @"🎬",
                          @"colorStr": @"#FF44AA",
                          @"items": @[@"当幸福来敲门",
                                      @"金三胖的总统之路",
                                      @"普金大帝自传",
                                      @"川不靠谱的职场生活",
                                      @"铁血书生郭沫若",
                                      @"从善如流马歇尔",
                                      @"小鬼当家",
                                      @"听海",
                                      @"看",
                                      @"前任",
                                      @"这个杀手不太冷",
                                      @"泰坦尼克号",
                                      @"灵魂三部曲"
                                      ]},@{
                          @"typeName": @"🎬",
                          @"colorStr": @"#FF44AA",
                          @"items": @[@"当幸福来敲门",
                                      @"金三胖的总统之路",
                                      @"普金大帝自传",
                                      @"川不靠谱的职场生活",
                                      @"铁血书生郭沫若",
                                      @"从善如流马歇尔",
                                      @"小鬼当家",
                                      @"听海",
                                      @"看",
                                      @"前任",
                                      @"这个杀手不太冷",
                                      @"泰坦尼克号",
                                      @"灵魂三部曲"
                                      ]},@{
                          @"typeName": @"🎬",
                          @"colorStr": @"#FF44AA",
                          @"items": @[@"当幸福来敲门",
                                      @"金三胖的总统之路",
                                      @"普金大帝自传",
                                      @"川不靠谱的职场生活",
                                      @"铁血书生郭沫若",
                                      @"从善如流马歇尔",
                                      @"小鬼当家",
                                      @"听海",
                                      @"看",
                                      @"前任",
                                      @"这个杀手不太冷",
                                      @"泰坦尼克号",
                                      @"灵魂三部曲"
                                      ]},@{
                          @"typeName": @"🎬",
                          @"colorStr": @"#FF44AA",
                          @"items": @[@"当幸福来敲门",
                                      @"金三胖的总统之路",
                                      @"普金大帝自传",
                                      @"川不靠谱的职场生活",
                                      @"铁血书生郭沫若",
                                      @"从善如流马歇尔",
                                      @"小鬼当家",
                                      @"听海",
                                      @"看",
                                      @"前任",
                                      @"这个杀手不太冷",
                                      @"泰坦尼克号",
                                      @"灵魂三部曲"
                                      ]},@{
                          @"typeName": @"🎬",
                          @"colorStr": @"#FF44AA",
                          @"items": @[@"当幸福来敲门",
                                      @"金三胖的总统之路",
                                      @"普金大帝自传",
                                      @"川不靠谱的职场生活",
                                      @"铁血书生郭沫若",
                                      @"从善如流马歇尔",
                                      @"小鬼当家",
                                      @"听海",
                                      @"看",
                                      @"前任",
                                      @"这个杀手不太冷",
                                      @"泰坦尼克号",
                                      @"灵魂三部曲"
                                      ]}];
    /*for (int i = 0; i < 20; i  ++) {
        BlurModel *model = [BlurModel new];
        model.colorStr =  i == 0 ?@"#000000": i == 1 ? @"#FF44AA" : i ==2 ? @"#FF3333":i ==3 ? @"#88AA00": i == 4 ?@"#AA0000": i %2 ==0 ? @"#33FF33":@"#FFA488";
        NSMutableArray *items = [NSMutableArray new];
        for (int j = 0; j < i + 1; j ++) {
            [items addObject:[NSString stringWithFormat:@"%i==%i",i,j]];
        }
        model.items = items;
        [_dataArray addObject:model];
    }*/
    for (int i = 0; i < data.count; i ++) {
        BlurModel *model = [BlurModel new];
        [model setValuesForKeysWithDictionary:data[i]];
        [_dataArray addObject:model];
    }
    //初始化tableView
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
    iToastText(tagStr);
}
@end
